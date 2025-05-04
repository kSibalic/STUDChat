//
//  ChatTabView.swift
//  StudChat
//
//  Created by Karlo Šibalić on 30.04.2025..
//

import SwiftUI

struct ChatTabView: View {
    @State var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tag(0)
                .tabItem {
                    Image(systemName: "house.fill")
                }
            
            UserSearchView()
                .tag(1)
                .tabItem {
                    Image(systemName: "magnifyingglass")
                }
            
            ProfileView()
                .tag(2)
                .tabItem {
                    Image(systemName: "person.fill")
                }
        }
    }
}

#Preview {
    ChatTabView()
}
