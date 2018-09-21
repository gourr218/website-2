import Vapor
import Leaf
import FluentPostgreSQL
import Authentication
import Flash

public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    try services.register(FlashProvider())

    var middlewares = MiddlewareConfig()
    middlewares.use(FileMiddleware.self)
    middlewares.use(ErrorMiddleware.self)
    middlewares.use(SessionsMiddleware.self)
    middlewares.use(FlashMiddleware.self)
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
        password: Environment.get("DATABASE_PW") ?? nil

    )
    services.register(postgresqlConfig)

    try services.register(AuthenticationProvider())
    services.register { _ -> LeafTagConfig in
        var tags = LeafTagConfig.default()
        tags.use(FlashTag(), as: "flash")
        return tags
    }

    var migrations = MigrationConfig()
    migrations.add(model: User.self, database: .psql)
    migrations.add(model: Topic.self, database: .psql)
    migrations.add(model: TopicUser.self, database: .psql)
    migrations.add(model: AdminUser.self, database: .psql)
    services.register(migrations)

    config.prefer(MemoryKeyedCache.self, for: KeyedCache.self)
}
