//
//  Contact.swift
//  pchat
//
//  Created by Petre Chkonia on 07.09.24.
//

import FirebaseFirestore

struct Contact: Identifiable {
    @DocumentID var id: String?
    let uid: String
    let username: String
}
