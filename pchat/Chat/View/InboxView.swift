//
//  ChatListViewModel.swift
//  pchat
//
//  Created by Petre Chkonia on 07.09.24.
//

import SwiftUI

struct InboxView: View {
    @StateObject private var viewModel = InboxViewModel()
    
    @State var showNewChatView: Bool = false
    
    var body: some View {
        NavigationView {
            List(viewModel.chats) { chat in
                NavigationLink(destination: ChatView(chat: chat)) { InboxViewCell(chat: chat).environmentObject(viewModel) }
            }
            .navigationTitle("Chats")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showNewChatView = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                }
            }
            .onAppear {
                viewModel.fetchChats()
            }
            .sheet(isPresented: $showNewChatView) {
                NewChatView()
                    .environmentObject(viewModel)
            }
        }
    }
}
