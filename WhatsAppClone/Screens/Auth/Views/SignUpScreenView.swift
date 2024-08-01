//
//  SignUpScreenView.swift
//  WhatsAppClone
//
//  Created by enesozmus on 31.07.2024.
//

import SwiftUI


// MARK: View
struct SignUpScreenView: View {
    
    // MARK: Properties
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var authScreenModel: AuthScreenModel
    
    var body: some View {
        VStack {
            Spacer()
            
            AuthHeader()
            
            AuthTextField(type: .email, text: $authScreenModel.email)
            
            let usernameType = AuthTextField.InputType.custom("Username", "at")
            
            AuthTextField(type: usernameType, text: $authScreenModel.username)
            AuthTextField(type: .password, text: $authScreenModel.password)
            
            AuthButton(title: "Create an Account") {
                Task {
                    await authScreenModel.handleSignUp()
                }
            }
            .disabled(authScreenModel.disableSignUpButton)
            
            Spacer()
            
            backButton()
                .padding(.bottom, 30)
        }
        .frame(maxWidth: .infinity)
        .background {
            LinearGradient(colors: [.green, .green.opacity(0.8), .teal], startPoint: .top, endPoint: .bottom)
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden()
    }
    
    // MARK: Func... Comp.
    private func backButton() -> some View {
        Button {
            dismiss()
        } label: {
            HStack {
                Image(systemName: "sparkles")
                
                (
                    Text("Already created an account ? ")
                    +
                    Text("Log in").bold()
                )
                Image(systemName: "sparkles")
            }
            .foregroundStyle(.white)
        }
    }
}


// MARK: Preview
#Preview {
    SignUpScreenView(authScreenModel: AuthScreenModel())
}
