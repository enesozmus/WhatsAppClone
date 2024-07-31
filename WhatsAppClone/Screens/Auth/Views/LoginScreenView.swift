//
//  LoginScreenView.swift
//  WhatsAppClone
//
//  Created by enesozmus on 31.07.2024.
//

import SwiftUI


// MARK: View
struct LoginScreenView: View {
    
    // MARK: Properties
    @StateObject private var authScreenModel = AuthScreenModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                AuthHeader()
                
                AuthTextField(type: .email, text: $authScreenModel.email)
                AuthTextField(type: .password, text: $authScreenModel.password)
                
                forgotPasswordButton()
                
                AuthButton(title: "Log in now") {
                    //
                }
                .disabled(authScreenModel.disableLoginButton)
                
                Spacer()
                
                signUpButton()
                    .padding(.bottom, 30)
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.teal.gradient)
            .ignoresSafeArea()
        }
    }
    
    // MARK: Func... Comp.
    private func forgotPasswordButton() -> some View {
        Button {
            
        } label: {
            Text("Forgot Password ?")
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing, 32)
                .bold()
                .padding(.vertical)
            
        }
    }
    
    private func signUpButton() -> some View {
        NavigationLink {
            SignUpScreenView(authScreenModel: authScreenModel)
        } label: {
            HStack {
                Image(systemName: "sparkles")
                
                (
                    Text("Don't have an account ? ")
                    +
                    Text("Create one").bold()
                )
                Image(systemName: "sparkles")
            }
            .foregroundStyle(.white)
        }
    }
}


// MARK: Preview
#Preview {
    LoginScreenView()
}
