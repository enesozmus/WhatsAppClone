//
//  ChatPartnerRowView.swift
//  WhatsAppClone
//
//  Created by enesozmus on 3.08.2024.
//

import SwiftUI


// MARK: View
struct ChatPartnerRowView: View {
    
    // MARK: Properties
    let user: UserItem
    
    var body: some View {
        HStack {
            Circle()
                .frame(width: 40, height: 40)
                .foregroundStyle(.red)
            
            VStack(alignment: .leading) {
                Text(user.username)
                    .bold()
                    .foregroundStyle(.whatsAppBlack)
                
                Text(user.bioUnwrapped)
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
        }
    }
}


// MARK: Preview
#Preview {
    ChatPartnerRowView(user: .placeholder)
}
