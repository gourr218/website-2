import Vapor
import Authentication

public func routes(_ router: Router) throws {

    /// --- User ------------------------------------------------------------------------ ///

    /// Public routes with session.
    ///
    /// They need the info about whether a user
    /// is logged in or not in order to display f.e.
    /// different navigation items like login/logout.
    let routerWithAuthSession = router.grouped(User.authSessionsMiddleware())

    /* App */
    let appController = AppController()
    routerWithAuthSession.get("/", use: appController.renderIndex)
    routerWithAuthSession.get("/about", use: appController.renderAbout)
    routerWithAuthSession.get("/imprint", use: appController.renderImprint)
    routerWithAuthSession.get("/version", use: appController.renderVersion)

    /* Topic */
    let topicController = TopicController()
    routerWithAuthSession.get("/topics", use: topicController.renderList)
    routerWithAuthSession.post("/topics/vote", use: topicController.vote)

    /* User */
    let userController = UserController()
    routerWithAuthSession.post("/register", use: userController.register)
    routerWithAuthSession.get("/login", use: userController.renderLogin)
    routerWithAuthSession.get("/register", use: userController.renderRegister)
    routerWithAuthSession.post("/login", use: userController.login)
    routerWithAuthSession.post("/logout", use: userController.logout)

    /// Protected routes.
    ///
    /// These routes are only accessible if
    /// a user is logged in and will redirect
    /// to the login view if not.
    let protectedRouter = routerWithAuthSession.grouped(RedirectMiddleware<User>(path: "/login"))
    protectedRouter.post("/topics", use: topicController.create)

    /// --- Admin User ------------------------------------------------------------------ ///
    
    /* Admin User */
    let routerWithAdminAuthSession = router.grouped(AdminUser.authSessionsMiddleware())

    let adminUserController = AdminUserController()
    routerWithAdminAuthSession.get("/admin/register", use: adminUserController.renderRegister)
    routerWithAdminAuthSession.post("/admin/register", use: adminUserController.register)
    routerWithAdminAuthSession.get("/admin/login", use: adminUserController.renderLogin)
    routerWithAdminAuthSession.post("/admin/login", use: adminUserController.login)

    let protectedAdminRouter = routerWithAdminAuthSession.grouped(RedirectMiddleware<AdminUser>(path: "/admin/login"))
    protectedAdminRouter.get("/admin", use: adminUserController.renderIndex)
}
