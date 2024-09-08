//
//  ChatBottomBar.swift
//  pchat
//
//  Created by Petre Chkonia on 08.09.24.
//

import SwiftUI

struct ChatBottomBar: View {
    @Binding var messageText: String
    var sendMessage: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            Divider()
            HStack {
                Button {
                    // Action for plus button
                } label: {
                    Image(systemName: "plus")
                        .font(.title)
                }
                
                TextField("Text Message", text: $messageText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 8)
                
                Button {
                    sendMessage()
                } label: {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.title)
                }
            }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color.Custom.Toolbar.white)
        }
            
    }
}


