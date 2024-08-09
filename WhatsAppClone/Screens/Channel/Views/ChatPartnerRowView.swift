//
//  ChatPartnerRowView.swift
//  WhatsAppClone
//
//  Created by enesozmus on 3.08.2024.
//

import SwiftUI


// MARK: View
struct ChatPartnerRowView<Content: View>: View {
    
    // MARK: Properties
    private let user: UserItem
    private let trailingItems: Content
    
    // MARK: Init
    init(user: UserItem, @ViewBuilder trailingItems: () -> Content = { EmptyView() }) {
        self.user = user
        self.trailingItems = trailingItems()
    }
    
    var body: some View {
        HStack {
            CircularProfileImageView(user.profileImageUrl, size: .xSmall)
            
            VStack(alignment: .leading) {
                Text(user.username)
                    .bold()
                    .foregroundStyle(.whatsAppBlack)
                
                Text(user.bioUnwrapped)
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
            
            trailingItems
        }
    }
}


// MARK: Preview
#Preview {
    ChatPartnerRowView(user: .placeholder)
}
