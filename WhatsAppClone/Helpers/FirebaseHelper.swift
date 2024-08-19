//
//  FirebaseHelper.swift
//  WhatsAppClone
//
//  Created by enesozmus on 19.08.2024.
//

import FirebaseStorage
import UIKit


typealias UploadCompletion = (Result<URL, Error>) -> Void
typealias ProgressHandler = (Double) -> Void  // → return percent of upload progress: 100%, 50%


struct FirebaseHelper {
    
    // MARK: Upload Only The Image
    static func uploadImage(
        _ image: UIImage,
        for type: UploadType,
        completion: @escaping UploadCompletion,
        progressHandler: @escaping ProgressHandler
    ) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
        
        /// path file
        let storageRef = type.filePath
        
        /// StorageUploadTask is a class provided by Firebase Storage to handle the upload process
        let uploadTask: StorageUploadTask = storageRef.putData(imageData) { _, error in
            if let error = error {
                print("Failed to Upload Image to Storage: \(error.localizedDescription)")
                completion(.failure(UploadError.failedToUploadImage(error.localizedDescription)))
                return
            }
            
            // completion: (Result<URL, any Error>) -> Void
            storageRef.downloadURL(completion: completion)
        }
        
        // observable percentage of upload progress (How long will it take to finish the progress??)
        uploadTask.observe(.progress) { snapshot in
            guard let progress = snapshot.progress else { return }
            let percentage = Double(progress.completedUnitCount / progress.totalUnitCount)
            
            /// completion
            progressHandler(percentage)
        }
    }
    
    // MARK: Upload Video,Audio
    static func uploadFile(
        for type: UploadType,
        fileURL: URL,
        completion: @escaping UploadCompletion,
        progressHandler: @escaping ProgressHandler
    ) {
        /// path file
        let storageRef = type.filePath
        
        /// StorageUploadTask is a class provided by Firebase Storage to handle the upload process
        let uploadTask: StorageUploadTask = storageRef.putFile(from: fileURL) { _, error in
            if let error = error {
                print("Failed to Upload Image to Storage: \(error.localizedDescription)")
                completion(.failure(UploadError.failedToUploadFile(error.localizedDescription)))
                return
            }
            
            // completion: (Result<URL, any Error>) -> Void
            storageRef.downloadURL(completion: completion)
        }
        
        // observable percentage of upload progress (How long will it take to finish the progress??)
        uploadTask.observe(.progress) { snapshot in
            guard let progress = snapshot.progress else { return }
            let percentage = Double(progress.completedUnitCount / progress.totalUnitCount)
            
            /// completion
            progressHandler(percentage)
        }
    }
}


// MARK: Extension
extension FirebaseHelper {
    enum UploadType {
        case profilePhoto
        case photoMessage
        case videoMessage
        case voiceMessage
        
        var filePath: StorageReference {
            let filename = UUID().uuidString
            switch self {
            case .profilePhoto :
                return FirebaseConstants.StorageRef.child("profile_photo").child(filename)
            case .photoMessage:
                return FirebaseConstants.StorageRef.child("photo_messages").child(filename)
            case .videoMessage:
                return FirebaseConstants.StorageRef.child("video_messages").child(filename)
            case .voiceMessage:
                return FirebaseConstants.StorageRef.child("voice_messages").child(filename)
            }
        }
    }
}


// MARK: Errors
enum UploadError: Error {
    case failedToUploadImage(_ description: String)
    case failedToUploadFile(_ description: String)
}

extension UploadError {
    var errorDescription: String? {
        switch self {
        case .failedToUploadImage(let description):
            return description
        case .failedToUploadFile(let description):
            return description
        }
    }
}
