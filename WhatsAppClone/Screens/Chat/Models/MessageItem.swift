//
//  MessageItem.swift
//  WhatsAppClone
//
//  Created by enesozmus on 31.07.2024.
//

import SwiftUI

struct MessageItem: Identifiable {
    let id = UUID().uuidString
    let text: String
    let type: MessageType
    let direction: MessageDirection
    
    static let sentPlaceholder = MessageItem(text: "Holy city!", type: .text, direction: .sent)
    static let receivedPlaceholder = MessageItem(text: "Hey Dude whats up ", type: .text, direction: .received)
    
    var alignment: Alignment {
        return direction == .received ? .leading : .trailing
    }
    
    var horizontalAlignment: HorizontalAlignment {
        return direction == .received ? .leading : .trailing
    }
    
    var backgroundColor: Color {
        return direction == .sent ? .bubbleGreen : .bubbleWhite
    }
    
    static let stubMessages: [MessageItem] = [
        MessageItem(text: "Hi There", type: .text, direction: .sent),
        MessageItem(text: "Check out this Photo", type: .photo, direction: .received),
        MessageItem(text: "Play out this Video", type: .video, direction: .sent)
    ]
}

enum MessageType {
    case text, photo, video
}

enum MessageDirection {
    case sent, received
    
    static var random: MessageDirection {
        return [MessageDirection.sent, .received].randomElement() ?? .sent
    }
}
