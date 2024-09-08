//
//  Message.swift
//  pchat
//
//  Created by Petre Chkonia on 08.09.24.
//

import FirebaseFirestore

struct Message: Identifiable, Codable {
    @DocumentID var id: String?
    var senderId: String
    var content: String
    var imageUrl: URL?
    var timestamp: Date
}

