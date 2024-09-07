//
//  ChatListViewCell.swift
//  pchat
//
//  Created by Petre Chkonia on 07.09.24.
//

import SwiftUI

struct InboxViewCell: View {
    let name: String
    let lastMessage: String
    let date: Date
    
    let avatarURL: URL?
    
    var body: some View {
        HStack {
            AsyncImage(url: avatarURL) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                } else if phase.error != nil {
                    Color.red.opacity(0.2)
                } else {
                    Color.black.opacity(0.2)
                        .overlay {
                            Image(systemName: "person.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 20)
                        }
                }
            }
            .aspectRatio(contentMode: .fill)
            .frame(width: 50, height: 50)
            .clipShape(Circle())
            
            VStack(alignment: .leading) {
                Text(name).font(.headline).lineLimit(1)
                Text(lastMessage).font(.subheadline).foregroundColor(.gray).lineLimit(1)
            }
            Spacer()
            Text(date, style: .time).font(.caption).foregroundColor(.gray)
        }
        .padding(.vertical, 8)
    }
}

