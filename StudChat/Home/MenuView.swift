//
//  MenuView.swift
//  StudChat
//
//  Created by Karlo Šibalić on 30.04.2025..
//

import SwiftUI

struct MenuView: View {
    
    @Binding var showCreateServer: Bool
    @Binding var selectedServer: Server?
    @Binding var selectedChannel: Channel?
    
    @State var showChannels = true
    @State var showCreateChannel = false
    
    var body: some View {
        HStack(spacing: 0) {
            //Servers
            ScrollView {
                VStack {
                    ForEach(DatabaseService.shared.userServers) { server in
                        Button {
                            selectedServer = server
                            selectedChannel = server.channelModels.first
                        } label: {
                            Text(server.name.prefix(1))
                                .font(.largeTitle)
                                .foregroundStyle(Color(.background))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                                .background {
                                    Circle()
                                        .fill(Color(.studChat))
                                }
                        }
                    }
                    
                    Button {
                        showCreateServer = true
                    } label: {
                        Image(systemName: "plus")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24)
                            .foregroundStyle(.studChat)
                            .padding()
                            .background {
                                Circle()
                                    .fill(.ultraThinMaterial)
                            }
                            .padding(.vertical)
                    }
                }
            }
            .frame(width: 60)
            .frame(maxHeight: .infinity, alignment: .topLeading)
            .padding(8)
            .background(.ultraThickMaterial)
                
            if let selectedServer {
                VStack(alignment: .leading) {
                    HStack {
                        Text(selectedServer.name)
                            .font(.title2)
                            .bold()
                        
                        Spacer()
                        
                        Image(systemName: "ellipsis")
                            .fontWeight(.heavy)
                    }
                    .padding(.bottom, 24)
                    .padding(.trailing)
                    
                    HStack {
                        Button {
                            withAnimation {
                                showChannels.toggle()
                            }
                        } label: {
                            HStack(spacing: 0) {
                                Image(systemName: showChannels ? "chevron.down" : "chevron.right")
                                    .frame(width: 24)
                                
                                Text("Text channels")
                                    .textCase(.uppercase)
                                    .font(.caption)
                                    .bold()
                            }
                        }
                        .foregroundStyle(.gray)
                        
                        Spacer()
                        
                        if AuthService.shared.currentUser?.id == selectedServer.admin {
                            Button {
                                showCreateChannel = true
                            } label: {
                                Image(systemName: "plus")
                                    .foregroundStyle(.studChat)
                            }
                        }
                    }
                    
                    if showChannels {
                        ScrollView {
                            ForEach(selectedServer.channelModels) { channel in
                                Button {
                                    withAnimation {
                                        selectedChannel = channel
                                    }
                                } label: {
                                    HStack {
                                        Image(systemName: "number")
                                            .foregroundStyle(.gray)
                                        
                                        Text(channel.name)
                                            .font(.title3)
                                            .bold(selectedChannel == channel)
                                            .foregroundStyle(selectedChannel == channel ? .studChat : .gray)
                                    }
                                }
                                .padding(8)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundStyle(.studChat)
                                .background {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(selectedChannel == channel ? Color(uiColor: .systemGray5) : .clear)
                                }
                            }
                        }
                    } else if let selectedChannel, !showChannels {
                        HStack {
                            Image(systemName: "number")
                                .foregroundStyle(.gray)
                            
                            Text(selectedChannel.name)
                                .font(.title3)
                                .bold()
                                .foregroundStyle(.studChat)
                        }
                        .padding(8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(UIColor.systemGray5))
                        }
                    }
                }
                .frame(maxHeight: .infinity, alignment: .topLeading)
                .frame(width: 230)
                .padding(.top, 60)
                .padding()
                .background {
                    Color(.background)
                }
                .ignoresSafeArea()
            } else {
                NoServerView(showCreateServer: $showCreateServer)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .fullScreenCover(isPresented: $showCreateChannel) {

            if let selectedServer {
                CreateChannelView(server: selectedServer)
            }
            
        }
        .onAppear {
            selectedServer = DatabaseService.shared.userServers.first
        }
    }
}

#Preview {
    MenuView(showCreateServer: .constant(false), selectedServer: .constant(nil), selectedChannel: .constant(Channel(createdAt: .now, name: "", channelUid: .init(), admin: .init(), serverId: 8, messages: [])))
}
