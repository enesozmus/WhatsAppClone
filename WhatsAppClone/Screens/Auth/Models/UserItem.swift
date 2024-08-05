//
//  UserItem.swift
//  WhatsAppClone
//
//  Created by enesozmus on 1.08.2024.
//

import Foundation

struct UserItem: Identifiable, Hashable, Decodable {
    let uid: String
    let username: String
    let email: String
    var bio: String? = nil
    var profileImageUrl: String? = nil
    
    var id: String {
        return uid
    }
    
    var bioUnwrapped: String {
        return bio ?? "Hey there! I am using WhatsApp."
    }
    
    static let placeholder = UserItem(uid: "1", username: "enesozmus", email: "testt@gmail.com")
    
    static let placeholders: [UserItem] = [
        UserItem(uid: "2", username: "JohnDoe", email: "johndoe@example.com", bio: "Hello, I'm John."),
        UserItem(uid: "3", username: "JaneSmith", email: "janesmith@example.com", bio: "Passionate about coding."),
        UserItem(uid: "4", username: "Alice", email: "alice@gmail.com", bio: "Tech enthusiast."),
        UserItem(uid: "5", username: "Bob", email: "bob@example.com", bio: "Lover of nature."),
        UserItem(uid: "6", username: "Ella", email: "ella@hotmail.com", bio: "Dreamer."),
        UserItem(uid: "7", username: "Michael", email: "michael@gmail.com"),
        UserItem(uid: "8", username: "Sophie", email: "sophie@example.com", bio: "Coffee addict ☕️"),
        UserItem(uid: "9", username: "David", email: "david@example.com", bio: "Music lover."),
        UserItem(uid: "10", username: "Emily", email: "emily@yahoo.com", bio: "Travel enthusiast."),
        UserItem(uid: "11", username: "Meloni", email: "meloni@example.com", bio: "Hello, I'm Meloni."),
        UserItem(uid: "12", username: "JackSp", email: "jacksp@example.com", bio: "Passionate about piracy."),
        UserItem(uid: "13", username: "Will", email: "willturner@example.com", bio: "Hello, I'm Will."),
        UserItem(uid: "14", username: "Samuel", email: "samuell@example.com", bio: "Hello, I'm Samuel.")
    ]
}

extension UserItem {
    init(dictionary: [String: Any]) {
        self.uid = dictionary[.uid] as? String ?? ""
        self.username = dictionary[.username] as? String ?? ""
        self.email = dictionary[.email] as? String ?? ""
        self.bio = dictionary[.bio] as? String? ?? nil
        self.profileImageUrl = dictionary[.profileImageUrl] as? String? ?? nil
    }
}

extension String {
    static let uid = "uid"
    static let username = "username"
    static let email = "email"
    static let bio = "bio"
    static let profileImageUrl = "profileImageUrl"
}
