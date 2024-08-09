//
//  AuthProvider.swift
//  WhatsAppClone
//
//  Created by enesozmus on 31.07.2024.
//

import Combine
import Foundation
import FirebaseAuth
import FirebaseDatabase


enum AuthState {
    case pending, loggedIn(UserItem), loggedOut
}


protocol AuthProvider {
    static var shared: AuthProvider { get }
    var authState: CurrentValueSubject<AuthState, Never> { get }
    func autoLogin() async
    func login(with email: String, and password: String) async throws
    func createAccount(for username: String, with email: String, and password: String) async throws
    func logOut() async throws
}


enum AuthError: Error {
    case accountCreationFailed(_ description: String)
    case failedToSaveUserInfo(_ description: String)
    case emailLoginFailed(_ description: String)
}

extension AuthError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .accountCreationFailed(let description):
            return description
        case .failedToSaveUserInfo(let description):
            return description
        case .emailLoginFailed(let description):
            return description
        }
    }
}


final class AuthManager: AuthProvider {
    
    private init() {
        Task { await autoLogin() }
    }
    
    static let shared: AuthProvider = AuthManager()
    
    var authState = CurrentValueSubject<AuthState, Never>(.pending)
    
    func autoLogin() async {
        if Auth.auth().currentUser == nil {
            authState.send(.loggedOut)
        } else {
            fetchCurrentUserInfo()
        }
    }
    
    func login(with email: String, and password: String) async throws {
        do {
            let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
            fetchCurrentUserInfo()
            print("🔐 Successfully Signed In \(authResult.user.email ?? "") ")
        } catch {
            print("🔐 Failed to Sign Into the Account with: \(email)")
            throw AuthError.emailLoginFailed(error.localizedDescription)
        }
    }
    
    func createAccount(for username: String, with email: String, and password: String) async throws {
        do {
            let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
            let uid = authResult.user.uid
            let newUser = UserItem(uid: uid, username: username, email: email)
            try await saveUserInfoDatabase(user: newUser)
            self.authState.send(.loggedIn(newUser))
        } catch {
            print("🔐 Failed to Create an Account: \(error.localizedDescription)")
            throw AuthError.accountCreationFailed(error.localizedDescription)
        }
    }
    
    func logOut() async throws {
        do {
            try Auth.auth().signOut()
            authState.send(.loggedOut)
            print("🔐 Successfully logged out!")
        } catch {
            print("🔐 Failed to logOut current User: \(error.localizedDescription)")
        }
    }
}


extension AuthManager {
    
    private func saveUserInfoDatabase(user: UserItem) async throws {
        do {
            let userDictionary: [String: Any] = [.uid : user.uid, .username : user.username, .email : user.email]
            try await FirebaseConstants.UserRef.child(user.uid).setValue(userDictionary)
        } catch {
            print("🔐 Failed to Save Created user Info to Database: \(error.localizedDescription)")
            throw AuthError.failedToSaveUserInfo(error.localizedDescription)
        }
    }
    
    private func fetchCurrentUserInfo() {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        FirebaseConstants.UserRef.child(currentUid).observe(.value) { [weak self] snapshot in
            guard let userDict = snapshot.value as? [String: Any] else { return }
            let loggedInUser = UserItem(dictionary: userDict)
            self?.authState.send(.loggedIn(loggedInUser))
            print("🔐 \(loggedInUser.username) is logged in")
        } withCancel: { error in
            print("Failed to get current user info")
        }
    }
    
    static let testAccounts: [String] = [
        "dummyUser1@test.com",
        "dummyUser2@test.com",
        "dummyUser3@test.com",
        "dummyUser4@test.com",
        "dummyUser5@test.com",
        "dummyUser6@test.com",
        "dummyUser7@test.com",
        "dummyUser8@test.com",
        "dummyUser9@test.com",
        "dummyUser10@test.com",
        "dummyUser11@test.com",
        "dummyUser12@test.com",
        "dummyUser13@test.com",
        "dummyUser14@test.com",
        "dummyUser15@test.com",
    ]
}
