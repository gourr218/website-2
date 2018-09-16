import Vapor
import Leaf

final class AppController {

    func renderIndex(req: Request) throws -> Future<View> {
        let viewData = try ViewData.appInfoWithKey(on: req)
        return try req.view().render("App/index", viewData)
    }

    func renderAbout(req: Request) throws -> Future<View> {
        let viewData = try ViewData.appInfoWithKey(on: req)
        return try req.view().render("App/about", viewData)
    }

    func renderImprint(req: Request) throws -> Future<View> {
        let viewData = try ViewData.appInfoWithKey(on: req)
        return try req.view().render("App/imprint", viewData)
    }

    func renderVersion(req: Request) throws -> Future<View> {
        let viewData = try ViewData.appInfoWithKey(on: req)
        return try req.view().render("App/version", viewData)
    }
}
