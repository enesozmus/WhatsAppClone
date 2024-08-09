//
//  ChannelItemView.swift
//  WhatsAppClone
//
//  Created by enesozmus on 30.07.2024.
//

import SwiftUI


// MARK: View
struct ChannelItemView: View {
    
    // MARK: Properties
    let channel: ChannelItem
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            CircularProfileImageView(channel, size: .medium)
            
            VStack(alignment: .leading, spacing: 3) {
                titleTextView()
                lastMessagePreview()
            }
        }
    }
    
    private func titleTextView() -> some View {
        HStack {
            Text(channel.title)
                .lineLimit(1)
                .bold()
            
            Spacer()
            
            Text(channel.lastMessageTimeStamp.dayOrTimeRepresentation)
                .foregroundStyle(.gray)
                .font(.system(size: 15))
        }
    }
    
    private func lastMessagePreview() -> some View {
        Text(channel.lastMessage)
            .font(.system(size: 16))
            .lineLimit(2)
            .foregroundStyle(.gray)
    }
}


// MARK: Preview
#Preview {
    ChannelItemView(channel: .placeholder)
}
