//
//  SettingsView.swift
//  pchat
//
//  Created by Petre Chkonia on 07.09.24.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var authViewModel: AuthViewModel
    @StateObject private var viewModel = SettingsViewModel()
    @ObservedObject private var userService = UserService.shared
    
    @State private var image: Image? = Image(systemName: "photo.artframe")
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    NavigationLink(destination: EditProfileView()) {
                        HStack {
                            AsyncImage(url: userService.userData?.avatarURL) { phase in
                                if let image = phase.image {
                                    image
                                        .resizable()
                                } else if phase.error != nil {
                                    Color.red.opacity(0.2)
                                } else {
                                    Color.black.opacity(0.2)
                                }
                            }
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 64, height: 64)
                            .clipShape(Circle())
                            
                            Text(userService.userData?.username ?? "Unknown")
                        }
                    }
                    
                    NavigationLink(destination: EditAccountView().environmentObject(viewModel)) {
                        HStack {
                            Image(systemName: "key")
                            Text("Account")
                        }
                    }
                }
                
                Section {
                    Button {
                        authViewModel.signOut()
                    } label: {
                        Text("Log out")
                            .foregroundStyle(.red)
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

