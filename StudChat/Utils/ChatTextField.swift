//
//  ChatTextField.swift
//  StudChat
//
//  Created by Karlo Šibalić on 01.05.2025..
//

import SwiftUI

struct ChatTextField: View {
    
    var header: String
    var placeHolder: String
    
    @Binding var text: String
    
    var body: some View {
        VStack {
            Text(header)
                .font(.footnote)
                .textCase(.uppercase)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            TextField(placeHolder, text: $text)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(10)
        }
    }
}

#Preview {
    ChatTextField(header: "Account info", placeHolder: "Email", text: .constant(""))
}
