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

        let request1 = AmazonRequest(baseURL: URL(string: "https://www.amazon.com"), path: "/Rosewill-Computer-Tempered-Liquid-Cooling-Pre-Installed/dp/B01M6TV6PC")
        
        let request2 = AmazonRequest(baseURL: URL(string: "https://www.amazon.com"), path: "/Samsung-Inch-Internal-MZ-76E1T0B-AM/dp/B078DPCY3T")
        
        let request3 = AmazonRequest(baseURL: URL(string: "https://www.amazon.com"), path: "/GIGABYTE-Z370-AORUS-Gaming-Motherboard/dp/B075KFX627")
        
        let controller = ScrapperController(requests: [request1, request2, request3])
        
        let products = controller.retrieveProductsInfo()
        print(products)
        print("dawdw")
    }
}
