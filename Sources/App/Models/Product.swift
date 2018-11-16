import Vapor
import FluentPostgreSQL

final class Product: Codable {
    var id: Int?
    var title: String
    var priceHistory: [Event]
    
    init(id: Int, title: String, priceHistory: [Event]) {
        self.id = id
        self.title = title
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


