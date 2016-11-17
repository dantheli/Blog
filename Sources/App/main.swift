import Vapor
import VaporPostgreSQL

import SwiftyBeaver
import SwiftyBeaverVapor

let app = Droplet()

app.preparations = [Post.self]
try app.addProvider(VaporPostgreSQL.Provider.self)

let console = ConsoleDestination()
let file = FileDestination()
let swiftyBeaverProvider = SwiftyBeaverProvider(destinations: [console, file])
app.addProvider(swiftyBeaverProvider)

let log = app.log.self

app.get { req in
    return try app.view.make("welcome", [
    	"message": app.localization[req.lang, "welcome", "title"]
    ])
}

app.get("version") { request in
    if let database = app.database?.driver as? PostgreSQLDriver {
        let version = try database.raw("SELECT version()")
        return try JSON(node: version)
    } else {
        return "No db connection"
    }
}

app.resource("posts", PostController())

app.run()
