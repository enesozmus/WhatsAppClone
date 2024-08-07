//
//  ChatRoomViewModel.swift
//  WhatsAppClone
//
//  Created by enesozmus on 7.08.2024.
//

import Combine
import Foundation

final class ChatRoomViewModel: ObservableObject {
    @Published var textMessage = ""
    private let channel: ChannelItem
    private var subscriptions = Set<AnyCancellable>()
    
    
    @Published var currentUser: UserItem?
    
    init(_ channel: ChannelItem) {
        self.channel = channel
        listenToAuthState()
    }
    
    deinit {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
        currentUser = nil
    }
    
    func sendMessage() {
        guard let currentUser else { return }
        MessageService.sendTextMessage(to: channel, from: currentUser, textMessage) {[weak self] in
            self?.textMessage = ""
        }
    }
    
    private func listenToAuthState() {
        AuthManager.shared.authState.receive(on: DispatchQueue.main).sink { authState in
            switch authState {
            case .loggedIn(let currentUser):
                self.currentUser = currentUser
            default:
                break
            }
        }.store(in: &subscriptions)
    }
}
