//
//  ServerSearchView.swift
//  StudChat
//
//  Created by Karlo Šibalić on 02.05.2025..
//

import SwiftUI

struct ServerSearchView: View {
    @Environment(\.dismiss) var dismiss
    
    @State var serverSearch = ""
    
    var body: some View {
        List(DatabaseService.shared.servers) { server in
            Button {
                joinServer(server)
            } label: {
                HStack {
                    Text(server.name.prefix(1))
                        .font(.largeTitle)
                        .frame(width: 32)
                        .padding()
                        .foregroundStyle(.white)
                        .background {
                            Circle()
                                .fill(Color(.studChat))
                        }
                    
                    Text(server.name)
                        .font(.title3)
                }
            }
            .foregroundStyle(.studChat)
        }
        .frame(maxHeight: .infinity)
        .background(Color(.background))
        .scrollContentBackground(.hidden)
        .searchable(text: $serverSearch)
        .navigationTitle("Servers")
    }
    
    func joinServer(_ server: Server) {
        Task {
            do {
                guard let user = AuthService.shared.currentUser,
                let uid = user.id,
                !server.members.contains(uid) else {
                    return
                }
                
                try await DatabaseService.shared.joinServer(server: server, user: user)
                dismiss()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

#Preview {
    ServerSearchView()
}
