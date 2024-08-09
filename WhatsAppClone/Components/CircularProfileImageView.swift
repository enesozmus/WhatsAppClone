//
//  CircularProfileImageView.swift
//  WhatsAppClone
//
//  Created by enesozmus on 9.08.2024.
//

import Kingfisher
import SwiftUI


// MARK: View
struct CircularProfileImageView: View {
    
    // MARK: Properties
    let profileImageUrl: String?
    let size: Size
    let fallbackImage: FallbackImage
    
    
    // MARK: Init
    init(_ profileImageUrl: String? = nil, size: Size) {
        self.profileImageUrl = profileImageUrl
        self.size = size
        self.fallbackImage = .directChatIcon
    }
    
    var body: some View {
        if let profileImageUrl {
            KFImage(URL(string: profileImageUrl))
                .resizable()
                .placeholder { ProgressView() }
                .scaledToFill()
                .frame(width: size.dimension, height: size.dimension)
                .clipShape(Circle())
        } else {
            placeholderImageView()
        }
    }
}


// MARK: Extension
extension CircularProfileImageView {
    init(_ channel: ChannelItem, size: Size) {
        self.profileImageUrl = channel.coverImageUrl
        self.size = size
        self.fallbackImage = FallbackImage(for: channel.membersCount)
    }
    
    enum Size {
        case mini, xSmall, small, medium, large, xLarge
        case custom(CGFloat)
        
        var dimension: CGFloat {
            switch self {
                
            case .mini:
                return 30
                
            case .xSmall:
                return 40
                
            case .small:
                return 50
                
            case .medium:
                return 60
                
            case .large:
                return 80
                
            case .xLarge:
                return 120
                
            case .custom(let dimen):
                return dimen
            }
        }
    }
    
    enum FallbackImage: String {
        case directChatIcon = "person.circle.fill"
        case groupChatIcon = "person.2.circle.fill"
        
        init(for membersCount: Int) {
            switch membersCount {
            case 2:
                self = .directChatIcon
            default:
                self = .groupChatIcon
            }
        }
    }
    
    private func placeholderImageView() -> some View {
        Image(systemName: fallbackImage.rawValue)
            .resizable()
            .scaledToFit()
            .imageScale(.large)
            .foregroundStyle(Color.placeholder)
            .frame(width: size.dimension, height: size.dimension)
            .background(.white)
            .clipShape(Circle())
    }
}


// MARK: Preview
#Preview {
    CircularProfileImageView(size: .large)
}
