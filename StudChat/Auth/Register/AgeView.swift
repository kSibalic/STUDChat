//
//  AgeView.swift
//  StudChat
//
//  Created by Karlo Šibalić on 01.05.2025..
//

import SwiftUI

struct AgeView: View {
    
    @Environment(\.authViewModel) var viewModel
    
    var body: some View {
        
        @Bindable var viewModel = viewModel
        
        VStack {
            Text("How old are you?")
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom, 24)
            
            Text("Date of Birth")
                .font(.footnote)
                .textCase(.uppercase)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Button {
                
            } label: {
                Text(viewModel.registerDOB.formatted())
                    .padding()
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(Color.studChat)
                    .background(.ultraThinMaterial)
                    .cornerRadius(10)
            }
            
            Button {
                viewModel.createAccount()
            } label: {
                Text("Create an account")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(Color.background)
                    .background(.studChat)
                    .cornerRadius(10)
            }
            
            Spacer()
            
            DatePicker("", selection: $viewModel.registerDOB, displayedComponents: .date)
                .datePickerStyle(.wheel)
                .padding()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color(.background))
    }
}

#Preview {
    AgeView()
}
