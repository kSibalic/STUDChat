//
//  CreateServerView.swift
//  StudChat
//
//  Created by Karlo Šibalić on 01.05.2025..
//

import SwiftUI

struct CreateServerView: View {
    
    @Binding var showCreateServer: Bool
    
    var body: some View {
        NavigationStack {
            VStack {
                Button("Close") {
                    showCreateServer = false
                }
                .foregroundStyle(.studChat)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("Create Your Server")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                
                Text("Server is the place where you can create your own community, share your knowledge, and connect with other students.")
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.6)
                    .padding(.bottom)
                
                NavigationLink {
                    ServerInfoView(showCreateServer: $showCreateServer)
                } label: {
                    Text("Create My Own")
                        .fontWeight(.bold)
                        .foregroundStyle(.studChat)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(.ultraThinMaterial)
                        .overlay(alignment: .trailing) {
                            Image(systemName: "chevron.right")
                                .padding()
                                .foregroundStyle(.studChat)
                        }
                        .cornerRadius(10)
                }
                
                Spacer()
                
                Text("Have one in mind?")
                    .fontWeight(.bold)
                
                NavigationLink {
                    ServerSearchView()
                } label: {
                    Text("Join a Server")
                }
                .fontWeight(.bold)
                .foregroundStyle(.studChat)
                .padding()
                .frame(maxWidth: .infinity)
                .background(.ultraThinMaterial)
                .cornerRadius(10)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding()
            .background(Color(.background))
        }
    }
}

#Preview {
    CreateServerView(showCreateServer: .constant(true))
}
