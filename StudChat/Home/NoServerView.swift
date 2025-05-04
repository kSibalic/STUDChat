//
//  NoServerView.swift
//  StudChat
//
//  Created by Karlo Šibalić on 01.05.2025..
//

import SwiftUI

struct NoServerView: View {
    
    @Binding var showCreateServer: Bool
    
    var body: some View {
        VStack {
            Text("Servers")
                .font(.title2)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(.studChat)
            
            Spacer()
            
            Image("studChat")
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width - 170, height: 250, alignment: .center)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            Text("No servers found")
                .font(.title3)
                .fontWeight(.bold)
                .padding()
                .foregroundStyle(.studChat)
            
            Text("When you join or create server\n it will pop up here.")
                .multilineTextAlignment(.center)
                .foregroundStyle(.studChat)
                
            
            Button {
                showCreateServer = true
            } label: {
                Text("Create a Server")
                    .fontWeight(.bold)
                    .frame(height: 40)
                    .foregroundStyle(.studChat)
                    .frame(maxWidth: .infinity)
                    .background(Color(.background))
                    .cornerRadius(10)
            }
            
            Spacer(minLength: 160)
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .frame(width: 235)
        .ignoresSafeArea()
        .padding()
        .background(Color(.background))
    }
}

#Preview {
    NoServerView(showCreateServer: .constant(false))
}
