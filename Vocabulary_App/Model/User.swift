
import Foundation

struct User: Identifiable, Decodable, Encodable {
    let id: Int
    let username: String
    let password: String   
}
