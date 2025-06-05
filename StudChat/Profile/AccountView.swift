//
//  AccountView.swift
//  StudChat
//
//  Created by Karlo Šibalić on 01.05.2025..
//

import SwiftUI

struct AccountView: View {
    let user: ChatUser
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    // Profile Header
                    VStack(spacing: 16) {
                        // Profile Image
                        Group {
                            if !user.imageURL.isEmpty {
                                AsyncImage(url: URL(string: user.imageURL)) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                } placeholder: {
                                    Circle()
                                        .fill(Color.studChat)
                                        .overlay {
                                            Text(user.username.prefix(1))
                                                .font(.largeTitle)
                                                .foregroundStyle(.white)
                                        }
                                }
                                .frame(width: 80, height: 80)
                                .clipShape(Circle())
                            } else {
                                Circle()
                                    .fill(Color.studChat)
                                    .frame(width: 80, height: 80)
                                    .overlay {
                                        Text(user.username.prefix(1))
                                            .font(.largeTitle)
                                            .foregroundStyle(.white)
                                    }
                            }
                        }
                        
                        VStack(spacing: 4) {
                            Text(user.displayName)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundStyle(.studChat)
                            
                            Text("@\(user.username)")
                                .font(.callout)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical, 24)
                    
                    // Account Information
                    VStack(spacing: 0) {
                        AccountInfoRow(
                            icon: "person.fill",
                            title: "Full Name",
                            value: user.displayName
                        )
                        
                        Divider()
                        
                        AccountInfoRow(
                            icon: "at",
                            title: "Username",
                            value: "@\(user.username)"
                        )
                        
                        Divider()
                        
                        AccountInfoRow(
                            icon: "envelope.fill",
                            title: "Email",
                            value: user.email
                        )
                        
                        Divider()
                        
                        AccountInfoRow(
                            icon: "calendar",
                            title: "Date of Birth",
                            value: user.dob.formatted(date: .abbreviated, time: .omitted)
                        )
                        
                        Divider()
                        
                        AccountInfoRow(
                            icon: "clock.fill",
                            title: "Member Since",
                            value: user.createdAt.formatted(date: .abbreviated, time: .omitted)
                        )
                        
                        Divider()
                        
                        AccountInfoRow(
                            icon: "server.rack",
                            title: "Servers Joined",
                            value: "\(user.servers.count)"
                        )
                    }
                    .background(Color(uiColor: .systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal, 16)
                    
                    Spacer(minLength: 32)
                }
            }
            .background(Color(.background))
            .navigationTitle("Account")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct AccountInfoRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(.studChat)
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .textCase(.uppercase)
                
                Text(value)
                    .font(.body)
                    .foregroundStyle(.primary)
            }
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

#Preview {
    AccountView(user: ChatUser(
        id: UUID(),
        createdAt: Date(timeIntervalSinceNow: -86400 * 30), // 30 days ago
        username: "testuser",
        displayName: "Test User",
        email: "test@example.com",
        imageURL: "",
        dob: Date(timeIntervalSinceNow: -86400 * 365 * 25), // 25 years ago
        servers: [1, 2, 3]
    ))
}
