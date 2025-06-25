//
//  AuthView.swift
//  ChatGPTSwift
//
//  Created by Nupur Sharma on 25/06/25.
//

import SwiftUI

struct AuthView: View {
    
   @State var viewModel = AuthViewModel()
    @Environment(AppState.self) private var appState: AppState
    
    var body: some View {
        VStack {
            Text("ChatGPT App")
                .font(.title)
                .fontWeight(.bold)
            
            TextField("Email", text: $viewModel.emailText)
                .modifier(TextfieldModifier())
            if viewModel.isPasswordVisible {
                SecureField("Password", text: $viewModel.passwordText)
                    .modifier(TextfieldModifier())
            }
            
            if viewModel.isLoading {
                ProgressView()
            } else {
                Button {
                    viewModel.authenticate(appState: appState)
                } label: {
                    Text(viewModel.userExists ? "Login" : "Create User")
                }
                .padding()
                .foregroundStyle(.white)
                .background(Color.blue)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            }
            
        }
        .padding()
    }
}

#Preview {
    AuthView()
}

struct TextfieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(.gray.opacity(0.1))
            .textInputAutocapitalization(.never)
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
