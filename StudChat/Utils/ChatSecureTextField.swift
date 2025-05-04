//
//  ChatSecureField.swift
//  StudChat
//
//  Created by Karlo Šibalić on 01.05.2025..
//

import SwiftUI

struct ChatSecureTextField: View {
    
    var header: String
    var placeHolder: String
    
    @Binding var text: String
    
    var body: some View {
        Text(header)
            .font(.footnote)
            .textCase(.uppercase)
            .frame(maxWidth: .infinity, alignment: .leading)
        
        SecureField(placeHolder, text: $text)
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(10)
    }
}

#Preview {
    ChatSecureTextField(header: "Password", placeHolder: "", text: .constant(""))
}
