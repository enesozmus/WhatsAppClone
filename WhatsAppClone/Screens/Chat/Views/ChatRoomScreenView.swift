//
//  ChatRoomScreenView.swift
//  WhatsAppClone
//
//  Created by enesozmus on 30.07.2024.
//

import SwiftUI

struct ChatRoomScreenView: View {
    
    // MARK: Properties
    let channel: ChannelItem
    @StateObject private var viewModel: ChatRoomViewModel
    
    // MARK: Init
    init(channel: ChannelItem) {
        self.channel = channel
        _viewModel = StateObject(wrappedValue: ChatRoomViewModel(channel))
    }
    
    var body: some View {
        MessageListView()
            .toolbar(.hidden, for: .tabBar)
            .toolbar {
                leadingNavItems()
                trailingNavItems()
            }
            .navigationBarTitleDisplayMode(.inline)
            .safeAreaInset(edge: .bottom) {
                TextInputArea(textMessage: $viewModel.textMessage) {
                    viewModel.sendMessage()
                }
            }
    }
}


// MARK: Extension... Toolbar Items
extension ChatRoomScreenView {
    @ToolbarContentBuilder
    private func leadingNavItems() -> some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            HStack {
                Circle()
                    .frame(width: 35, height: 30)
                    .foregroundStyle(.red)
                
                Text(channel.title)
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
}


// MARK: Preview
#Preview {
    NavigationStack {
        ChatRoomScreenView(channel: .placeholder)
    }
}
