import Vapor

public func routes(_ router: Router) throws {

    let userController = UserController()
    router.get("/", use: userController.renderIndex)
}
