import Vapor

enum ViewData {
    struct AppInfo: Encodable {
        var versions: [Version]
        var isUser: Bool
    }

    struct TopicList: Encodable {
        var appInfo: AppInfo
        var topicsWithVotes: Future<[TopicWithVotes]>
    }

    /// General Information needed in every View
    /// Every view accesses it at the key "appInfo"
    ///
    /// - returns dictionary with AppInfo at key 'appInfo'
    static func appInfoWithKey(on req: Request) throws -> [String: AppInfo] {
        return ["appInfo": try appInfo(on: req)]
    }

    /// General Information needed in every View
    /// Every view accesses it at the key "appInfo"
    ///
    /// - returns instance of AppInfo
    static func appInfo(on req: Request) throws -> AppInfo {
        return AppInfo(
            versions: Version.versions,
            isUser: try req.isAuthenticated(User.self)
        )
    }
}
