//
//  CreateChannelView.swift
//  StudChat
//
//  Created by Karlo Šibalić on 01.05.2025..
//

import SwiftUI

struct CreateChannelView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State var name = ""
    
    var server: Server
    
    var body: some View {
        VStack {
            HStack {
                Button("Close") {
                    dismiss()
                }
                
                Spacer()
                
                Text("Create Channel")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                
                Button("Create") {
                    createChannel()
                }
            }
            .padding()
            .foregroundStyle(.studChat)
            
            ScrollView {
                ChatTextField(header: "Channel name", placeHolder: "new-channel", text: $name)
                
                Text("Channel Type")
                    .font(.callout)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical)
                
                HStack {
                    Image(systemName: "number")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18)
                        .foregroundStyle(Color(uiColor: .systemGray2))
                    
                    VStack(alignment: .leading) {
                        Text("Text")
                            .foregroundStyle(.studChat)
                        
                        Text("Post images, documents, videos and GIFs")
                            .font(.caption)
                            .foregroundStyle(Color(uiColor: .systemGray2))
                            .lineLimit(1)
                    }
                    
                    Spacer()
                    
                    Toggle("", isOn: .constant(true))
                        .toggleStyle(.button)
                        .tint(.studChat)
                        .clipShape(Circle())
                        .overlay {
                            Circle()
                                .stroke()
                                .padding(-6)
                        }
                }
                .padding(.horizontal)
            }
            .padding()
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .background(Color(.background))
        .onChange(of: name) { oldValue, newValue in
            name = name.replacingOccurrences(of: " ", with: "-")
        }
    }
    
    func createChannel() {
        Task {
            do {
                guard let user = AuthService.shared.currentUser,
                      let uid = user.id,
                      let serverId = server.id,
                      name.count > 2 else {
                    return
                }
                let channel = Channel(createdAt: .now, name: name, channelUid: UUID(), admin: uid, serverId: serverId, messages: [])
                try await DatabaseService.shared.createChannelForServer(admin: user, server: server, channel: channel)
                
                dismiss()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

#Preview {
    CreateChannelView(server: Server(createdAt: .now, name: "RMA Ferit", imageURL: "", admin: .init(), members: [], channels: []))
}
