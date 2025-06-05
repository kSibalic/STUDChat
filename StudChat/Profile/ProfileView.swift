//
//  ProfileView.swift
//  StudChat
//
//  Created by Karlo Šibalić on 30.04.2025..
//

import SwiftUI

struct ProfileView: View {
    @State private var showEditProfile = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    // Header background
                    Color.gray
                        .frame(height: 200)
                    
                    ZStack(alignment: .topLeading) {
                        Color.studChat
                            .frame(height: 140)
                        
                        VStack(alignment: .leading) {
                            // Profile Image
                            Group {
                                if let user = AuthService.shared.currentUser, !user.imageURL.isEmpty {
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
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                                } else if let user = AuthService.shared.currentUser {
                                    // Show user's initial when no profile image
                                    Circle()
                                        .fill(Color.studChat)
                                        .frame(width: 100, height: 100)
                                        .overlay {
                                            Text(user.username.prefix(1))
                                                .font(.largeTitle)
                                                .foregroundStyle(.white)
                                        }
                                } else {
                                    // Fallback to default image
                                    Image("pfp")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 100)
                                        .clipShape(Circle())
                                }
                            }
                            .background {
                                Circle()
                                    .fill(Color(.background))
                                    .padding(-8)
                            }
                            
                            // User Info
                            if let user = AuthService.shared.currentUser {
                                Text(user.displayName)
                                    .font(.title2)
                                    .bold()
                                    .foregroundStyle(.white)
                                
                                Text("@\(user.username)")
                                    .font(.callout)
                                    .foregroundStyle(Color(UIColor.systemGray4))
                            } else {
                                Text("Kevin Durant")
                                    .font(.title2)
                                    .bold()
                                    .foregroundStyle(.white)
                                
                                Text("@easymoneysniper")
                                    .font(.callout)
                                    .foregroundStyle(Color(UIColor.systemGray4))
                            }
                        }
                        .padding(.leading)
                        .offset(y: -50)
                    }
                    
                    // Menu Options
                    VStack(spacing: 0) {
                        NavigationLink {
                            if let user = AuthService.shared.currentUser {
                                AccountView(user: user)
                            }
                        } label: {
                            HStack {
                                Image(systemName: "person.crop.square.fill")
                                    .foregroundStyle(.gray)
                                
                                Text("Account")
                                    .foregroundStyle(.studChat)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .foregroundStyle(.studChat)
                            }
                            .padding()
                        }
                        .background(Color(uiColor: .systemGray5))
                        
                        Divider()
                        
                        Button {
                            showEditProfile = true
                        } label: {
                            HStack {
                                Image(systemName: "pencil")
                                    .foregroundStyle(.gray)
                                
                                Text("Edit Profile")
                                    .foregroundStyle(.studChat)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .foregroundStyle(.studChat)
                            }
                            .padding()
                        }
                        .background(Color(uiColor: .systemGray5))
                        
                        Divider()
                            .padding(.bottom)
                    }
                    
                    // Log Out Button
                    Button("Log Out") {
                        Task {
                            do {
                                try await AuthService.shared.signOut()
                            } catch {
                                print(error.localizedDescription)
                            }
                        }
                    }
                    .foregroundStyle(.red)
                    .padding()
                }
            }
            .background(Color(.background))
        }
        .sheet(isPresented: $showEditProfile) {
            if let user = AuthService.shared.currentUser {
                EditProfileView(user: user)
            }
        }
    }
}

#Preview {
    ProfileView()
}
