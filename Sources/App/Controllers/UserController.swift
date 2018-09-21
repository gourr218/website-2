import Vapor
import Leaf
import Crypto
import FluentPostgreSQL

final class UserController {

    func renderRegister(req: Request) throws -> Future<View> {
        let viewData = try ViewData.appInfoWithKey(on: req)
        /// view renderer must be created on the privateContainer
        /// in order for `Flash 3.0.0` to work
        let vr = try req.privateContainer.make(LeafRenderer.self)
        return vr.render("User/register", viewData)
    }

    func register(req: Request) throws -> Future<Response> {
        return try req.content.decode(User.self).flatMap { user in
            let errorRedirect = req.redirect(to: "/register")

            if !user.isValid() {
                let resp = FlashMessage.Error.invalidRegisterValues(for: errorRedirect)
                return req.future(resp)
            }

            return User
                .query(on: req)
                .filter(\User.email == user.email)
                .first()
                .flatMap { result in
                if let _ = result {
                    let resp = FlashMessage.Error.emailNotUnique(for: errorRedirect)
                    return req.future(resp)
                }

                user.password = try BCryptDigest().hash(user.password)
                let successRedirect = req.redirect(to: "/login")
                let resp = FlashMessage.Success.successfulRegistration(for: successRedirect)
                return user.save(on: req).transform(to: resp)
            }
        }
    }

    func renderLogin(req: Request) throws -> Future<View> {
        let viewData = try ViewData.appInfoWithKey(on: req)
        let vr = try req.privateContainer.make(LeafRenderer.self)
        return vr.render("User/login", viewData)
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
                    let redirect = req.redirect(to: "/login")
                    let resp = FlashMessage.Error.invalidLoginValues(for: redirect)
                    return resp
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
