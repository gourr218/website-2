import Vapor
import Leaf
import Crypto
import FluentPostgreSQL

final class UserController {

    func renderRegister(req: Request) throws -> Future<View> {
        return try req.view().render(
            "User/register",
            ["isUser": try req.isAuthenticated(User.self)]
        )
    }

    func register(req: Request) throws -> Future<Response> {
        return try req.content.decode(User.self).flatMap { user in

            return User
                .query(on: req)
                .filter(\User.email == user.email)
                .first()
                .flatMap { result in
                if let _ = result {
                    return req.future(req.redirect(to: "/register"))
                }

                user.password = try BCryptDigest().hash(user.password)
                return user.save(on: req).transform(to: req.redirect(to: "/login"))
            }
        }
    }

    func renderLogin(req: Request) throws -> Future<View> {
        return try req.view().render("User/login", ["isUser": try req.isAuthenticated(User.self)])
    }

    func login(req: Request) throws -> Future<Response> {
        return try req.content.decode(User.self).flatMap { user in
            return User.authenticate(
                username: user.email,
                password: user.password,
                using: BCryptDigest(),
                on: req
            ).map { user in
                guard let user = user else {
                    return req.redirect(to: "/login")
                }

                try req.authenticateSession(user)
                return req.redirect(to: "/topics")
            }
        }
    }

    func logout(req: Request) throws -> Future<Response> {
        try req.unauthenticate(User.self)
        return req.future(req.redirect(to: "/"))
    }
}
