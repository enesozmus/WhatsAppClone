//
//  WhatsAppCloneApp.swift
//  WhatsAppClone
//
//  Created by enesozmus on 29.07.2024.
//

import SwiftUI
import Firebase

/// We Need To Install The Following Firebase Dependencies:
/// FirebaseAuth
/// FirebaseDatabase
/// FirebaseDatabaseSwift
/// FirebaseMessaging
/// FirebaseStorage

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct WhatsAppCloneApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            LoginScreenView()
        }
    }
}
