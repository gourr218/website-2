import Vapor
import Leaf
import Crypto
import FluentPostgreSQL
import Fluent

final class AdminUserController {

    /// MARK: Views

    func renderRegister(req: Request) throws -> Future<View> {
        return try req.view().render("Admin/register")
    }

    func renderLogin(req: Request) throws -> Future<View> {
        return try req.view().render("Admin/login")
    }

    func renderList(req: Request) throws -> Future<View> {
        return User.query(on: req).all().flatMap { userList in
            let viewData = ViewData.AdminUserList(
                users: userList,
                adminAppInfo: try ViewData.adminAppInfo(on: req)
            )
            return try req.view().render("Admin/User/list", viewData)
        }
    }

    /// MARK: Non-Views

    func register(req: Request) throws -> Future<Response> {
        return AdminUser.query(on: req).first().flatMap { adminUser in
            if adminUser != nil {
                return req.future(req.redirect(to: "/admin/register"))
            }

            return try req.content.decode(AdminUser.self).flatMap { newAdminUser in
                newAdminUser.password = try BCryptDigest().hash(newAdminUser.password)
                return newAdminUser.save(on: req).transform(to: req.redirect(to: "/admin/login"))
            }
        }
    }

    func login(req: Request) throws -> Future<Response> {
        return try req.content.decode(AdminUser.self).flatMap { adminUser in
            return AdminUser.authenticate(
                username: adminUser.email,
                password: adminUser.password,
                using: BCryptDigest(),
                on: req
                ).map { user in
                    guard let user = user else {
                        return req.redirect(to: "/admin/login")
                    }

                    try req.authenticateSession(user)
                    return req.redirect(to: "/admin/topics")
            }
        }
    }

    func logout(req: Request) throws -> Future<Response> {
        try req.unauthenticate(AdminUser.self)
        return req.future(req.redirect(to: "/admin/login"))
    }

    /// Delete User and all his votes and topics created by him
    func delete(req: Request) throws -> Future<Response> {
        return try req.content.decode(DeleteUser.self).flatMap { deleteUser in
            return User.find(deleteUser.userId, on: req).flatMap { user in
                let redirect = req.redirect(to: "/admin/users")
                guard let user = user else {
                    return req.future(redirect)
                }

                return try Topic.query(on: req).filter(\.userID == user.requireID()).all().flatMap { topicList in
                    return try TopicUser.query(on: req).group(.or) {
                        let topicListIds = try topicList.map {try $0.requireID()}
                        try $0
                            .filter(\.userID == user.requireID())
                            .filter(\.topicID ~~ topicListIds)
                    }.delete().flatMap {
                        return user.delete(on: req).transform(to: redirect)
                    }
                }
            }
        }
    }
}

struct DeleteUser: Decodable {
    var userId: Int
}
