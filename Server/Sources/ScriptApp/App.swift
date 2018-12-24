//
//  App.swift
//  ScriptApp
//
//  Created by Kevin Chen on 12/23/18.
//

import Common
import Fluent
import FluentPostgreSQL

public class App {
    
    public static func run() throws {
        let databaseConfig = PostgreSQLDatabaseConfig(hostname: "localhost",
                                                      username: "kirby",
                                                      database: "vapor",
                                                      password: nil)
        
        let database = PostgreSQLDatabase(config: databaseConfig)
        
        
        let worker = MultiThreadedEventLoopGroup(numberOfThreads: 2)
        
        let conn = try database.newConnection(on: worker)
        
        let test = conn.flatMap { connection in
            return Product.query(on: connection).all()
        }
        
        let blah = try test.wait()
        
        print(blah.first?.asin)
        
        try worker.syncShutdownGracefully()
    }
}
