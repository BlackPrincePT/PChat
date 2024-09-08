//
//  User.swift
//  pchat
//
//  Created by Petre Chkonia on 08.09.24.
//

import FirebaseFirestore

struct User: Codable {
    @DocumentID var id: String?
    var username: String
    var email: String
    var profileImageUrl: URL?
    var status: Bool?
    var lastActive: Date
}

