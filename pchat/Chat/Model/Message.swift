//
//  Message.swift
//  pchat
//
//  Created by Petre Chkonia on 07.09.24.
//

import FirebaseFirestore

struct Message: Identifiable, Codable {
    @DocumentID var id: String?
    let content: String
    let senderID: String
    let timestamp: Date
}
