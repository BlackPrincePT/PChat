//
//  AuthViewModel.swift
//  pchat
//
//  Created by Petre Chkonia on 07.09.24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

enum AuthenticationState {
    case unauthenticated
    case authenticating
    case authenticated
}

enum AuthenticationFlow {
    case login
    case signUp
}

@MainActor
class AuthViewModel: ObservableObject {
    @Published var authenticationState: AuthenticationState = .unauthenticated
    @Published var flow: AuthenticationFlow = .login
    
    @Published var userAuth: FirebaseAuth.User?
    
    @Published var isValid = false
    @Published var errorMessage = ""
    
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    
    init() {
        registerAuthStateHandler()
        
        $flow
            .combineLatest($email, $password, $confirmPassword)
            .map { flow, email, password, confimPassword in
                switch flow {
                case .login:
                    !(email.isEmpty || password.isEmpty)
                case .signUp:
                    !(email.isEmpty || password.isEmpty || confimPassword.isEmpty || password != confimPassword)
                }
            }
            .assign(to: &$isValid)
    }
    
    private var authStateHandler: AuthStateDidChangeListenerHandle?
    
    func registerAuthStateHandler() {
        if authStateHandler == nil {
            authStateHandler = Auth.auth().addStateDidChangeListener { auth, user in
                self.userAuth = user
                if user == nil {
                    self.authenticationState = .unauthenticated
                } else {
                    self.authenticationState = .authenticated
                    UserService.shared.userAuth = user
                    UserService.shared.removeSnapshotListener()
                    UserService.shared.registerSnapshotListener()
                }
            }
        }
    }
    
    func switchFlow() {
        flow = switch flow {
        case .login: .signUp
        case .signUp: .login
        }
        
        errorMessage = ""
    }
    
    func reset() {
        flow = .login
        
        email = ""
        password = ""
        confirmPassword = ""
    }
}

// MARK: - Email and Password Authentication

extension AuthViewModel {
    func signInWithEmailPassword() async -> Bool {
        authenticationState = .authenticating
        do {
            try await Auth.auth().signIn(withEmail: self.email, password: self.password)
            return true
        }
        catch {
            print(error)
            errorMessage = error.localizedDescription
            authenticationState = .unauthenticated
            return false
        }
    }
    
    func signUpWithEmailPassword() async -> Bool {
        authenticationState = .authenticating
        do {
            let result = try await Auth.auth().createUser(withEmail: self.email, password: self.password)
            try UserService.shared.uploadNewUserData(uid: result.user.uid, email: self.email)
            return true
        }
        catch {
            print(error)
            errorMessage = error.localizedDescription
            authenticationState = .unauthenticated
            return false
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        }
        catch {
            print(error)
            errorMessage = error.localizedDescription
        }
    }
    
    func deleteAccount() async -> Bool {
        do {
            try await userAuth?.delete()
            return true
        }
        catch {
            print(error)
            errorMessage = error.localizedDescription
            return false
        }
    }
}

