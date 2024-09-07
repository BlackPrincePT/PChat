//
//  AuthView.swift
//  pchat
//
//  Created by Petre Chkonia on 07.09.24.
//

import SwiftUI

struct AuthView<Content, Unauthenticated>: View where Content: View, Unauthenticated: View {
    @StateObject private var viewModel = AuthViewModel()
    @State private var presentingLoginScreen = false
    
    var unauthenticated: Unauthenticated?
    @ViewBuilder var content: () -> Content
    
    public init(@ViewBuilder unauthenticated: @escaping () -> Unauthenticated, @ViewBuilder content: @escaping () -> Content) {
      self.unauthenticated = unauthenticated()
      self.content = content
    }
    
    var body: some View {
        switch viewModel.authenticationState {
        case .unauthenticated, .authenticating:
            VStack {
                if let unauthenticated = unauthenticated {
                    unauthenticated
                } else {
                    Text("You're not logged in.")
                }
                Button("Tap here to log in") {
                    viewModel.reset()
                    presentingLoginScreen.toggle()
                }
            }
            .sheet(isPresented: $presentingLoginScreen) {
                switch viewModel.flow {
                case .login:
                    LoginView()
                        .environmentObject(viewModel)
                case .signUp:
                    SignUpView()
                        .environmentObject(viewModel)
                }
            }
        case .authenticated:
            VStack {
                content()
                    .environmentObject(viewModel)
            }
        }
    }
}

