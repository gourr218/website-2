import Vapor
import Leaf

final class UserController {

    func renderIndex(_ req: Request) throws -> Future<View> {
        return try req.view().render("index")
    }
}
