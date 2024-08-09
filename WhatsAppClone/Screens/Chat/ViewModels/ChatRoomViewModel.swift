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
    
    private(set) var channel: ChannelItem
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
    
    // MARK: Public Methods
    func sendMessage() {
        guard let currentUser else { return }
        MessageService.sendTextMessage(to: channel, from: currentUser, textMessage) {[weak self] in
            self?.textMessage = ""
        }
    }
    
    // MARK: Private Methods
    private func listenToAuthState() {
        AuthManager.shared.authState.receive(on: DispatchQueue.main).sink {[weak self] authState in
            guard let self = self else { return }
            switch authState {
            case .loggedIn(let currentUser):
                self.currentUser = currentUser
                
                if self.channel.allMembersFetched {
                    self.getMessages()
                    print("channel members: \(channel.members.map { $0.username })")
                } else {
                    self.getAllChannelMembers()
                }
            default:
                break
            }
        }.store(in: &subscriptions)
    }
    
    private func getMessages() {
        MessageService.getMessages(for: channel) { [weak self] messages in
            self?.messages = messages
            print("messages: \(messages.map { $0.text })")
        }
    }
    
    private func getAllChannelMembers() {
        /// I already have current user, and potentially 2 other members so no need to refetch those
        guard let currentUser = currentUser else { return }
        let membersAlreadyFetched = channel.members.compactMap { $0.uid }
        var memberUIDSToFetch = channel.membersUids.filter { !membersAlreadyFetched.contains($0) }
        memberUIDSToFetch = memberUIDSToFetch.filter { $0 != currentUser.uid }
        
        UserService.getUsers(with: memberUIDSToFetch) { [weak self] userNode in
            guard let self = self else { return }
            self.channel.members.append(contentsOf: userNode.users)
            self.getMessages()
            print("getAllChannelMembers: \(channel.members.map { $0.username })")
        }
    }
}
