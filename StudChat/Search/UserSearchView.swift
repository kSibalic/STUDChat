//
//  UserSearchView.swift
//  StudChat
//
//  Created by Karlo Šibalić on 30.04.2025..
//

import SwiftUI

struct UserSearchView: View {
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(.studChat)]
    }
    
    @State var userSearch = ""
    
    var filterUsers: [ChatUser] {
        DatabaseService.shared.users.filter {
            $0.username.localizedCaseInsensitiveContains(userSearch)
        }
    }
    
    var body: some View {
        NavigationStack {
            List(userSearch.isEmpty ? DatabaseService.shared.users : filterUsers) { user in
                HStack {
                    Text(user.username.prefix(1))
                        .font(.largeTitle)
                        .frame(width: 32)
                        .padding()
                        .foregroundStyle(.white)
                        .background {
                            Circle()
                                .fill(Color(.studChat))
                        }
                    
                    Text(user.username)
                        .font(.title3)
                }
            }
            .frame(maxHeight: .infinity)
            .background(Color.white)
            .scrollContentBackground(.hidden)
            .searchable(text: $userSearch)
            .navigationTitle("Users")
        }
    }
}

#Preview {
    UserSearchView()
}
