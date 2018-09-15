import FluentPostgreSQL

struct TopicUser: PostgreSQLPivot {
    typealias Left = Topic
    typealias Right = User

    static var leftIDKey: LeftIDKey = \.topicID
    static var rightIDKey: RightIDKey = \.userID

    var id: Int?
    var userID: Int
    var topicID: Int

    init(id: Int? = nil, userID: Int, topicID: Int) {
        self.id = id
        self.userID = userID
        self.topicID = topicID
    }
}

extension TopicUser: Migration {}

extension TopicUser: ModifiablePivot {
    init(_ topic: Topic, _ user: User) throws {
        topicID = try topic.requireID()
        userID = try user.requireID()
    }
}
