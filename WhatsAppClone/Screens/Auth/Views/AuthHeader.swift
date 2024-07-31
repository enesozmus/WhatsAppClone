//
//  AuthHeader.swift
//  WhatsAppClone
//
//  Created by enesozmus on 31.07.2024.
//

import SwiftUI


// MARK: View
struct AuthHeader: View {
    var body: some View {
        HStack {
            Image(.whatsapp)
                .resizable()
                .frame(width: 40, height: 40)
            
            Text("WhatsApp")
                .font(.largeTitle)
                .foregroundStyle(.white)
                .fontWeight(.semibold)
        }
    }
}


// MARK: Preview
#Preview {
    AuthHeader()
}
