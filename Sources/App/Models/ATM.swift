import Vapor
import VaporPostgreSQL

final class ATM: Model {
    
    var id: Node?
    var address: String
    var exists: Bool = false
    
    init(address: String) {
        self.address = address
    }
    
    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        address = try node.extract("address")
    }
    
    func makeJSON() throws -> JSON {
        return try JSON(node: [
            "id": id,
            "address": address])
    }
    
    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "address": address])
    }
    
    static func revert(_ database: Database) throws {
        try database.delete("atms")
    }
    
    static func prepare(_ database: Database) throws {
        try database.create("atms", closure: { atm in
            atm.id()
            atm.string("address")
        })
    }
    
}
