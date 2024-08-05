//
//  SelectedChatPartnerView.swift
//  WhatsAppClone
//
//  Created by enesozmus on 3.08.2024.
//

import SwiftUI


// MARK: View
struct SelectedChatPartnerView: View {
    
    // MARK: Properties
    let users: [UserItem]
    let onTapHandler: (_ user: UserItem) -> Void
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(users) { item in
                    chatPartnerView(item)
                }
            }
        }
    }
}


// MARK: Extension
extension SelectedChatPartnerView {
    private func chatPartnerView(_ user: UserItem) -> some View {
        VStack {
            Circle()
                .fill(.gray)
                .frame(width: 60, height: 60)
                .overlay(alignment: .topTrailing) {
                    cancelButton(user)
                }
            
            Text(user.username)
        }
    }
    
    private func cancelButton(_ user: UserItem) -> some View {
        Button {
            onTapHandler(user)
        } label: {
            Image(systemName: "xmark")
                .imageScale(.small)
                .foregroundStyle(.white)
                .fontWeight(.semibold)
                .padding(5)
                .background(Color(.systemGray2))
                .clipShape(Circle())
        }
    }
}


// MARK: Preview
#Preview {
    SelectedChatPartnerView(users: UserItem.placeholders) { user in
        
    }
}
