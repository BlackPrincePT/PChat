//
//  SettingsViewModel.swift
//  pchat
//
//  Created by Petre Chkonia on 07.09.24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseStorage

@MainActor
class SettingsViewModel: ObservableObject {
    @Published var imageData: Data?
    @Published var progress: Double?
    
    @Published var tempUsername: String = ""
    
    private let db = Firestore.firestore()
    
    init() {
        tempUsername = UserService.shared.userData?.username ?? ""
    }
    
    func storeAvatar() async {
        guard let userID = UserService.shared.userData?.id else { return }
        let imageReference = Storage.storage().reference(withPath: "avatars/\(userID).png")
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/png"
        
        guard let imageData else { return }
        
        do {
            let resultMetadata = try await imageReference.putDataAsync(imageData, metadata: metadata) { progress in
                if let progress {
                    self.progress = progress.fractionCompleted
                    if progress.isFinished {
                        self.progress = nil
                    }
                }
            }
            print("Upload finished. Metadata: \(resultMetadata)")
            UserService.shared.userData?.profileImageUrl = try await imageReference.downloadURL()
            UserService.shared.updateUserData()
        }
        catch {
            print("An error occured while uploading: \(error.localizedDescription)")
        }
    }
    
    func loadAvatar() {
        guard let userID = UserService.shared.userData?.id else { return }
        
        Task {
            let imageReference = Storage.storage().reference(withPath: "avatars/\(userID).png")
            
            do {
                imageData = try await imageReference.data(maxSize: 4 * 1024 * 1024)
            }
            catch {
                print("Error while downloading image: \(error.localizedDescription)")
            }
        }
    }
    
    func changeUsername() {
        guard let currentUserID = UserService.shared.userData?.id else { return }
        
        db.collection(K.Firebase.users).document(currentUserID).setData([K.Firebase.username: tempUsername], merge: true)
        
    }
    
}

