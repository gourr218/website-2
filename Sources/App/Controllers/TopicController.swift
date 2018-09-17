import Vapor
import Leaf
import FluentPostgreSQL

final class TopicController {

    func renderList(req: Request) throws -> Future<Response> {
        return Topic.query(on: req).filter(\.isArchived == false).all().flatMap { topics in
            let user = try req.authenticated(User.self)

            let topicsWithVotes = try topics.map { topic in
                try topic.userVotes.query(on: req).all().map { topicVotes in
                    TopicWithVotes(
                        topic: topic,
                        votes: topicVotes.count,
                        currentUserVoted: topicVotes.contains(where: { $0.id == user?.id })
                    )
                }
            }.flatten(on: req).map { $0.sorted(by: {$0.votes > $1.votes}) }

            let viewData = ViewData.TopicList(
                appInfo: try ViewData.appInfo(on: req),
                topicsWithVotes: topicsWithVotes
            )

            return try req.view().render("Topic/list", viewData).encode(for: req)
        }
    }

    func create(req: Request) throws -> Future<Response> {
        guard let user: User = try req.authenticated() else {
            return req.future(req.redirect(to: "/topics"))
        }

        return try req.content.decode(TopicForm.self).flatMap { topicForm in
            if !topicForm.isValid {
                return req.future(req.redirect(to: "/topics"))
            }

            let userId = try user.requireID()
            return Topic(description: topicForm.description, userID: userId)
                .save(on: req)
                .flatMap { topic in
                return topic.userVotes.attach(user, on: req)
            }.transform(to: req.redirect(to: "/topics"))
        }
    }

    func vote(req: Request) throws -> Future<Response> {
        guard let user = try req.authenticated(User.self) else {
            return req.future(req.redirect(to: "/login"))
        }

        return try req.content.decode(VoteTopic.self).flatMap { voteTopic in
            return try TopicUser
                .query(on: req)
                .filter(\.topicID == voteTopic.topicId)
                .filter(\.userID == user.requireID()).first().flatMap { vote in
                    if let _ = vote {
                        return req.future(req.redirect(to: "/topics"))
                    }

                    return Topic.find(voteTopic.topicId, on: req).flatMap { topic in
                        guard let topic = topic else {
                            throw Abort(.internalServerError)
                        }

                        return topic.userVotes.attach(user, on: req).map { _ in req.redirect(to: "/topics") }
                    }
            }
        }
    }
}

struct TopicWithVotes: Encodable {
    var topic: Topic
    var votes: Int
    var currentUserVoted: Bool
}

struct VoteTopic: Decodable {
    var topicId: Int
}
