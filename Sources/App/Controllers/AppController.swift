import Vapor
import Leaf

final class AppController {

    func renderIndex(req: Request) throws -> Future<View> {
        return try req.view().render("App/index")
    }

    func renderAbout(req: Request) throws -> Future<View> {
        return try req.view().render("App/about")
    }

    func renderImprint(req: Request) throws -> Future<View> {
        return try req.view().render("App/imprint")
    }

    func renderVersion(req: Request) throws -> Future<View> {
        return try req.view().render("App/version")
    }
}
