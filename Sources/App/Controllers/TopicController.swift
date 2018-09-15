import Vapor
import Leaf

final class TopicController {

    func renderList(req: Request) throws -> Future<View> {
        return try req
            .view()
            .render(
                "Topic/list.leaf",
                ["isUser": req.isAuthenticated(User.self)]
            )
    }
}
