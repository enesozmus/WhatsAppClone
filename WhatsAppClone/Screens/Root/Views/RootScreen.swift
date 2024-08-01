//
//  RootScreen.swift
//  WhatsAppClone
//
//  Created by enesozmus on 1.08.2024.
//

import SwiftUI


// MARK: View
struct RootScreen: View {
    
    // MARK: Properties
    @StateObject private var viewModel = RootScreenModel()
    
    var body: some View {
        switch viewModel.authState {
        case .pending:
            ProgressView()
                .controlSize(.large)
            
        case .loggedIn(let loggedInUser):
            MainTabView()
            
        case .loggedOut:
            LoginScreenView()
        }
    }
}


// MARK: Preview
#Preview {
    RootScreen()
}
