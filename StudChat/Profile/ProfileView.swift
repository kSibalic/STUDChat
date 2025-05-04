//
//  ProfileView.swift
//  StudChat
//
//  Created by Karlo Šibalić on 30.04.2025..
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    Color.gray
                        .frame(height: 200)
                    
                    ZStack(alignment: .topLeading) {
                        Color.studChat
                            .frame(height: 140)
                        
                        VStack(alignment: .leading) {
                            Image("pfp")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100)
                                .clipShape(Circle())
                                .background {
                                    Circle()
                                        .fill(Color(.background))
                                        .padding(-8)
                                }
                            
                            Text("Ker Programer")
                                .font(.title2)
                                .bold()
                                .foregroundStyle(.white)
                            
                            Text("@kerProgramer")
                                .font(.callout)
                                .foregroundStyle(Color(UIColor.systemGray2))
                        }
                        .padding(.leading)
                        .offset(y: -50)
                    }
                    
                    NavigationLink {
                        
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
                    
                    NavigationLink {
                        
                    } label: {
                        HStack {
                            Image(systemName: "pencil")
                                .foregroundStyle(.gray)
                            
                            Text("Profile")
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
    }
}

#Preview {
    ProfileView()
}
