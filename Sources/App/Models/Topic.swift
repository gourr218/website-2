import FluentPostgreSQL

final class Topic: PostgreSQLModel {
    var id: Int?
    var description: String
    var userID: User.ID

    init(id: Int? = nil, description: String, userID: User.ID) {
        self.id = id
        self.description = description
        self.userID = userID
    }
}

extension Topic: Migration {}

extension Topic {
    var user: Parent<Topic, User> {
        return parent(\.userID)
    }
}

extension Topic {
    var userVotes: Siblings<Topic, User, TopicUser> {
        return siblings()
    }
}

struct TopicForm: Codable {
    var description: String
}
