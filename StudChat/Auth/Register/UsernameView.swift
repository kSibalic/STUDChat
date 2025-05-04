//
//  NameView.swift
//  StudChat
//
//  Created by Karlo Šibalić on 01.05.2025..
//

import SwiftUI

struct UsernameView: View {
    
    @Environment(\.authViewModel) var viewModel

    var body: some View {
        
        @Bindable var viewModel = viewModel
        
        VStack {
            Text("Next, create an account")
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom, 24)
            
            ChatTextField(header: "Username", placeHolder: "", text: $viewModel.registerUsername)
            
            ChatSecureTextField(header: "Password", placeHolder: "", text: $viewModel.registerPassword)
            
            NavigationLink {
                AgeView()
                    .environment(viewModel)
            } label: {
                Text("Next")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(Color.background)
                    .background(Color.studChat)
                    .cornerRadius(10)
            }
            .disabled(viewModel.registerPassword.isEmpty || viewModel.registerUsername.isEmpty)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color(.background))
    }
}

#Preview {
    UsernameView()
}
