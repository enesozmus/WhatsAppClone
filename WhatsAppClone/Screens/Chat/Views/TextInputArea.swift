//
//  TextInputArea.swift
//  WhatsAppClone
//
//  Created by enesozmus on 30.07.2024.
//

import SwiftUI


// MARK: View
struct TextInputArea: View {
    
    // MARK: Properties
    @Binding var textMessage: String
    let onSendHandler:() -> Void
    
    private var disableSendButton: Bool {
        return textMessage.isEmptyOrWhiteSpace
    }
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 5) {
            imagePickerButton()
                .padding(3)
            
            audioRecorderButton()
            messageTextField()
            sendMessageButton()
                .disabled(disableSendButton)
                .grayscale(disableSendButton ? 0.8 : 0)
        }
        .padding(.bottom)
        .padding(.horizontal, 8)
        .padding(.top, 10)
        .background(.whatsAppWhite)
    }
}


// MARK: Extension
extension TextInputArea {
    private func messageTextField() -> some View {
        TextField("", text: $textMessage, axis: .vertical)
            .padding(5)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(.thinMaterial)
            )
            .overlay(textViewBorder())
    }
    
    private func textViewBorder() -> some View {
        RoundedRectangle(cornerRadius: 20, style: .continuous)
            .stroke(Color(.systemGray5), lineWidth: 1)
    }
    
    
    private func imagePickerButton() -> some View {
        Button {
            
        } label: {
            Image(systemName: "photo.on.rectangle")
                .font(.system(size: 22))
        }
    }
    
    private func audioRecorderButton() -> some View {
        Button {
            
        } label: {
            Image(systemName: "mic.fill")
                .fontWeight(.heavy)
                .imageScale(.small)
                .foregroundStyle(.white)
                .padding(6)
                .background(.blue)
                .clipShape(Circle())
                .padding(.horizontal, 3)
        }
    }
    
    private func sendMessageButton() -> some View {
        Button {
            onSendHandler()
        } label: {
            Image(systemName: "arrow.up")
                .fontWeight(.heavy)
                .foregroundStyle(.white)
                .padding(6)
                .background(.blue)
                .clipShape(Circle())
        }
    }
}


// MARK: Preview
#Preview {
    TextInputArea(textMessage: .constant("")) {
        
    }
}
