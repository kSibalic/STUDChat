//
//  LocalDatabaseService.swift
//  StudChat
//
//  Created by Karlo Šibalić on 01.05.2025..
//

import Foundation

final class LocalDatabaseService {
    
    static let shared = LocalDatabaseService()
    
    private init() {
        
    }
    
    func storeUserInfoOnDevice(user: ChatUser) {
        UserDefaults.standard.setValue(user.id, forKey: "id")
        UserDefaults.standard.setValue(user.createdAt, forKey: "createdAt")
        UserDefaults.standard.setValue(user.username, forKey: "username")
        UserDefaults.standard.setValue(user.displayName, forKey: "displayName")
        UserDefaults.standard.setValue(user.email, forKey: "email")
        UserDefaults.standard.setValue(user.imageURL, forKey: "imageURL")
        UserDefaults.standard.setValue(user.dob, forKey: "dob")
        UserDefaults.standard.setValue(user.servers, forKey: "servers")
    }
    
    func fetchUserFromStoredInfo() -> ChatUser? {
        if let idString = UserDefaults.standard.string(forKey: "id"),
           let id = UUID(uuidString: idString),
           let createdAt = UserDefaults.standard.object(forKey: "createdAt") as? Date,
           let username = UserDefaults.standard.string(forKey: "username"),
           let displayName = UserDefaults.standard.string(forKey: "displayName"),
           let email = UserDefaults.standard.string(forKey: "email"),
           let imageURL = UserDefaults.standard.string(forKey: "imageURL"),
           let dob = UserDefaults.standard.object(forKey: "dob") as? Date,
           let servers = UserDefaults.standard.array(forKey: "servers") as? [Int] {
            
            let user = ChatUser(id: id, createdAt: createdAt, username: username, displayName: displayName, email: email, imageURL: imageURL, dob: dob, servers: servers)
            
            return user
        } else {
            return nil
        }
    }
    
    func resetDeviceStorage() {
        UserDefaults.standard.setValue(nil, forKey: "id")
        UserDefaults.standard.setValue(nil, forKey: "createdAt")
        UserDefaults.standard.setValue(nil, forKey: "username")
        UserDefaults.standard.setValue(nil, forKey: "displayName")
        UserDefaults.standard.setValue(nil, forKey: "email")
        UserDefaults.standard.setValue(nil, forKey: "imageURL")
        UserDefaults.standard.setValue(nil, forKey: "dob")
        UserDefaults.standard.setValue(nil, forKey: "servers")
    }
}
