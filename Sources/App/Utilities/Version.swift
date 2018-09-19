struct Version: Encodable {
    var major: Int
    var minor: Int
    var patch: Int

    var changes: [String]

    static var versions = [
        Version(
            major: 2,
            minor: 0,
            patch: 0,
            changes: [
                "complete rewrite (now using Vapor 3)"
            ]
        ),
        Version(
            major: 1,
            minor: 1,
            patch: 1,
            changes: [
                "fix a bug where you could register and login with just one character and no password"
            ]
        ),
        Version(
            major: 1,
            minor: 1,
            patch: 0,
            changes: [
            "enter on registration or login now triggers submit",
            "a hint on topics explains how to vote or create one",
            "a label under votes appears if you voted for a topic",
            "fix a bug where registration was case sensitive"
            ]
        ),
        Version(
            major: 1,
            minor: 0,
            patch: 2,
            changes: [
            "logout now triggers deletion of auth token",
            "design refinements (cards, font, mobile view)",
            "fixed that submenu would not open on mobile"
            ]
        ),
        Version(
            major: 1,
            minor: 0,
            patch: 1,
            changes: [
                "added versions page",
                "fixed that empty topics could be created"
            ]
        )
    ]
}
