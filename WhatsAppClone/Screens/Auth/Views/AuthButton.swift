//
//  AuthButton.swift
//  WhatsAppClone
//
//  Created by enesozmus on 31.07.2024.
//

import SwiftUI


// MARK: View
struct AuthButton: View {
    
    // MARK: Properties
    let title: String
    let onTap: () -> Void
    @Environment(\.isEnabled) private var isEnabled
    
    private var backgroundColor: Color {
        return isEnabled ? Color.white : Color.white.opacity(0.3)
    }
    
    private var textColor: Color {
        return isEnabled ? Color.green : Color.white
    }
    
    var body: some View {
        Button {
            onTap()
        } label: {
            HStack {
                Text(title)
                Image(systemName: "arrow.right")
            }
            .font(.headline)
            .foregroundStyle(textColor)
            .padding()
            .frame(maxWidth: .infinity)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .shadow(color: .green.opacity(0.2), radius: 10)
            .padding(.horizontal, 32)
        }
    }
}


// MARK: Preview
#Preview {
    ZStack {
        Color.teal
        AuthButton(title: "Login") {
            //
        }
    }
}
