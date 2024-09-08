//
//  ChatView.swift
//  pchat
//
//  Created by Petre Chkonia on 08.09.24.
//

import SwiftUI

struct ChatView: View {
    @StateObject private var viewModel = ChatViewModel()
    let chat: Chat
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollViewReader { scrollViewProxy in
                ScrollView {
                    VStack(spacing: -8) {
                        ForEach(viewModel.messages) { message in
                            MessageBubble(message: message)
                                .id(message.id)
                        }
                    }
                    
                }
                .onChange(of: viewModel.messages.count) {
                    // Scroll to the bottom when a new message is added
                    if let lastMessageId = viewModel.messages.last?.id {
                        withAnimation {
                            scrollViewProxy.scrollTo(lastMessageId, anchor: .bottom)
                        }
                    }
                }
            }
            
            ChatBottomBar(messageText: $viewModel.messageText) {
                viewModel.sendMessage(to: chat)
            }
            
        }
        .onAppear {
            viewModel.fetchMessages(from: chat)
        }
        
        .background(Color.Custom.ChatBackground.white)
        
        .navigationTitle("Petre Chkonia")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(Color.Custom.Toolbar.white, for: .navigationBar)
    }
}
