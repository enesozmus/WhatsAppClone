//
//  RootScreenModel.swift
//  WhatsAppClone
//
//  Created by enesozmus on 1.08.2024.
//

import Combine
import Foundation

final class RootScreenModel: ObservableObject {
    
    @Published private(set) var authState = AuthState.pending
    private var cancallable: AnyCancellable?
    
    // MARK: Init
    init() {
        cancallable = AuthManager.shared.authState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] latestAuthState in
                self?.authState = latestAuthState
            }
        
        // MARK: Test 
        //        AuthManager.testAccounts.forEach { email in
        //            registerTestAccount(with: email)
        //        }
    }
    
    // MARK: Test
    //    private func registerTestAccount(with email: String) {
    //        Task {
    //            let username = email.replacingOccurrences(of: "@test.com", with: "")
    //            try? await AuthManager.shared.createAccount(for: username, with: email, and: "12345678")
    //        }
    //    }
}
