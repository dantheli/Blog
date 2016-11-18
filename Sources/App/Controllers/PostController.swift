import Vapor
import HTTP

final class PostController: ResourceRepresentable {
    func index(request: Request) throws -> ResponseRepresentable {
        return try Post.all().makeNode().converted(to: JSON.self)
    }

    func create(request: Request) throws -> ResponseRepresentable {
        var post = try request.post()
        try post.save()
        return post
    }

    func show(request: Request, post: Post) throws -> ResponseRepresentable {
        return post
    }

    func makeResource() -> Resource<Post> {
        return Resource(
            index: index,
            store: create
        )
    }
}

extension Request {
    func post() throws -> Post {
        guard let json = json else { throw Abort.badRequest }
        return try Post(node: json)
    }
}
