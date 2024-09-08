//
//  UserService.swift
//  pchat
//
//  Created by Petre Chkonia on 07.09.24.
//

import FirebaseAuth
import FirebaseFirestore

@MainActor
class UserService: ObservableObject {
    
    @Published var userAuth: FirebaseAuth.User?
    @Published var userData: User?
    
    static let shared = UserService()
    
    private let db = Firestore.firestore()
    
    private var listenerRegistration: ListenerRegistration?
    
    func registerSnapshotListener() {
        guard let documentID = userAuth?.uid else { return }
        
        if listenerRegistration == nil {
            db.collection(K.Firebase.users).document(documentID).addSnapshotListener { (querySnapshot, error) in
                if let error = error {
                    print("Failed to addSnapshotListener to 'userData' - with error: \(error.localizedDescription)")
                } else {
                    do {
                        self.userData = try querySnapshot?.data(as: User.self)
                    }
                    catch {
                        print("Failed to cast 'userData' query snapshot as 'User' - with error: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    func removeSnapshotListener() {
        if listenerRegistration != nil {
            listenerRegistration?.remove()
            listenerRegistration = nil
        }
    }
    
    func updateUserData() {
        guard let userDataID = userData?.id else { return }
        
        do {
            try db.collection(K.Firebase.users).document(userDataID).setData(from: userData)
        }
        catch {
            print("Error updating 'UserData': \(error.localizedDescription)")
        }
    }
    
    func uploadNewUserData(uid: String?, email: String) throws {
        guard let userId = uid else { return }
        
        let user = User(id: uid, username: "New User", email: email, profileImageUrl: nil, status: nil, lastActive: Date())
        
        try db.collection(K.Firebase.users).document(userId).setData(from: user)
    }
    
    func fetchUserData(by uid: String) async -> User? {
        do {
            let user = try await db.collection(K.Firebase.users).document(uid).getDocument(as: User.self)
            return user
        }
        catch {
            print("Error fetching 'UserData': \(error.localizedDescription)")
        }
        return nil
    }
}

