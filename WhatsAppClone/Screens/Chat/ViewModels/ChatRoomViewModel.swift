//
//  ChatRoomViewModel.swift
//  WhatsAppClone
//
//  Created by enesozmus on 7.08.2024.
//

import Combine
import Foundation
import PhotosUI
import SwiftUI

@MainActor
final class ChatRoomViewModel: ObservableObject {
    
    // MARK: Properties
    @Published var textMessage: String = ""
    @Published var messages = [MessageItem]()
    
    @Published var showPhotoPicker: Bool = false
    @Published var photoPickerItems: [PhotosPickerItem] = []
    @Published var mediaAttachments: [MediaAttachment] = []
    @Published var videoPlayerState: (show: Bool, player: AVPlayer?) = (false, nil)
    
    @Published var isRecodingVoiceMessage: Bool = false
    @Published var elapsedVoiceMessageTime: TimeInterval = 0
    
    @Published var scrollToBottomRequest: (scroll: Bool, isAnimate: Bool) = (false, false)
    
    private(set) var channel: ChannelItem
    private var subscriptions = Set<AnyCancellable>()
    private var currentUser: UserItem?
    
    private let voiceRecorderService = VoiceRecorderService()
    
    var showPhotoPickerPreview: Bool {
        return !mediaAttachments.isEmpty || !photoPickerItems.isEmpty
    }
    
    var disableSendButton: Bool {
        return mediaAttachments.isEmpty && textMessage.isEmptyOrWhiteSpace
    }
    
    // MARK: Init
    init(_ channel: ChannelItem) {
        self.channel = channel
        listenToAuthState()
        onPhotoPickerSelection()
        setUpVoiceRecorderListeners()
    }
    
    // MARK: Deinit
    deinit {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
        currentUser = nil
        voiceRecorderService.tearDown()
    }
    
    // MARK: Methods
    func sendMessage() {
        if mediaAttachments.isEmpty {
            sendTextMessage(textMessage)
        } else {
            sendMultipleMediaMessages(textMessage, attachments: mediaAttachments)
            clearInputArea()
        }
    }
    
    private func sendTextMessage(_ text: String) {
        guard let currentUser else { return }
        MessageService.sendTextMessages(to: channel, from: currentUser, text) { [weak self] in
            self?.textMessage = ""
        }
    }
    
    private func sendMultipleMediaMessages(_ text: String, attachments: [MediaAttachment]) {
        for (index, attachment) in attachments.enumerated() {
            let textMessage = index == 0 ? text : ""
            
            switch attachment.type {
            case .photo:
                sendPhotoMessage(text: textMessage, attachment)
            case .video:
                break
            case .audio:
                break
            }
        }
    }
    
    func clearInputArea() {
        textMessage = ""
        mediaAttachments.removeAll()
        photoPickerItems.removeAll()
        UIApplication.dismissKeyboard()
    }
    
    private func sendPhotoMessage(text: String, _ attachment: MediaAttachment) {
        /// Upload the image to storage bucket
        uploadImageToStorage(attachment) { [weak self] imageURL in
            /// Store the metadata to our database
            guard let self = self, let currentUser else { return }
            
            let uploadParams = MessageUploadParams(
                channel: channel,
                text: text,
                type: .photo,
                attachment: attachment,
                thumbnailURL: imageURL.absoluteString,
                sender: currentUser
            )
            
            /// Upload photos to Database
            MessageService.sendMediaMessage(to: channel, params: uploadParams) { [weak self] in
                /// Scroll to bottom upon image upload success
                self?.scrollToBottom(isAnimated: true)
            }
        }
    }
    
    private func scrollToBottom(isAnimated: Bool) {
        scrollToBottomRequest.scroll = true
        scrollToBottomRequest.isAnimate = isAnimated
    }
    
    ///
    /// UPLOAD IMAGE
    ///
    ///
    private func uploadImageToStorage(_ attachment: MediaAttachment, completion: @escaping(_ imageURL: URL) -> Void) {
        FirebaseHelper.uploadImage(attachment.thumbnail, for: .photoMessage) { result in
            switch result {
            case .success(let imageURL):
                completion(imageURL)
            case .failure(let error):
                print("Failed to upload Image to Storage: \(error.localizedDescription)")
            }
        } progressHandler: { progress in
            print("UPLOAD IMAGE PROGRESS: \(progress)")
        }
    }
    
