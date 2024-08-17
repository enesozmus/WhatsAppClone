//
//  PhotosPickerItem+Extensions.swift
//  WhatsAppClone
//
//  Created by enesozmus on 17.08.2024.
//

import Foundation
import PhotosUI
import SwiftUI

extension PhotosPickerItem {
    var isVideo: Bool {
        let videoUTTypes: [UTType] = [
            .avi,
            .video,
            .mpeg2Video,
            .mpeg4Movie,
            .movie,
            .quickTimeMovie,
            .audiovisualContent,
            .mpeg,
            .appleProtectedMPEG4Video
        ]
        return videoUTTypes.contains(where: supportedContentTypes.contains)
    }
}
