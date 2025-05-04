//
//  NameView.swift
//  StudChat
//
//  Created by Karlo Šibalić on 01.05.2025..
//

import SwiftUI

struct NameView: View {
    
    @Environment(\.authViewModel) var viewModel

    var body: some View {
        
        @Bindable var viewModel = viewModel
        
        VStack {
            Text("What is your name")
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom, 24)
            
            ChatTextField(header: "Display name", placeHolder: "", text: $viewModel.registerDisplayName)
            
            NavigationLink {
                UsernameView()
                    .environment(viewModel)
            } label: {
                Text("Next")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(Color.background)
                    .background(Color.studChat)
                    .cornerRadius(10)
            }
            .disabled(viewModel.registerDisplayName.isEmpty)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color(.background))
    }
}

#Preview {
    NameView()
}
