//
//  AuthService.swift
//  StudChat
//
//  Created by Karlo Šibalić on 01.05.2025..
//

import Foundation
import Supabase

@Observable
final class AuthService {
    
    static let shared = AuthService()
    
    private let auth = SupabaseClient(supabaseURL: URL(string: Secrets.supabaseURL)!, supabaseKey: Secrets.supabaseKey).auth
    
    var currentUser: ChatUser?
    
    private init() {
        Task {
            do {
                let session = try await auth.session
                
                guard let email = session.user.email else {
                    return
                }
                
                try await fetchCurrentUser(id: session.user.id, email: email)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchCurrentUser(id: UUID, email: String) async throws {
        if let user = LocalDatabaseService.shared.fetchUserFromStoredInfo(), id == user.id {
            currentUser = user
        } else {
            currentUser = try await DatabaseService.shared.fetchUserFromDatabase(email: email)
        }
    }
    
    @MainActor
    func registerNewUserWithEmail(user: ChatUser, password: String) async throws {
        let response = try await auth.signUp(email: user.email, password: password)
        var updatedUser = user
        updatedUser.id = response.session?.user.id
        
        try await DatabaseService.shared.createUserInDatabase(updatedUser)
        LocalDatabaseService.shared.storeUserInfoOnDevice(user: updatedUser)
        currentUser = updatedUser
    }
    
    @MainActor
    func signIn(email: String, password: String) async throws {
        let session = try await auth.signIn(email: email, password: password)
        
        try await fetchCurrentUser(id: session.user.id, email: email)
    }
    
    func signOut() async throws {
        try await auth.signOut()
        LocalDatabaseService.shared.resetDeviceStorage()
        currentUser = nil
    }
}
