import Vapor
import Leaf
import FluentPostgreSQL
import Authentication

public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    var middlewares = MiddlewareConfig()
    middlewares.use(FileMiddleware.self)
    middlewares.use(ErrorMiddleware.self)
    services.register(middlewares)

    let leafProvider = LeafProvider()
    try services.register(leafProvider)
    config.prefer(LeafRenderer.self, for: ViewRenderer.self)

    try services.register(FluentPostgreSQLProvider())
    let postgresqlConfig = PostgreSQLDatabaseConfig(
        hostname: "127.0.0.1",
        port: 5432,
        username: "martinlasek",
        database: "vaporberlin",
        password: nil

    )
    services.register(postgresqlConfig)

    try services.register(AuthenticationProvider())

    var migrations = MigrationConfig()
    migrations.add(model: User.self, database: .psql)
    services.register(migrations)

    config.prefer(MemoryKeyedCache.self, for: KeyedCache.self)
}
