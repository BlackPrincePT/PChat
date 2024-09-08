//
//  NewChatView.swift
//  pchat
//
//  Created by Petre Chkonia on 08.09.24.
//

import SwiftUI

struct NewChatView: View {
    @EnvironmentObject private var viewModel: InboxViewModel
    @Environment(\.dismiss) var dismiss
    
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        NavigationView {
            Form {
                Section("Create a new chat") {
                    HStack {
                        Image(systemName: "at")
                        TextField("Email", text: $viewModel.recipientEmail)
                            .textInputAutocapitalization(.never)
                            .disableAutocorrection(true)
                            .focused($isTextFieldFocused)
                    }
                }
                
            }
            .navigationTitle("New Contact")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                if isTextFieldFocused {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Add") {
                            viewModel.createNewChat {
                                dismiss()
                            }
                        }
                    }
                }
            }
        }
    }
}
