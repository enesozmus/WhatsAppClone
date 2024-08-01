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
    
    init() {
        cancallable = AuthManager.shared.authState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] latestAuthState in
                self?.authState = latestAuthState
            }
    }
}
