import Vapor
import Fluent
import Foundation

final class Post: Model {
    var id: Node?
    var exists: Bool = false
    
    var title: String
    var date: Int
    var author: String
    var content: String
    
    init(title: String, content: String) {
        self.id = UUID().uuidString.makeNode()
        self.title = title
        self.date = Int(Date().timeIntervalSince1970)
        self.author = author
        self.content = content
    }

    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        title = try node.extract("title")
        date = try node.extract("date")
        author = try node.extract("author")
        content = try node.extract("content")
    }

    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "title": title,
            "date": date,
            "author": author,
            "content": content
        ])
    }
}

extension Post: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create("posts") { posts in
            posts.id()
            posts.string("title")
            posts.int("date")
            posts.string("author")
            posts.string("content")
        }
    }

    static func revert(_ database: Database) throws {
        //
    }
}
