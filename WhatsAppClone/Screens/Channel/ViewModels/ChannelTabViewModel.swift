//
//  ChannelTabViewModel.swift
//  WhatsAppClone
//
//  Created by enesozmus on 5.08.2024.
//

import Foundation

final class ChannelTabViewModel: ObservableObject {
    
    // MARK: Properties
    @Published var navigateToChatRoom = false
    @Published var newChannel: ChannelItem?
    @Published var showChatPartnerPickerView = false
    
    
    // MARK: Public Methods
    func onNewChannelCreation(_ channel: ChannelItem) {
        showChatPartnerPickerView = false
        newChannel = channel
        navigateToChatRoom = true
    }
}
