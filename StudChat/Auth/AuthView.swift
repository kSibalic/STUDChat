//
//  AuthView.swift
//  StudChat
//
//  Created by Karlo Šibalić on 30.04.2025..
//

import SwiftUI

struct AuthView: View {
    
    @State var viewModel = AuthViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                Image("studChat")
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width, height: 300)
                    .clipped()
                
                Spacer()
                
                Text("Welcome to STUDChat")
                    .font(.title)
                    .bold()
                
                Text("The most popular platform for messaging and sharing materials between studetnts and professors worldwide")
                    .font(.caption)
                    .padding()
                    .multilineTextAlignment(.center)

                Spacer()
                
                NavigationLink {
                    EmailView()
                        .environment(viewModel)
                } label: {
                    Text("Register")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(Color(.background))
                        .background(Color(.studChat))
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                
                NavigationLink {
                    SignInView()
                        .environment(viewModel)
                } label: {
                    Text("Log In")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(Color(.studChat))
                        .background(Color(.background))
                        .padding(.horizontal)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .background(Color(.background))
        }
    }
}

#Preview {
    AuthView()
}
