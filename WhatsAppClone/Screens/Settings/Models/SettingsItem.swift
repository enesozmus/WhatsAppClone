//
//  SettingsItem.swift
//  WhatsAppClone
//
//  Created by enesozmus on 30.07.2024.
//

import Foundation
import SwiftUI

struct SettingsItem {
    let imageName: String
    var imageType: ImageType = .systemImage
    let backgroundColor: Color
    let title: String
    
    enum ImageType {
        case systemImage, assetImage
    }
}

// MARK: Settings Data
extension SettingsItem {
    static let avatar = SettingsItem(
        imageName: "photo",
        backgroundColor: .blue,
        title: "Change Profile Photo"
    )
    
    static let broadCastLists = SettingsItem(
        imageName: "megaphone.fill",
        backgroundColor: .green,
        title: "Broadcast Lists"
    )
    
    static let starredMessages = SettingsItem(
        imageName: "star.fill",
        backgroundColor: .yellow,
        title: "Starred Messages"
    )
    
    static let linkedDevices = SettingsItem(
        imageName: "laptopcomputer",
        backgroundColor: .green,
        title: "Linked Devices"
    )
    
    static let account = SettingsItem(
        imageName: "key.fill",
        backgroundColor: .blue,
        title: "Account"
    )
    
    static let privacy = SettingsItem(
        imageName: "lock.fill",
        backgroundColor: .cyan,
        title: "Privacy"
    )
    
    static let chats = SettingsItem(
        imageName: "whatsapp-black",
        imageType: .assetImage,
        backgroundColor: .green,
        title: "Chats"
    )
    
    static let notifications = SettingsItem(
        imageName: "bell.badge.fill",
        backgroundColor: .red,
        title: "Notifications"
    )
    
    static let storage = SettingsItem(
        imageName: "arrow.up.arrow.down",
        backgroundColor: .green,
        title: "Storage and Data"
    )
    
    static let help = SettingsItem(
        imageName: "info",
        backgroundColor: .blue,
        title: "Help"
    )
    
    static let tellFriend = SettingsItem(
        imageName: "heart.fill",
        backgroundColor: .red,
        title: "Tell a Friend"
    )
}

// MARK: Contact Info Data
extension SettingsItem {
    static let media = SettingsItem(
        imageName: "photo",
        backgroundColor: .blue,
        title: "Media, Links and Docs"
    )
    
    static let mute = SettingsItem(
        imageName: "speaker.wave.2.fill",
        backgroundColor: .green,
        title: "Mute"
    )
    
    static let wallpaper = SettingsItem(
        imageName: "circles.hexagongrid",
        backgroundColor: .mint,
        title: "Wallpaper & Sound"
    )
    
    static let saveToCameraRoll = SettingsItem(
        imageName: "square.and.arrow.down",
        backgroundColor: .yellow,
        title: "Save to Camera Roll"
    )
    
    static let encryption = SettingsItem(
        imageName: "lock.fill",
        backgroundColor: .blue,
        title: "Encryption"
    )
    
    static let disappearingMessages = SettingsItem(
        imageName: "timer",
        backgroundColor: .blue,
        title: "Disappearing Messages"
    )
    
    static let lockChat = SettingsItem(
        imageName: "lock.doc.fill",
        backgroundColor: .blue,
        title: "Lock Chat"
    )
    
    static let contactDetails = SettingsItem(
        imageName: "person.circle",
        backgroundColor: .gray,
        title: "Contact Details"
    )
}
