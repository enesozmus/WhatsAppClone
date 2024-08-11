//
//  ChatRoomScreen.swift
//  WhatsAppClone
//
//  Created by enesozmus on 30.07.2024.
//

import SwiftUI

struct ChatRoomScreen: View {
    
    // MARK: Properties
    let channel: ChannelItem
    @StateObject private var viewModel: ChatRoomViewModel
    
    // MARK: Init
    init(channel: ChannelItem) {
        self.channel = channel
        _viewModel = StateObject(wrappedValue: ChatRoomViewModel(channel))
    }
    
    var body: some View {
        MessageList(viewModel)
            .toolbar(.hidden, for: .tabBar)
            .toolbar {
                leadingNavItems()
                trailingNavItems()
            }
            .navigationBarTitleDisplayMode(.inline)
            .safeAreaInset(edge: .bottom) {
                bottomSafeAreaView()
            }
    }
}


// MARK: Extension... Toolbar Items
extension ChatRoomScreen {
    
    private var channelTitle: String {
        let maxChar = 20
        let trailingChars = channel.title.count > maxChar ? "..." : ""
        let title = String(channel.title.prefix(maxChar) + trailingChars)
        return title
    }
    
    @ToolbarContentBuilder
    private func leadingNavItems() -> some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            HStack {
                CircularProfileImageView(channel, size: .mini)
                
                Text(channelTitle)
                    .bold()
            }
        }
    }
    
    @ToolbarContentBuilder
    private func trailingNavItems() -> some ToolbarContent {
        ToolbarItemGroup(placement: .topBarTrailing) {
            Button {
                
            } label: {
                Image(systemName: "video")
            }
            
            Button {
                
            } label: {
                Image(systemName: "phone")
            }
        }
    }
    
    private func bottomSafeAreaView() -> some View {
        VStack(spacing: 0) {
            
            Divider()
            MediaAttachmentPreview()
            Divider()
            
            TextInputArea(textMessage: $viewModel.textMessage) {
                viewModel.sendMessage()
            }
        }
    }
}


// MARK: Preview
#Preview {
    NavigationStack {
        ChatRoomScreen(channel: .placeholder)
    }
}
