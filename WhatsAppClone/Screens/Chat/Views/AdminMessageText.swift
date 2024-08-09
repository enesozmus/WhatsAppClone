//
//  AdminMessageText.swift
//  WhatsAppClone
//
//  Created by enesozmus on 9.08.2024.
//

import SwiftUI


// MARK: View
struct AdminMessageText: View {
    
    // MARK: Properties
    let channel: ChannelItem
    
    var body: some View {
        
        VStack {
            if channel.isCreatedByMe {
                textView("You created this group. Tap to add\n members")
            } else {
                textView("\(channel.creatorName) created this group.")
                textView("\(channel.creatorName) added you")
            }
        }
    }
    
    private func textView(_ text: String) -> some View {
        Text(text)
            .multilineTextAlignment(.center)
            .font(.footnote)
            .padding(8)
            .padding(.horizontal, 5)
            .background(.bubbleWhite)
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            .shadow(color: Color(.systemGray3).opacity(0.1), radius: 5, x: 0, y: 20)
    }
}


// MARK: Preview
#Preview {
    ZStack {
        Color.gray.opacity(0.2)
        AdminMessageText(channel: .placeholder)
    }
    .ignoresSafeArea()
}
