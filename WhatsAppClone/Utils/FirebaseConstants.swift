//
//  FirebaseConstants.swift
//  WhatsAppClone
//
//  Created by enesozmus on 1.08.2024.
//

import Firebase
import FirebaseDatabase
import FirebaseStorage

enum FirebaseConstants {
    private static let DatabaseRef = Database.database().reference()
    static let UserRef = DatabaseRef.child("users")
}
