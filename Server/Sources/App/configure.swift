import Vapor
import FluentPostgreSQL

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    /// Register providers first
    try services.register(FluentPostgreSQLProvider())

    /// Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    /// Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    /// middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)

    // Configure a database
    var databases = DatabasesConfig()

    // Create database first
    // if from brew, brew services start postgres
    // create database: create database vapor
    // create user (optional): create user someone
    // list databases: \l
    // See if database is running: lsof -i :5432
    let databaseConfig = PostgreSQLDatabaseConfig(hostname: "localhost",
                                                  username: "kirby",
                                                  database: "vapor",
                                                  password: nil)
    let database = PostgreSQLDatabase(config: databaseConfig)
    databases.add(database: database, as: .psql)
    services.register(databases)
    
    var migrations = MigrationConfig()

    migrations.add(model: Product.self, database: .psql)
    services.register(migrations)
}
