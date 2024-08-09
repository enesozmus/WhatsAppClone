//
//  ChatRoomViewModel.swift
//  WhatsAppClone
//
//  Created by enesozmus on 7.08.2024.
//

import Combine
import Foundation

final class ChatRoomViewModel: ObservableObject {
    
    // MARK: Properties
    @Published var textMessage: String = ""
    @Published var messages = [MessageItem]()
    private let channel: ChannelItem
    private var subscriptions = Set<AnyCancellable>()
    private var currentUser: UserItem?
    
    
    // MARK: Init
    init(_ channel: ChannelItem) {
        self.channel = channel
        listenToAuthState()
    }
    
    // MARK: Deinit
    deinit {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
        currentUser = nil
    }
    
    func sendMessage() {
        guard let currentUser else { return }
        MessageService.sendTextMessage(to: channel, from: currentUser, textMessage) { [weak self] in
            self?.textMessage = ""
        }
    }
    
    private func getMessages() {
        MessageService.getMessages(for: channel) { [weak self] messages in
            self?.messages = messages
            print("messages: \(messages.map { $0.text })")
        }
    }
    
    private func listenToAuthState() {
        AuthManager.shared.authState.receive(on: DispatchQueue.main).sink { [weak self] authState in
            switch authState {
            case .loggedIn(let currentUser):
                self?.currentUser = currentUser
                self?.getMessages()
            default:
                break
            }
        }.store(in: &subscriptions)
    }
}
