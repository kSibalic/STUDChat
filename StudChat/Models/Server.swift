//
//  Server.swift
//  StudChat
//
//  Created by Karlo Šibalić on 02.05.2025..
//

import Foundation

struct Server: Codable, Identifiable, Equatable {
    var id: Int?
    let createdAt: Date
    let name: String
    let imageURL: String
    let admin: UUID
    var members: [UUID]
    var channels: [UUID]
    var channelModels = [Channel]()
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case createdAt = "created_at"
        case name = "name"
        case imageURL = "image_url"
        case admin = "admin"
        case members = "members"
        case channels = "channels"
    }
    static func == (lhs: Server, rhs: Server) -> Bool {
        if lhs.id == rhs.id, lhs.name == rhs.name {
            return true
        } else {
            return false
        }
    }
}
