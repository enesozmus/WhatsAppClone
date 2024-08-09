//
//  BubbleText.swift
//  WhatsAppClone
//
//  Created by enesozmus on 31.07.2024.
//

import SwiftUI


// MARK: View
struct BubbleText: View {
    
    // MARK: Properties
    let item: MessageItem
    
    var body: some View {
        VStack(alignment: item.horizontalAlignment, spacing: 3) {
            Text(item.text)
                .padding(10)
                .background(item.backgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .applyTail(item.direction)
            
            timeStampTextView()
        }
        .shadow(color: Color(.systemGray3).opacity(0.1), radius: 5, x: 0, y: 20)
        .frame(maxWidth: .infinity, alignment: item.alignment)
        .padding(.leading, item.direction == .received ? 5 : 100)
        .padding(.trailing, item.direction == .received ? 100 : 5)
    }
    
    // MARK: Func
    private func timeStampTextView() -> some View {
        HStack {
            
            Text(item.timeStamp.formatToTime)
                .font(.system(size: 13))
                .foregroundStyle(.gray)
            
            if item.direction == .sent {
                Image(.seen)
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 15, height: 15)
                    .foregroundStyle(Color(.systemBlue))
            }
        }
    }
}


// MARK: Preview
#Preview {
    ScrollView {
        BubbleText(item: .sentPlaceholder)
        BubbleText(item: .receivedPlaceholder)
    }
    .frame(maxWidth: .infinity)
    .background(.gray.opacity(0.4))
}
