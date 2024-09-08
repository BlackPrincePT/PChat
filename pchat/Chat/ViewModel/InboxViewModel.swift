//
//  ChatViewModel.swift
//  pchat
//
//  Created by Petre Chkonia on 07.09.24.
//

import Combine
import FirebaseFirestore

@MainActor
class InboxViewModel: ObservableObject {
    @Published var chats: [Chat] = []
    private var db = Firestore.firestore()
    
    private var usernameCache = [String: String]()  // Cache for usernames
    
    // Fetch all chats for the current user
    func fetchChats() {
        guard let userID = UserService.shared.userAuth?.uid else { return }
        db.collection(K.Firebase.chats)
            .whereField(K.Firebase.participants, arrayContains: userID)
            .order(by: K.Firebase.lastMessageTimestamp, descending: true)
            .addSnapshotListener { (snapshot, error) in
                if let error = error {
                    print("Error fetching chats: \(error)")
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    print("No chats found")
                    return
                }
                
                self.chats = documents.compactMap { doc -> Chat? in
                    let chat = try? doc.data(as: Chat.self)
                    
                    chat?.participants.forEach { participantID in
                        self.fetchAndCacheUsername(for: participantID)
                    }
                    return chat
                }
            }
    }
    
    private func fetchAndCacheUsername(for userID: String) {
        if usernameCache[userID] != nil {
            return
        }
        Task {
            do {
                let document = try await db.collection(K.Firebase.users).document(userID).getDocument()
                
                if document.exists, let username = document.data()?[K.Firebase.username] as? String {
                    self.usernameCache[userID] = username
                } else {
                    print("User not found")
                }
            }
            catch {
                print("Error fetching user: \(error.localizedDescription)")
            }
        }
    }
    
    func getCachedUsername(for userID: String) -> String? {
        return usernameCache[userID]
    }
    
    //MARK: - NewChatViewModel
    
    @Published var recipientEmail: String = ""
    
    func createNewChat(completion: @escaping () -> Void) {
        Task {
            do {
                guard let recipient = try await fetchUserByEmail(), let recipientID = recipient.id else { return }
                
                try uploadChatToFirestore(withRecipientID: recipientID)
                completion()
            }
            catch {
                print("Error creating new chat: \(error.localizedDescription)")
            }
        }
    }
    
    private func fetchUserByEmail() async throws -> User? {
        let querySnapshot = try await db.collection(K.Firebase.users).whereField(K.Firebase.email, isEqualTo: recipientEmail).getDocuments()
        
        return try querySnapshot.documents.first?.data(as: User.self)
    }
    
    private func uploadChatToFirestore(withRecipientID recipientID: String) throws {
        guard let currentUserID = UserService.shared.userAuth?.uid else { return }
        
        let participants: [String] = [currentUserID, recipientID]
        
        let chat = Chat(isGroup: false,
                        participants: participants,
                        lastMessage: "- New Contact -",
                        lastMessageTimestamp: Date())
        
        try db.collection(K.Firebase.chats).addDocument(from: chat)
    }
}
