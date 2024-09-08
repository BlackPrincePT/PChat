//
//  ChatViewModel.swift
//  pchat
//
//  Created by Petre Chkonia on 08.09.24.
//

import FirebaseFirestore
import FirebaseAuth

@MainActor
class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var messageText: String = ""
    @Published var errorMessage: String?
    
    private let db = Firestore.firestore()
    
    func fetchMessages(from chat: Chat) {
        guard let chatId = chat.id else { return }
        
        db.collection(K.Firebase.chats)
            .document(chatId)
            .collection(K.Firebase.messages)
            .order(by: K.Firebase.timestamp)
            .addSnapshotListener { [weak self] (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    self?.errorMessage = "No documents in 'chats' collection"
                    return
                }
                self?.messages = documents.compactMap{ queryDocumentSnapshot in
                    let result = Result { try queryDocumentSnapshot.data(as: Message.self) }
                    
                    switch result {
                    case .success(let message):
                        self?.errorMessage = nil
                        return message
                    case .failure(let error):
                        // A Message value could not be initialized from the DocumentSnapshot.
                        switch error {
                        case DecodingError.typeMismatch(_, let context):
                            self?.errorMessage = "\(error.localizedDescription): \(context.debugDescription)"
                        case DecodingError.valueNotFound(_, let context):
                            self?.errorMessage = "\(error.localizedDescription): \(context.debugDescription)"
                        case DecodingError.keyNotFound(_, let context):
                            self?.errorMessage = "\(error.localizedDescription): \(context.debugDescription)"
                        case DecodingError.dataCorrupted(let key):
                            self?.errorMessage = "\(error.localizedDescription): \(key)"
                        default:
                            self?.errorMessage = "Error decoding document: \(error.localizedDescription)"
                        }
                        return nil
                    }
                }
            }
    }
    
    func sendMessage(to chat: Chat) {
        guard let chatID = chat.id, let userID = UserService.shared.userAuth?.uid else { return }
        let message = Message(senderId: userID, content: messageText, timestamp: Date())
        do {
            try db.collection(K.Firebase.chats)
                .document(chatID)
                .collection(K.Firebase.messages)
                .addDocument(from: message)
            
            db.collection(K.Firebase.chats)
                .document(chatID)
                .setData([K.Firebase.lastMessage: messageText,
                          K.Firebase.lastMessageTimestamp: message.timestamp
                         ], merge: true)
            
            messageText = ""
        } catch {
            print("DEBUG: Failed to send a message with error: \(error.localizedDescription)")
        }
    }
}

