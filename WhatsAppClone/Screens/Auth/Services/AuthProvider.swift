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
        "enesozmus1@test.com",
        "enesozmus2@test.com",
        "enesozmus3@test.com",
        "enesozmus4@test.com",
        "enesozmus5@test.com",
        "enesozmus6@test.com",
        "enesozmus7@test.com",
        "enesozmus8@test.com",
        "enesozmus9@test.com",
        "enesozmus10@test.com",
        "enesozmus11@test.com",
        "enesozmus12@test.com",
        "enesozmus13@test.com",
        "enesozmus14@test.com",
        "enesozmus15@test.com",
        "enesozmus16@test.com",
        "enesozmus17@test.com",
        "enesozmus18@test.com",
        "enesozmus19@test.com",
        "enesozmus20@test.com",
        "enesozmus21@test.com",
        "enesozmus22@test.com",
        "enesozmus23@test.com",
        "enesozmus24@test.com",
        "enesozmus25@test.com",
        "enesozmus26@test.com",
        "enesozmus27@test.com",
        "enesozmus28@test.com",
        "enesozmus29@test.com",
        "enesozmus30@test.com",
        "enesozmus31@test.com",
        "enesozmus32@test.com",
        "enesozmus33@test.com",
        "enesozmus34@test.com",
        "enesozmus35@test.com",
        "enesozmus36@test.com",
        "enesozmus37@test.com",
        "enesozmus38@test.com",
        "enesozmus39@test.com",
        "enesozmus40@test.com",
        "enesozmus41@test.com",
        "enesozmus42@test.com",
        "enesozmus43@test.com",
        "enesozmus44@test.com",
        "enesozmus45@test.com",
        "enesozmus46@test.com",
        "enesozmus47@test.com",
        "enesozmus48@test.com",
        "enesozmus49@test.com",
        "enesozmus50@test.com"
    ]
}
