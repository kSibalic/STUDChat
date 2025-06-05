//
//  EditProfileView.swift
//  StudChat
//
//  Created by Karlo Šibalić on 01.05.2025..
//

import SwiftUI
import PhotosUI

struct EditProfileView: View {
    @Environment(\.dismiss) var dismiss
    @State private var username: String
    @State private var selectedImage: PhotosPickerItem?
    @State private var profileImage: UIImage?
    @State private var isLoading = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    private let user: ChatUser
    
    init(user: ChatUser) {
        self.user = user
        self._username = State(initialValue: user.username)
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Profile Picture Section
                VStack {
                    ZStack {
                        if let profileImage {
                            Image(uiImage: profileImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 120, height: 120)
                                .clipShape(Circle())
                        } else if !user.imageURL.isEmpty {
                            AsyncImage(url: URL(string: user.imageURL)) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                            } placeholder: {
                                Circle()
                                    .fill(Color.studChat)
                                    .overlay {
                                        Text(user.username.prefix(1))
                                            .font(.largeTitle)
                                            .foregroundStyle(.white)
                                    }
                            }
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                        } else {
                            Circle()
                                .fill(Color.studChat)
                                .frame(width: 120, height: 120)
                                .overlay {
                                    Text(user.username.prefix(1))
                                        .font(.largeTitle)
                                        .foregroundStyle(.white)
                                }
                        }
                        
                        // Camera overlay
                        Circle()
                            .fill(Color.black.opacity(0.3))
                            .frame(width: 120, height: 120)
                            .overlay {
                                Image(systemName: "camera.fill")
                                    .foregroundStyle(.white)
                                    .font(.title2)
                            }
                    }
                    
                    PhotosPicker(selection: $selectedImage, matching: .images) {
                        Text("Change Photo")
                            .font(.callout)
                            .foregroundStyle(.studChat)
                    }
                }
                .padding(.top)
                
                // Username Section
                VStack(alignment: .leading, spacing: 8) {
                    Text("USERNAME")
                        .font(.footnote)
                        .fontWeight(.medium)
                        .foregroundStyle(.secondary)
                    
                    HStack {
                        Text("@")
                            .foregroundStyle(.secondary)
                            .font(.body)
                        
                        TextField("Username", text: $username)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .font(.body)
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                // Save Button
                Button {
                    saveChanges()
                } label: {
                    HStack {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(0.8)
                        }
                        Text("Save Changes")
                            .fontWeight(.medium)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.studChat)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .disabled(isLoading || username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                .padding(.horizontal)
                .padding(.bottom)
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundStyle(.studChat)
                }
            }
            .onChange(of: selectedImage) { _, newValue in
                loadImage(from: newValue)
            }
            .alert("Profile Update", isPresented: $showAlert) {
                Button("OK") {
                    if alertMessage.contains("success") {
                        dismiss()
                    }
                }
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    private func loadImage(from item: PhotosPickerItem?) {
        guard let item else { return }
        
        Task {
            if let data = try? await item.loadTransferable(type: Data.self),
               let uiImage = UIImage(data: data) {
                await MainActor.run {
                    profileImage = uiImage
                }
            }
        }
    }
    
    private func saveChanges() {
        isLoading = true
        
        Task {
            do {
                var updatedUser = user
                updatedUser.username = username.trimmingCharacters(in: .whitespacesAndNewlines)
                
                // Upload image if selected
                if let profileImage {
                    let imageURL = try await ProfileService.shared.uploadProfileImage(profileImage, for: user.id!)
                    updatedUser.imageURL = imageURL
                }
                
                // Update user in database
                try await ProfileService.shared.updateUserProfile(updatedUser)
                
                // Just dismiss - let the app refresh naturally
                await MainActor.run {
                    dismiss()
                }
                
            } catch {
                await MainActor.run {
                    isLoading = false
                    alertMessage = "Failed to update profile: \(error.localizedDescription)"
                    showAlert = true
                }
            }
        }
    }
}

#Preview {
    EditProfileView(user: ChatUser(
        id: UUID(),
        createdAt: .now,
        username: "testuser",
        displayName: "Test User",
        email: "test@example.com",
        imageURL: "",
        dob: .now,
        servers: []
    ))
}
