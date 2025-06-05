//
//  ChatUser.swift
//  StudChat
//
//  Created by Karlo Šibalić on 01.05.2025..
//

import Foundation

struct ChatUser: Codable, Identifiable, Equatable {
    var id: UUID?
    let createdAt: Date
    var username: String
    var displayName: String
    let email: String
    var imageURL: String
    let dob: Date
    var servers: [Int]
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case createdAt = "created_at"
        case username = "username"
        case displayName = "display_name"
        case email = "email"
        case imageURL = "image_url"
        case dob = "dob"
        case servers = "servers"
    }
}
