import Kitura
import Fluent
import FluentSQLite
import HeliumLogger
import LoggerAPI

// Initialize HeliumLogger
HeliumLogger.use()

// Creating the connection to the SQLite3 database
let driver = try SQLiteDriver(path: "my.db")
let db = Database(driver)
Database.default = db
<% _.each(entities, function (entity) { %>
do {
  try <%= _.capitalize(entity.name) %>.prepare(db)
} catch {
  Log.warning("Warning: \(error)")
}<% }); %>

// Set up routes
let router = Router()
router.all("/*", middleware: BodyParser())
<% _.each(entities, function (entity) { %>
<%= _.capitalize(entity.name) %>Controller().setupRoutes(router)<% }); %>
router.all("/", middleware: StaticFileServer())

// Add an HTTP server and connect it to the router
Kitura.addHTTPServer(onPort: 8090, with: router)

// Start the Kitura runloop (this call never returns)
Kitura.run()

