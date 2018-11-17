import Vapor
import FluentPostgreSQL

final class Product: Codable {
    var id: Int?
    var asin: String
    var title: String
    var url: String
    var priceHistory: [Event]
    
    init(asin: String, title: String, url: String, priceHistory: [Event]) {
        self.asin = asin
        self.title = title
        self.url = url
        self.priceHistory = priceHistory
    }
}

extension Product: PostgreSQLModel {}
extension Product: Migration {}
extension Product: Content {}

final class Event: Codable {
    var price: String
    var date: Int
    
    init(price: String, date: Int) {
        self.price = price
        self.date = date
    }
}


