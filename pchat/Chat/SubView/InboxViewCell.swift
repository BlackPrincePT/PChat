//
//  ChatListViewCell.swift
//  pchat
//
//  Created by Petre Chkonia on 07.09.24.
//

import SwiftUI

struct InboxViewCell: View {
    @EnvironmentObject private var viewModel: InboxViewModel
    @ObservedObject private var userService = UserService.shared
    let chat: Chat
    
    var body: some View {
        HStack {
            AsyncImage(url: nil) { phase in // - Attention -
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
                Text(getChatTitle())
                    .font(.headline)
                    .lineLimit(1)
                
                Text(chat.lastMessage)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
            Spacer()
            Text(chat.lastMessageTimestamp, style: .time)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 8)
    }
    
    func getChatTitle() -> String {
        if chat.isGroup {
            return chat.title ?? "Group Chat"
        } else if let otherParticipantId = chat.participants.first(where: { $0 != userService.userAuth?.uid }) {
            return viewModel.getCachedUsername(for: otherParticipantId) ?? "Unknown User"
        }
        return "Unknown Chat"
    }

}

