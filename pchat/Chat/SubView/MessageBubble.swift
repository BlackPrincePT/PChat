//
//  MessageBubble.swift
//  pchat
//
//  Created by Petre Chkonia on 08.09.24.
//

import SwiftUI
import FirebaseAuth

struct MessageBubble: View {
    @ObservedObject private var userService = UserService.shared
    
    let message: Message
    
    var body: some View {
        HStack {
            if message.senderId == userService.userAuth?.uid {
                Spacer()
            }
            VStack(alignment: .leading) {
                HStack(alignment: .bottom, spacing: 8) {
                    Text(message.content)
                        .foregroundColor(.black)
                    
                    Text(message.timestamp, style: .time)
                        .foregroundStyle(.gray)
                        .font(.caption)
                        .padding(.leading, 8)
                }
                .padding(8)
                .background(message.senderId == userService.userAuth?.uid ? Color.Custom.MessageBubble.blue : Color.Custom.MessageBubble.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            if message.senderId != userService.userAuth?.uid {
                Spacer()
            }
        }
        .padding(8)
    }
}


