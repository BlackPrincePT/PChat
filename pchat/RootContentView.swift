//
//  ContentView.swift
//  pchat
//
//  Created by Petre Chkonia on 07.09.24.
//

import SwiftUI

struct RootContentView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationStack {
            TabView(selection: $selectedTab) {
                Group {
                    InboxView()
                        .tabItem {
                            Image(systemName: "message")
                            Text("Chats")
                        }
                        .tag(0)
                    
                    SettingsView()
                        .environmentObject(viewModel)
                        .tabItem {
                            Image(systemName: "gearshape")
                            Text("Settings")
                        }
                        .tag(1)
                }
            }
        }
        
    }
    
}
