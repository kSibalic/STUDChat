//
//  EmailView.swift
//  StudChat
//
//  Created by Karlo Šibalić on 01.05.2025..
//

import SwiftUI

struct EmailView: View {
    
    @Environment(\.authViewModel) var viewModel
    
    var body: some View {
        
        @Bindable var viewModel = viewModel
        
        VStack {
            Text("Enter email")
                .font(.title)
                .fontWeight(.bold)
            
            ChatTextField(header: "Email", placeHolder: "Email", text: $viewModel.registerEmail)
            
            NavigationLink {
                NameView()
                    .environment(viewModel)
            } label: {
                Text("Next")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(Color.background)
                    .background(.studChat)
                    .cornerRadius(10)
            }
            .disabled(viewModel.registerEmail.isEmpty)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color(.background))
    }
}

#Preview {
    EmailView()
}
