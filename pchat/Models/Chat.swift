//
//  Chat.swift
//  pchat
//
//  Created by Petre Chkonia on 08.09.24.
//

import FirebaseFirestore

struct Chat: Identifiable, Codable {
    @DocumentID var id: String?
    var isGroup: Bool
    var title: String?
    var participants: [String]
    var lastMessage: String
    var lastMessageTimestamp: Date
}

