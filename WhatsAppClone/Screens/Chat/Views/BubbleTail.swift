//
//  BubbleTail.swift
//  WhatsAppClone
//
//  Created by enesozmus on 31.07.2024.
//

import SwiftUI


// MARK: View
struct BubbleTail: View {
    
    // MARK: Properties
    let direction: MessageDirection
    private var backgroundColor: Color {
        return direction == .received ? .bubbleWhite : .bubbleGreen
    }
    
    var body: some View {
        Image(direction == .sent ? .outgoingTail : .incomingTail)
            .renderingMode(.template)
            .resizable()
            .frame(width: 10, height: 10)
            .offset(y: 3)
            .foregroundStyle(backgroundColor)
    }
}


// MARK: Preview
#Preview {
    ScrollView {
        BubbleTail(direction: .sent)
        BubbleTail(direction: .received)
    }
    .frame(maxWidth: .infinity)
    .background(.gray.opacity(0.1))
}
