import Vapor
import Leaf

final class AppController {

    func renderIndex(req: Request) throws -> Future<View> {
        return try req.view().render("App/index", ["isUser": try req.isAuthenticated(User.self)])
    }

    func renderAbout(req: Request) throws -> Future<View> {
        return try req.view().render("App/about", ["isUser": try req.isAuthenticated(User.self)])
    }

    func renderImprint(req: Request) throws -> Future<View> {
        return try req.view().render("App/imprint", ["isUser": try req.isAuthenticated(User.self)])
    }

    func renderVersion(req: Request) throws -> Future<View> {
        let viewData = VersionViewData(
            versions: Version.versions,
            isUser: try req.isAuthenticated(User.self)
        )
        return try req.view().render("App/version", viewData)
    }
}

struct VersionViewData: Encodable {
    var versions: [Version]
    var isUser: Bool
}
