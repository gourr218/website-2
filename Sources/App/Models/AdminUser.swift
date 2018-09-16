import FluentPostgreSQL
import Authentication

final class AdminUser: PostgreSQLModel {
    var id: Int?
    var email: String
    var password: String

    init(id: Int? = nil, email: String, password: String) {
        self.id = id
        self.email = email
        self.password = password
    }
}

extension AdminUser: Migration {}
extension AdminUser: Content {}
extension AdminUser: SessionAuthenticatable {}

extension AdminUser: PasswordAuthenticatable {
    static var usernameKey: WritableKeyPath<AdminUser, String> {
        return \AdminUser.email
    }
    static var passwordKey: WritableKeyPath<AdminUser, String> {
        return \AdminUser.password
    }
}