    func handleTextInputArea(_ action: TextInputArea.UserAction) {
        switch action {
        case .presentPhotoPicker:
            showPhotoPicker = true
        case .sendMessage:
            sendMessage()
        case .recordAudio:
            toggleAudioRecorder()
        }
    }
    
    func dismissMediaPlayer() {
        videoPlayerState.player?.replaceCurrentItem(with: nil)
        videoPlayerState.player = nil
        videoPlayerState.show = false
    }
    
    func showMediaPlayer(_ fileURL: URL) {
        videoPlayerState.show = true
        videoPlayerState.player = AVPlayer(url: fileURL)
    }
    
    func handleMediaAttachmentPreview(_ action: MediaAttachmentPreview.UserAction) {
        switch action {
        case .play(let attachment):
            guard let fileURL = attachment.fileURL else { return }
            showMediaPlayer(fileURL)
        case .remove(let attachment):
            remove(attachment)
            guard let fileURL = attachment.fileURL else { return }
            if attachment.type == .audio(.stubURL, .stubTimeInterval) {
                voiceRecorderService.deleteRecording(at: fileURL)
            }
        }
    }
    
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
    
    private func setUpVoiceRecorderListeners() {
        voiceRecorderService.$isRecording.receive(on: DispatchQueue.main)
            .sink { [weak self] isRecording in
                self?.isRecodingVoiceMessage = isRecording
            }.store(in: &subscriptions)
        
        
        voiceRecorderService.$elaspedTime.receive(on: DispatchQueue.main)
            .sink { [weak self] elapsedTime in
                self?.elapsedVoiceMessageTime = elapsedTime
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
    
    private func toggleAudioRecorder() {
        if voiceRecorderService.isRecording {
            // stop recording
            voiceRecorderService.stopRecording { [weak self] audioURL, audioDuration in
                self?.createAudioAttachment(from: audioURL, audioDuration)
            }
        } else {
            voiceRecorderService.startRecording()
        }
    }
    
    private func createAudioAttachment(from audioURL: URL?, _ audioDuration: TimeInterval) {
        guard let audioURL = audioURL else { return }
        let id = UUID().uuidString
        let audioAttachment = MediaAttachment(id: id, type: .audio(audioURL, audioDuration))
        mediaAttachments.insert(audioAttachment, at: 0)
    }
    
    private func onPhotoPickerSelection() {
        $photoPickerItems.sink { [weak self] photoItems in
            guard let self = self else { return }
            //self.mediaAttachments.removeAll()
            let audioRecordings = mediaAttachments.filter({ $0.type == .audio(.stubURL, .stubTimeInterval) })
            self.mediaAttachments = audioRecordings
            Task { await self.parsePhotoPickerItems(photoItems) }
        }.store(in: &subscriptions)
    }
    
    private func parsePhotoPickerItems(_ photoPickerItems: [PhotosPickerItem]) async {
        for photoItem in photoPickerItems {
            if photoItem.isVideo {
                if let movie = try? await photoItem.loadTransferable(type: VideoPickerTransferable.self), let thumbnailImage = try? await movie.url.generateVideoThumbnail(), let itemIdentifier = photoItem.itemIdentifier {
                    let videoAttachment = MediaAttachment(id: itemIdentifier, type: .video(thumbnailImage, movie.url))
                    self.mediaAttachments.insert(videoAttachment, at: 0)
                }
            } else {
                guard
                    let data = try? await photoItem.loadTransferable(type: Data.self),
                    let thumbnail = UIImage(data: data),
                    let itemIdentifier = photoItem.itemIdentifier
                else { return }
                let photoAttachment = MediaAttachment(id: itemIdentifier, type: .photo(thumbnail))
                self.mediaAttachments.insert(photoAttachment, at: 0)
            }
        }
    }
    
    private func remove(_ item: MediaAttachment) {
        guard let attachmentIndex = mediaAttachments.firstIndex(where: { $0.id == item.id }) else { return }
        mediaAttachments.remove(at: attachmentIndex)
        
        guard let photoIndex = photoPickerItems.firstIndex(where: { $0.itemIdentifier == item.id }) else { return }
        photoPickerItems.remove(at: photoIndex)
    }
}
