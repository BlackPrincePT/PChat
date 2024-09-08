//
//  EditProfileView.swift
//  pchat
//
//  Created by Petre Chkonia on 07.09.24.
//

import SwiftUI
import PhotosUI

struct EditProfileView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @ObservedObject var userService = UserService.shared
    
    @FocusState private var isUsernameTextFieldFocused: Bool
    
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var image: Image? = Image(systemName: "photo.artframe")
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    HStack {
                        AsyncImage(url: userService.userData?.profileImageUrl) { phase in
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
                        
                        PhotosPicker("Change your profile picture", selection: $selectedPhoto, matching: .images)
                    }
                    
                    if let progress = viewModel.progress {
                        ProgressView(value: progress, total: 1) {
                            Text("Uploading...")
                        } currentValueLabel: {
                            Text(progress.formatted(.percent.precision(.fractionLength(0))))
                        }
                    }
                    
                    TextField("Enter your username", text: $viewModel.tempUsername)
                        .focused($isUsernameTextFieldFocused)
                        .autocapitalization(.words) // Capitalizes the first letter of each word
                        .autocorrectionDisabled(true) // Disables autocorrection
                    //TODO: Add limitations for Username
                }
                .task(id: selectedPhoto) {
                    viewModel.imageData = try? await selectedPhoto?.loadTransferable(type: Data.self)
                    if let imageData = viewModel.imageData, let uiImage = UIImage(data: imageData) {
                        image = Image(uiImage: uiImage)
                    }
                    
                    await viewModel.storeAvatar()
                }
                
                Section(header: Text("About")) {
                    Text("I believe in taking care of myself!")
                }
            }
        }
        .navigationBarBackButtonHidden(isUsernameTextFieldFocused)
        .toolbar {
            if isUsernameTextFieldFocused {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        isUsernameTextFieldFocused = false
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        viewModel.changeUsername()
                        
                        isUsernameTextFieldFocused = false
                    }
                }
            }
        }
    }
}

