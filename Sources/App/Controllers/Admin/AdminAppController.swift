import Vapor

final class AdminAppController {

    func renderIndex(req: Request) throws -> Future<Response> {
        if try req.isAuthenticated(AdminUser.self) {
            return req.future(req.redirect(to: "/admin/topics"))
        }
        return req.future(req.redirect(to: "/admin/login"))
    }
}
