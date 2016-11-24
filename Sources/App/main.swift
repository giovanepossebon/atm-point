import Vapor
import CoreLocation
import VaporPostgreSQL

let drop = Droplet(
    providers: [VaporPostgreSQL.Provider.self]
)

drop.preparations = [ATM.self]

drop.get("list/atm") { request in
    let atms = try ATM.all()
    
    return try JSON(node: atms.makeNode())
}

drop.post("atm") { request in
    
    var atm = try ATM(node: request.json)
    
    do {
        try atm.save()
    } catch {
        throw Abort.custom(status: .badRequest, message: request.description)
    }
    
    return atm
} 

drop.get("version") { request in
    if let db = drop.database?.driver as? PostgreSQLDriver {
        let version = try db.raw("SELECT version()")
        return try JSON(node: version)
    } else {
        return "No db connection"
    }
}

drop.run()
