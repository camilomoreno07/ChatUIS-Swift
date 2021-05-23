
import SwiftUI

struct MsgModel: Identifiable, Equatable {
    var id: String = UUID().uuidString
    var msg: String
    var user: String
    var timeStamp: Date
    
    enum CodingKeys: String{
        case id
        case msg
        case user
        case timeStamp
    }
}

