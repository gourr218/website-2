import Vapor

public func routes(_ router: Router) throws {

    let userController = UserController()
    router.get("/login", use: userController.renderLogin)
    router.post("/login", use: userController.login)
    router.get("/register", use: userController.renderRegister)
    router.post("/register", use: userController.register)

    let appController = AppController()
    router.get("/", use: appController.renderIndex)
    router.get("/about", use: appController.renderAbout)
    router.get("/imprint", use: appController.renderImprint)
    router.get("/version", use: appController.renderVersion)
}
