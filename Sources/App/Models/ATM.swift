import Vapor
import CoreLocation
import VaporPostgreSQL

final class ATM: Model {
    
    var id: Node?
    var title: String?
    var address: String
    var latitude: Double
    var longitude: Double
    var rating: Int?
    var cash: Bool?
    var exists: Bool = false
    
    init(address: String, latitude: Double, longitude: Double) {
        self.id = nil
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
    }
    
    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        title = try node.extract("title")
        address = try node.extract("address")
        latitude = try node.extract("latitude")
        longitude = try node.extract("longitude")
        rating = try node.extract("rating")
        cash = try node.extract("cash")
    }
    
    func makeJSON() throws -> JSON {
        return try JSON(node: [
            "id": id,
            "title": title,
            "address": address,
            "latitude": latitude,
            "longitude": longitude,
            "rating": rating,
            "cash": cash
        ])
    }
    
    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "title": title,
            "address": address,
            "latitude": latitude,
            "longitude": longitude,
            "rating": rating,
            "cash": cash
        ])
    }
    
    static func revert(_ database: Database) throws {
        try database.delete("atms")
    }
    
    static func prepare(_ database: Database) throws {
        try database.create("atms", closure: { atm in
            atm.id()
            atm.string("title")
            atm.string("address")
            atm.double("latitude")
            atm.double("longitude")
            atm.int("rating")
            atm.bool("cash")
        })
    }
    
}
