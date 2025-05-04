//
//  ContentView.swift
//  StudChat
//
//  Created by Karlo Šibalić on 30.04.2025..
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        if let user = AuthService.shared.currentUser {
            ChatTabView()
        } else {
            AuthView()
        }
    }
}

#Preview {
    ContentView()
}
