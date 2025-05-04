//
//  ChatRoomView.swift
//  StudChat
//
//  Created by Karlo Šibalić on 30.04.2025..
//

import SwiftUI
import SDWebImageSwiftUI

struct ChatRoomView: View {
    
    @Binding var messages: [Message]
    
    @State var message = ""
    
    var channel: Channel
    
//    var mockMessages = [
  //      Message(id: UUID(), createdAt: .now, username: "KerProgramer", imgURL: "pfp", text: "Kolega morate koristiti shortcutove"),
    //    Message(id: UUID(), createdAt: .now, username: "TomaP", imgURL: "pfp", text: "U vim-u nema shortcutova"),
      //  Message(id: UUID(), createdAt: .now, username: "KerProgramer", imgURL: "pfp", text: "Kolega kako ne znate što je apstraktna tvornica"),
        //Message(id: UUID(), createdAt: .now, username: "TomaP", imgURL: "pfp", text: "Prebit ce me levara ako ne rijesim 212 ruby bugova do sutra"),
    //]
    
    
    var body: some View {
        VStack(alignment: .leading) {
            ScrollViewReader { scrollView in
                ScrollView {
                    VStack {
                        VStack(alignment: .leading) {
                            Image(systemName: "number")
                                .imageScale(.large)
                                .padding()
                                .background {
                                    Circle()
                                        .fill(Color(uiColor: .systemGray5))
                                }
                                .padding(.bottom, 24)
                            
                            HStack {
                                Text("Welcome to ") +
                                Text(channel.name)
                                    .foregroundStyle(.studChat) +
                                Text(" channel!")
                            }
                            .font(.title2)
                            .bold()
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        
                        LazyVStack {
                            ForEach(messages) { message in
                                HStack(alignment: .top) {
                                    if message.imgURL.isEmpty {
                                        Text(message.username.prefix(1))
                                            .font(.largeTitle)
                                            .frame(width: 32)
                                            .padding()
                                            .foregroundStyle(.white)
                                            .background {
                                                Circle()
                                                    .fill(Color(.studChat))
                                            }
                                    } else {
                                        WebImage(url: URL(string: message.imgURL))
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 48, height: 48)
                                            .clipShape(Circle())
                                    }
                                    
                                    VStack(alignment: .leading) {
                                        HStack {
                                            Text(message.username)
                                                .bold()
                                            
                                            Text(message.createdAt.formatted())
                                                .font(.caption)
                                        }
                                        
                                        Text(message.text)
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal)
                                .padding(.bottom, 8)
                            }
                        }
                    }
                    //.offset(y: CGFloat(message.isEmpty ? 500 : 500 - 60 * messages.count))
                }
                .onAppear {
                    withAnimation {
                        scrollView.scrollTo(messages.count - 1, anchor: .bottom)
                    }
                }
                .onChange(of: messages) { oldValue, newValue in
                    withAnimation {
                        scrollView.scrollTo(messages.count - 1, anchor: .bottom)
                    }
                }
            }
            
            
            Divider()
                .overlay {
                    Color.studChat
                }
            
            HStack {
                TextField("Message #\(channel.name)", text: $message)
                    .padding()
                    .background {
                        Capsule()
                            .fill(Color(uiColor: .systemGray5))
                    }
                
                Button {
                    sendMessage()
                } label: {
                    Image(systemName: "arrow.up.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32)
                        .foregroundStyle(Color.studChat)
                        .background {
                            Circle()
                                .fill(Color(uiColor: .systemGray5))
                        }
                }
                .frame(height: 70)
            }
            .padding(.horizontal, 8)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    }
    
    func sendMessage() {
        Task {
            do {
                
                guard let user = AuthService.shared.currentUser,
                      message.count > 2
                else {
                    return
                }
                
                let message = Message(id: UUID(), createdAt: .now, username: user.username, imgURL: user.imageURL, text: message, channelUid: channel.channelUid, serverId: channel.serverId)
                
                try await DatabaseService.shared.sendMessage(message: message)
                messages.append(message)
                self.message = ""
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

#Preview {
    ChatRoomView(messages: .constant([]), channel: Channel(createdAt: .now, name: "rostiljada", channelUid: .init(), admin: .init(), serverId: 5, messages: []))
}
