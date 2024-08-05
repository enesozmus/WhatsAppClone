//
//  ChatPartnerPickerViewModel.swift
//  WhatsAppClone
//
//  Created by enesozmus on 3.08.2024.
//

import FirebaseAuth
import Foundation


enum ChannelCreationRoute {
    case groupPartnerPicker
    case setUpGroupChat
}

enum ChannelContants {
    static let maxGroupParticipants = 12
}

enum ChannelCreationError: Error {
    case noChatPartner
    case failedToCreateUniqueIds
}

@MainActor
final class ChatPartnerPickerViewModel: ObservableObject {
    
    // MARK: Properties
    @Published var navStack = [ChannelCreationRoute]()
    @Published var selectedChatPartners = [UserItem]()
    @Published private(set) var users = [UserItem]()
    @Published var errorState: (showError: Bool, errorMessage: String) = (false, "Uh Oh")
    
    private var lastCursor: String?
    
    var showSelectedUsers: Bool {
        return !selectedChatPartners.isEmpty
    }
    
    var disableNextButton: Bool {
        return selectedChatPartners.isEmpty
    }
    
    var isPaginatable: Bool {
        return !users.isEmpty
    }
    
    private var isDirectChannel: Bool {
        return selectedChatPartners.count == 1
    }
    
    // MARK: Init
    init() {
        Task {
            await fetchUsers()
        }
    }
    
    
    // MARK: - Public Methods
    func fetchUsers() async {
        do {
            let userNode = try await UserService.paginateUsers(lastCursor: lastCursor, pageSize: 5)
            var fetchedUsers = userNode.users
            guard let currentUid = Auth.auth().currentUser?.uid else { return }
            fetchedUsers = fetchedUsers.filter { $0.uid != currentUid }
            self.users.append(contentsOf: fetchedUsers)
            self.lastCursor = userNode.currentCursor
            print("lastCursor: \(lastCursor ?? "np") \(users.count)")
        } catch {
            print("💿 Failed to fetch users in ChatPartnerPickerViewModel")
        }
    }
    
    func handleItemSelection(_ item: UserItem) {
        if isUserSelected(item) {
            guard let index = selectedChatPartners.firstIndex(where: { $0.uid == item.uid }) else { return }
            selectedChatPartners.remove(at: index)
        } else {
            guard selectedChatPartners.count < ChannelContants.maxGroupParticipants else {
                let errorMessage = "Sorry, We only allow a Maximum of \(ChannelContants.maxGroupParticipants) participants in a group chat."
                showError(errorMessage)
                return
            }
            
            selectedChatPartners.append(item)
        }
    }
    
    func isUserSelected(_ user: UserItem) -> Bool {
        let isSelected = selectedChatPartners.contains { $0.uid == user.uid }
        return isSelected
    }
    
    private func showError(_ errorMessage: String) {
        errorState.errorMessage = errorMessage
        errorState.showError = true
    }
    
    func createChannel(_ channelName: String?) -> Result<ChannelItem, Error> {
        guard !selectedChatPartners.isEmpty else { return .failure(ChannelCreationError.noChatPartner) }
        
        guard
            let channelId = FirebaseConstants.ChannelsRef.childByAutoId().key,
            let currentUid = Auth.auth().currentUser?.uid
            //let messageId = FirebaseConstants.MessagesRef.childByAutoId().key
        else { return .failure(ChannelCreationError.failedToCreateUniqueIds) }
        
        let timeStamp = Date().timeIntervalSince1970
        var membersUids = selectedChatPartners.compactMap { $0.uid }
        membersUids.append(currentUid)
        
        var channelDict: [String: Any] = [
            .id: channelId,
            .lastMessage: "",
            .creationDate: timeStamp,
            .lastMessageTimeStamp: timeStamp,
            .membersUids: membersUids,
            .membersCount: membersUids.count,
            .adminUids: [currentUid]
        ]
        
        if let channelName = channelName, !channelName.isEmptyOrWhiteSpace {
            channelDict[.name] = channelName
        }
        
        FirebaseConstants.ChannelsRef.child(channelId).setValue(channelDict)
        
        membersUids.forEach { userId in
            /// keeping an index of the channel that a specific user belongs to
            FirebaseConstants.UserChannelsRef.child(userId).child(channelId).setValue(true)
        }
        
        /// Makes sure that a direct channel is unique
        if isDirectChannel {
            let chatPartner = selectedChatPartners[0]
            FirebaseConstants.UserDirectChannels.child(currentUid).child(chatPartner.uid).setValue([channelId: true])
            FirebaseConstants.UserDirectChannels.child(chatPartner.uid).child(currentUid).setValue([channelId: true])
        }
        
        var newChannelItem = ChannelItem(channelDict)
        newChannelItem.members = selectedChatPartners
        return .success(newChannelItem)
        
    }
}
