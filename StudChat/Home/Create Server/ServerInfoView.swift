//
//  ServerInfoView.swift
//  StudChat
//
//  Created by Karlo Šibalić on 01.05.2025..
//

import SwiftUI

struct ServerInfoView: View {
    
    @Binding var showCreateServer: Bool
    
    @State var serverName = ""
    
    var body: some View {
        VStack {
            Text("Create Your  Server")
                .font(.title)
                .fontWeight(.bold)
                .padding()
            
            Text("Server is the place where you can create your own community, share your knowledge, and connect with other students.")
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.6)
                .padding(.bottom)
            
            Button {
                
            } label: {
                ZStack {
                    Image(systemName: "circle.dotted")
                        .resizable()
                        .scaledToFit()
                    
                    Image(systemName: "camera.fill")
                        .resizable()
                        .scaledToFit()
                        .padding(36)
                        .padding(.bottom)
                    
                    Text("Upload")
                        .font(.caption2)
                        .textCase(.uppercase)
                        .padding(.top, 42)
                }
                .foregroundStyle(.studChat)
                .frame(width: 110)
                .overlay(alignment: .topTrailing) {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32)
                        .foregroundStyle(.studChat)
                        .background(
                            Circle()
                                .fill(.white)
                        )
                }
            }
            
            ChatTextField(header: "Server Name", placeHolder: "", text: $serverName)
                .padding(.bottom)
            
            Button {
                createServer()
            } label: {
                Text("Create Server")
                    .bold()
                    .foregroundStyle(Color(.background))
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        .studChat
                    )
                    .cornerRadius(10)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding()
        .background(Color(.background))
    }
    
    func createServer() {
        if let user = AuthService.shared.currentUser, serverName.count > 2 {
            Task {
                do {
                    try await DatabaseService.shared.createServer(user: user, serverName: serverName)
                    
                    showCreateServer = false
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

#Preview {
    ServerInfoView(showCreateServer: .constant(true))
}
