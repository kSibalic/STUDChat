//
//  ProfileService.swift
//  StudChat
//
//  Created by Karlo Šibalić on 01.05.2025..
//

import Foundation
import UIKit

final class ProfileService {
    static let shared = ProfileService()
    
    private init() {}
    
    /// Uploads a profile image to Supabase storage and returns the public URL
    func uploadProfileImage(_ image: UIImage, for userId: UUID) async throws -> String {
        // Compress and convert image to data
        guard let imageData = compressImage(image) else {
            throw ProfileError.imageCompressionFailed
        }
        
        let fileName = "profile_\(userId.uuidString)_\(Int(Date().timeIntervalSince1970)).jpg"
        let filePath = "avatars/\(fileName)"
        
        // Use DatabaseService to upload to Supabase storage
        return try await DatabaseService.shared.uploadFile(
            bucket: "profiles", // Make sure this bucket exists in your Supabase project
            path: filePath,
            data: imageData,
            contentType: "image/jpeg"
        )
    }
    
    // MARK: - User Profile Update
    
    /// Updates user profile in the database
    func updateUserProfile(_ user: ChatUser) async throws {
        try await DatabaseService.shared.updateUserProfile(user)
    }
    
    // MARK: - Delete Profile Image
    
    /// Deletes the current profile image from storage
    func deleteProfileImage(imageURL: String) async throws {
        // Extract file path from URL
        guard let url = URL(string: imageURL),
              let pathComponents = url.pathComponents.last else {
            return
        }
        
        let filePath = "avatars/\(pathComponents)"
        
        try await DatabaseService.shared.deleteFile(bucket: "profiles", path: filePath)
    }
    
    // MARK: - Helper Methods
    
    private func compressImage(_ image: UIImage) -> Data? {
        // Resize image to max 1024x1024 while maintaining aspect ratio
        let maxSize: CGFloat = 1024
        let size = image.size
        
        let ratio = min(maxSize / size.width, maxSize / size.height)
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        
        let renderer = UIGraphicsImageRenderer(size: newSize)
        let resizedImage = renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: newSize))
        }
        
        // Compress to JPEG with 0.8 quality
        return resizedImage.jpegData(compressionQuality: 0.8)
    }
}

// MARK: - Error Types

enum ProfileError: LocalizedError {
    case imageCompressionFailed
    case invalidUserId
    case uploadFailed(String)
    
    var errorDescription: String? {
        switch self {
        case .imageCompressionFailed:
            return "Failed to compress image"
        case .invalidUserId:
            return "Invalid user ID"
        case .uploadFailed(let message):
            return "Upload failed: \(message)"
        }
    }
}
