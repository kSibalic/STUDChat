//
//  SignInView.swift
//  StudChat
//
//  Created by Karlo Šibalić on 30.04.2025..
//

import SwiftUI

struct SignInView: View {
    
    @Environment(\.authViewModel) var viewModel
    
    var body: some View {
        @Bindable var viewModel = viewModel
        VStack {
            Text("Welcome back!")
                .font(.title)
                .fontWeight(.bold)
            
            Text("We're glad to see you back!")
                .foregroundStyle(.gray)
                .padding(.bottom)
            
            VStack(alignment: .leading) {
                
                ChatTextField(header: "Account Information", placeHolder: "Email Address", text: $viewModel.signInEmail)
                
                SecureField("Password", text: $viewModel.signInPassword)
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(10)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Button {
                viewModel.logIn()
            } label: {
                Text("Log In")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(Color.background)
                    .background(Color.studChat)
                    .cornerRadius(10)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color(.background))
    }
}

#Preview {
    SignInView()
}
