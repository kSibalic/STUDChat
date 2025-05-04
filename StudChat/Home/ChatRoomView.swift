//
//  ChatRoomView.swift
//  StudChat
//
//  Created by Karlo Šibalić on 30.04.2025..
//

import SwiftUI
import SDWebImageSwiftUI
import Combine

class KeyboardObserver: ObservableObject {
    @Published var keyboardHeight: CGFloat = 0
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .compactMap { notification -> CGFloat? in
                guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
                    return nil
                }
                return keyboardFrame.height
            }
            .sink { [weak self] height in
                withAnimation(.easeOut(duration: 0.25)) {
                    self?.keyboardHeight = height
                }
            }
            .store(in: &cancellables)
        
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
            .sink { [weak self] _ in
                withAnimation(.easeOut(duration: 0.25)) {
                    self?.keyboardHeight = 0
                }
            }
            .store(in: &cancellables)
    }
}

struct ChatRoomView: View {
    
    @Binding var messages: [Message]
    
    @State var message = ""
    @FocusState private var isInputFocused: Bool
    @StateObject private var keyboardObserver = KeyboardObserver()
    
    var channel: Channel
        
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
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
                                .id(message.id)
                            }
                        }
                    }
                }
                .onAppear {
                    if !messages.isEmpty {
                        withAnimation {
                            scrollView.scrollTo(messages.last?.id, anchor: .bottom)
                        }
                    }
                }
                .onChange(of: messages) { oldValue, newValue in
                    if !newValue.isEmpty {
                        withAnimation {
                            scrollView.scrollTo(newValue.last?.id, anchor: .bottom)
                        }
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
                    .focused($isInputFocused)
                
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
                .disabled(message.trimmingCharacters(in: .whitespacesAndNewlines).count < 3)
            }
            .padding(.horizontal, 8)
            .padding(.bottom, keyboardObserver.keyboardHeight > 0 ? keyboardObserver.keyboardHeight - 20 : 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .animation(.easeOut(duration: 0.25), value: keyboardObserver.keyboardHeight)
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
