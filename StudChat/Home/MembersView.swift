//
//  MembersView.swift
//  StudChat
//
//  Created by Karlo Šibalić on 02.05.2025..
//

import SwiftUI

struct MembersView: View {
    
    @State var members = [ChatUser]()
    @State var memberSearch = ""
    
    var server: Server
    
    var body: some View {
        
        VStack {
            Text("Members")
                .font(.title)
                .fontWeight(.bold)
            
            List(members) { member in
                HStack {
                    Text(member.username.prefix(1))
                        .font(.largeTitle)
                        .frame(width: 32)
                        .padding()
                        .foregroundStyle(.white)
                        .background {
                            Circle()
                                .fill(Color(.studChat))
                        }
                    
                    Text(member.username)
                        .font(.title3)
                }
            }
        }
        .frame(maxHeight: .infinity)
        .padding(.trailing, 90)
        .background(Color(.background))
        .scrollContentBackground(.hidden)
        .onChange(of: DatabaseService.shared.users) { oldValue, newValue in
            fetchMembers()
        }
        .onAppear {
            fetchMembers()
        }
    }
    
    func fetchMembers() {
        members = DatabaseService.shared.users.filter { user in
            server.members.contains(where: {
                $0 == user.id
            })
        }
    }
}

#Preview {
    MembersView(server: Server(createdAt: .now, name: "RMA Ferit", imageURL: "", admin: .init(), members: [], channels: []))
}
