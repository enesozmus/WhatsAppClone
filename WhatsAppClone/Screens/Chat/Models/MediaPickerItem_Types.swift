//
//  MediaPickerItem_Types.swift
//  WhatsAppClone
//
//  Created by enesozmus on 17.08.2024.
//

import SwiftUI


/// Transferable is a part of SwiftUI framework
struct VideoPickerTransferable: Transferable {
    let url: URL
    
    /// The propertise be inherited from Transferable protocol
    static var transferRepresentation: some TransferRepresentation {
        FileRepresentation(contentType: .movie) { exportingFile in
            return .init(exportingFile.url)
        } importing: { receivedTransferredFile in
            let originalFile = receivedTransferredFile.file
            let uniqueFileName = "\(UUID().uuidString).mov"
            let copiedFile = URL.documentsDirectory.appendingPathComponent(uniqueFileName)
            try FileManager.default.copyItem(at: originalFile, to: copiedFile)
            return .init(url: copiedFile)
        }
    }
}


struct MediaAttachment: Identifiable {
    let id: String
    let type: MediaAttachmentType
    var thumbnail: UIImage {
        switch type {
        case .photo(let thumbnail):
            return thumbnail
        case .video(let thumbnail, _):
            return thumbnail
        case .audio:
            return UIImage()
        }
    }
    
    var fileURL: URL? {
        switch type {
        case .photo:
            return nil
        case .video(_, let fileURL):
            return fileURL
        case .audio(let voiceURL, _):
            return voiceURL
        }
    }
    
    var duration: TimeInterval? {
        switch type {
        case .audio(_, let duration):
            return duration
        default:
            return nil
        }
    }
}


enum MediaAttachmentType: Equatable {
    case photo(_ thumbnail: UIImage)
    case video(_ thumbnail: UIImage, _ url: URL)
    case audio(_ url: URL, _ duration: TimeInterval)
    
    static func == (lhs: MediaAttachmentType, rhs: MediaAttachmentType) -> Bool {
        switch(lhs, rhs) {
        case (.photo,.photo), (.video, .video), (.audio, .audio):
            return true
        default:
            return false
        }
    }
}
