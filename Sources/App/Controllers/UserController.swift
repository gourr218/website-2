import Vapor
import Leaf

final class UserController {

    func renderRegister(req: Request) throws -> Future<View> {
        return try req.view().render("User/register")
    }

    func register(req: Request) throws -> Future<View> {
        return try req.view().render("User/register")
    }

    func renderLogin(req: Request) throws -> Future<View> {
        return try req.view().render("User/login")
    }

    func login(req: Request) throws -> Future<View> {
        return try req.view().render("User/login")
    }
}
