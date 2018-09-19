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

    /// Public routes with session.
    let routerWithAdminAuthSession = router.grouped(AdminUser.authSessionsMiddleware())

    /* Admin User */
    let adminAppController = AdminAppController()
    routerWithAdminAuthSession.get("/admin", use: adminAppController.renderIndex)

    let adminUserController = AdminUserController()
    routerWithAdminAuthSession.get("/admin/register", use: adminUserController.renderRegister)
    routerWithAdminAuthSession.post("/admin/register", use: adminUserController.register)
    routerWithAdminAuthSession.get("/admin/login", use: adminUserController.renderLogin)
    routerWithAdminAuthSession.post("/admin/login", use: adminUserController.login)
    routerWithAdminAuthSession.get("/admin/logout", use: adminUserController.logout)
    routerWithAdminAuthSession.post("/admin/logout", use: adminUserController.logout)

    /// Protected routes.
    let protectedAdminRouter = routerWithAdminAuthSession.grouped(RedirectMiddleware<AdminUser>(path: "/admin/login"))

    let adminTopicController = AdminTopicController()
    protectedAdminRouter.get("/admin/topics", use: adminTopicController.renderTopic)
    protectedAdminRouter.post("/admin/topics/archive", use: adminTopicController.archive)
    protectedAdminRouter.post("/admin/topics/delete", use: adminTopicController.delete)
    protectedAdminRouter.get("/admin/users", use: adminUserController.renderList)
    protectedAdminRouter.post("/admin/users/delete", use: adminUserController.delete)
}
