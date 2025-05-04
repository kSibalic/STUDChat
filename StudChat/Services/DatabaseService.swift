//
//  DatabaseService.swift
//  StudChat
//
//  Created by Karlo Šibalić on 01.05.2025..
//

import Foundation
import Supabase

enum Table {
    static let channels = "channels"
    static let messages = "messages"
    static let servers = "servers"
    static let users = "users"
}

enum UserFetchError: Error, LocalizedError {
    case userNotFound(email: String)
    case databaseError(Error)
    
    var errorDescription: String? {
        switch self {
        case .userNotFound(let email):
            return "No user found with email: \(email)"
        
        case .databaseError(let error):
            return "Database error: \(error.localizedDescription)"
        }
    }
}

@Observable
final class DatabaseService {
    
    var servers = [Server]()
    var userServers = [Server]()
    var users = [ChatUser]()
    var messages: [UUID: [Message]] = [:]
    
    static let shared = DatabaseService()
    
    var publicSchema: RealtimeChannelV2?
    private let supabase = SupabaseClient(supabaseURL: URL(string: Secrets.supabaseURL)!, supabaseKey: Secrets.supabaseKey)
    
    private init() {
        Task {
            do {
                try await fetchAllServers()
                try await fetchAllUsers()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    // Users
    @discardableResult
    func createUserInDatabase(_ user: ChatUser) async throws -> ChatUser {
        let user: ChatUser = try await supabase
            .database
            .from(Table.users)
            .insert(user, returning: .representation)
            .single()
            .execute()
            .value
        
        return user
    }
    
    func fetchUserFromDatabase(email: String) async throws -> ChatUser {
        do {
            let user: ChatUser = try await supabase
                .database
                .from(Table.users)
                .select()
                .equals("email", value: email)
                .single()
                .execute()
                .value
            
            return user
        } catch {
            throw UserFetchError.databaseError(error)
        }
    }
    
    func fetchAllUsers() async throws {
        users = try await supabase
            .database
            .from(Table.users)
            .select()
            .execute()
            .value
    }
}

// Servers
extension DatabaseService {
    
    func createServer(user: ChatUser, serverName: String) async throws {
        
        guard let userUid = user.id else {
            return
        }
        
        let channelUid = UUID()
        let server = Server(createdAt: .now, name: serverName, imageURL: "", admin: userUid, members: [userUid], channels: [channelUid])
        
        var addedServer: Server = try await supabase
            .database
            .from(Table.servers)
            .insert(server, returning: .representation)
            .select()
            .single()
            .execute()
            .value
        
        guard let serverId = addedServer.id else {
            return
        }
        
        let channel = Channel(createdAt: .now, name: "general", channelUid: channelUid, admin: userUid, serverId: serverId, messages: [])
        
        try await supabase
            .database
            .from(Table.channels)
            .insert(channel)
            .select()
            .single()
            .execute()
        
        addedServer.channelModels.append(channel)
        userServers.append(addedServer)
    }
    
    func createChannelForServer(admin user: ChatUser, server: Server, channel: Channel) async throws {
        
        guard let serverId = server.id else {
            return
        }
        
        var updatedServer = server
        updatedServer.channels.append(channel.channelUid)
        
        let newChannel: Channel = try await supabase
            .database
            .from(Table.channels)
            .insert(channel, returning: .representation)
            .single()
            .execute()
            .value
        
        try await supabase
            .database
            .from(Table.servers)
            .update(updatedServer)
            .eq("id", value: serverId)
            .execute()
    }
    
    func fetchAllServers() async throws {
        
        let channels: [Channel] = try await supabase
            .database
            .from(Table.channels)
            .select()
            .execute()
            .value
        
        var servers: [Server] = try await supabase
            .database
            .from(Table.servers)
            .select()
            .execute()
            .value
        
        servers = servers.map { server in
            var newServer = server
            let serverChannels = channels.filter { channel in
                server.channels.contains(where: {
                    $0 == channel.channelUid
                })
            }
            newServer.channelModels = serverChannels
            
            return newServer
        }
        
        self.servers = servers
        
        guard let user = AuthService.shared.currentUser else {
            return
        }
        
        fetchUserServers(for: user)
        fetchMessages { success in
            print(success)
        }
        listenForNewMessages()
    }
    
    func fetchUserServers(for user: ChatUser) {
        self.userServers = servers.filter({ server in
            return server.members.contains(where: {
                $0 == user.id
            })
        })
    }
    
    func joinServer(server: Server, user: ChatUser) async throws {
        guard let userUid = user.id, let serverId = server.id else {
            return
        }
        
        var updatedServer = server
        updatedServer.members.append(userUid)
        
        try await supabase.database
            .from(Table.servers)
            .update(updatedServer)
            .eq("id", value: serverId)
            .execute()
        
        var updatedUser = user
        updatedUser.servers.append(serverId)
        try await supabase.database
            .from(Table.users)
            .update(updatedUser)
            .eq("id", value: userUid)
            .execute()
        
        userServers.append(updatedServer)
    }
}


// Messages
extension DatabaseService {
    func sendMessage(message: Message) async throws {
        try await supabase
            .database
            .from(Table.messages)
            .insert(message)
            .execute()
    }
    
    func fetchMessages(completion: @escaping (Bool) -> Void) {
        userServers.forEach { server in
            server.channelModels.forEach { channel in
                Task {
                    do {
                        let messages: [Message] = try await supabase
                            .database
                            .from(Table.messages)
                            .select()
                            .in("channel_uid", values: [channel.channelUid])
                            .order("created_at", ascending: true)
                            .execute()
                            .value
                        
                        self.messages[channel.channelUid] = messages
                    } catch {
                        print(error.localizedDescription)
                        completion(false)
                    }
                }
            }
        }
        completion(true)
    }
    
    func listenForNewMessages() {
        Task {
            publicSchema = supabase.realtimeV2.channel("public:\(Table.messages)")
            
            // Observe socket connection status
            Task {
                for await status in supabase.realtimeV2.statusChange {
                    print("RealtimeV2 socket status: \(status)")
                }
            }
            
            // Observe channel subscription status
            if let channel = publicSchema {
                Task {
                    for await status in channel.statusChange {
                        print("Channel subscription status: \(status)")
                    }
                }
                
                // Listen for message insertions
                Task {
                    for await insertion in channel.postgresChange(InsertAction.self, table: Table.messages) {
                        do {
                            let decoder = JSONDecoder()
                            decoder.dateDecodingStrategy = .iso8601
                            
                            let insertedMessage = try insertion.decodeRecord(as: Message.self, decoder: decoder)
                            print("New message received: \(insertedMessage)")
                            
                            // Update local messages collection
                            if var existingMessages = self.messages[insertedMessage.channelUid] {
                                existingMessages.append(insertedMessage)
                                self.messages[insertedMessage.channelUid] = existingMessages
                            } else {
                                self.messages[insertedMessage.channelUid] = [insertedMessage]
                            }
                        } catch {
                            print("Error decoding inserted message: \(error.localizedDescription)")
                        }
                    }
                }
                
                // Subscribe to the channel
                await channel.subscribe()
            }
        }
    }
}

struct Message: Codable, Identifiable, Equatable {
    var id: UUID
    let createdAt: Date
    let username: String
    let imgURL: String
    let text: String
    let channelUid: UUID
    let serverId: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case createdAt = "created_at"
        case username = "username"
        case imgURL = "image_url"
        case text = "text"
        case channelUid = "channel_uid"
        case serverId = "server_id"
    }
}

struct Channel: Codable, Identifiable, Equatable {
    var id: Int?
    let createdAt: Date
    let name: String
    let channelUid: UUID
    let admin: UUID
    let serverId: Int
    var messages: [UUID]
    var messageModels = [Message]()
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case createdAt = "created_at"
        case name = "name"
        case channelUid = "channel_uid"
        case admin = "admin"
        case serverId = "server_id"
        case messages = "messages"
    }
    
    static func == (lhs: Channel, rhs: Channel) -> Bool {
        return lhs.channelUid == rhs.channelUid
    }
    
}
