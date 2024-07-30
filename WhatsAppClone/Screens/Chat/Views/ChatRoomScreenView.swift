//
//  ChatRoomScreenView.swift
//  WhatsAppClone
//
//  Created by enesozmus on 30.07.2024.
//

import SwiftUI

struct ChatRoomScreenView: View {
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(0..<12) { _ in
                    Text("PLACEHOLDER")
                        .font(.largeTitle)
                        .bold()
                        .frame(maxWidth: .infinity)
                        .frame(height: 200)
                        .background(.gray.opacity(0.1))
                }
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .toolbar {
            leadingNavItems()
            trailingNavItems()
        }
        .safeAreaInset(edge: .bottom) {
            TextInputArea()
        }
    }
}


// MARK: Extension... Toolbar Items
extension ChatRoomScreenView {
    @ToolbarContentBuilder
    private func leadingNavItems() -> some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            HStack {
                Circle()
                    .frame(width: 35, height: 30)
                    .foregroundStyle(.red)
                
                Text("enesozmus")
                    .bold()
            }
        }
    }
    
    @ToolbarContentBuilder
    private func trailingNavItems() -> some ToolbarContent {
        ToolbarItemGroup(placement: .topBarTrailing) {
            Button {
                
            } label: {
                Image(systemName: "video")
            }
            
            Button {
                
            } label: {
                Image(systemName: "phone")
            }
        }
    }
}


// MARK: Preview
#Preview {
    NavigationStack {
        ChatRoomScreenView()
    }
}
