import Vapor
import FluentPostgreSQL

public final class Product: Codable {
    public var id: Int?
    public var asin: String
    public var title: String
    public var url: String
    public var priceHistory: [Event]
    
    public init(asin: String, title: String, url: String, priceHistory: [Event]) {
        self.asin = asin
        self.title = title
        self.url = url
        self.priceHistory = priceHistory
    }
}

extension Product: PostgreSQLModel {}
extension Product: Migration {}
extension Product: Content {}
extension Product: Parameter {}

public final class Event: Codable {
    public var price: String
    public var date: Int
    
    public init(price: String, date: Int) {
        self.price = price
        self.date = date
    }
}


