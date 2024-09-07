//
//  User.swift
//  pchat
//
//  Created by Petre Chkonia on 07.09.24.
//

import FirebaseFirestore

struct User: Identifiable, Codable {
    @DocumentID var id: String?
    var username: String
    var email: String
    
    var avatarURL: URL?
}
