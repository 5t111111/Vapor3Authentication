import Vapor
import Leaf
import FluentSQLite
import Authentication

/// Called before your application initializes.
///
/// https://docs.vapor.codes/3.0/getting-started/structure/#configureswift
public func configure(
    _ config: inout Config,
    _ env: inout Environment,
    _ services: inout Services
) throws {
    // Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    let myService = EngineServerConfig.default(port: 8000)
    services.register(myService)

    try services.register(LeafProvider())
    try services.register(FluentSQLiteProvider())

    config.prefer(LeafRenderer.self, for: TemplateRenderer.self)

    var databases = DatabasesConfig()
    try databases.add(database: SQLiteDatabase(storage: .memory), as: .sqlite)
    services.register(databases)

    var migrations = MigrationConfig()
    migrations.add(model: User.self, database: .sqlite)
    services.register(migrations)

    try services.register(AuthenticationProvider())
}
