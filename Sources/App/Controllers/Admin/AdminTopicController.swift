import Vapor
import Leaf
import Crypto
import FluentPostgreSQL

final class AdminTopicController {

    func renderTopic(req: Request) throws -> Future<View> {
        return Topic.query(on: req).filter(\.isArchived == false).all().flatMap { topics in
            let viewData = ViewData.AdminTopicList(
                topics: topics,
                adminAppInfo: try ViewData.adminAppInfo(on: req)
            )
            return try req.view().render("Admin/topic", viewData)
        }
    }

    func archive(req: Request) throws -> Future<Response> {
        return try req.content.decode(ArchiveTopic.self).flatMap { archiveTopic in
            return Topic.find(archiveTopic.topicId, on: req).flatMap { topic in
                let redirect = req.redirect(to: "/admin/topics")
                guard let topic = topic else {
                    return req.future(redirect)
                }

                topic.isArchived = true
                return topic.save(on: req).transform(to: redirect)
            }
        }
    }

    func delete(req: Request) throws -> Future<Response> {
        return try req.content.decode(DeleteTopic.self).flatMap { deleteTopic in
            return Topic.find(deleteTopic.topicId, on: req).flatMap { topic in
                let redirect = req.redirect(to: "/admin/topics")
                guard let topic = topic else {
                    return req.future(redirect)
                }


                return try TopicUser.query(on: req).filter(\.topicID == topic.requireID()).delete().flatMap { _ in
                    return topic.delete(on: req).transform(to: redirect)
                }

//                Fluent Bug `missing FROM-clause entry for table "Topic_User"`
//
//                return try topic.userVotes.query(on: req).delete().flatMap {
//                    return topic.delete(on: req).transform(to: redirect)
//                }
            }
        }
    }
}

struct ArchiveTopic: Decodable {
    var topicId: Int
}

struct DeleteTopic: Decodable {
    var topicId: Int
}
