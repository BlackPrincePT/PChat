//
//  pchatApp.swift
//  pchat
//
//  Created by Petre Chkonia on 07.09.24.
//

import SwiftUI

import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      FirebaseApp.configure()
      return true
    }
}

@main
struct pchatApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                AuthView {
                    Image(systemName: "building.2.crop.circle.fill")
                      .resizable()
                      .frame(width: 100 , height: 100)
                      .foregroundColor(Color(red: 175/255, green: 200/255, blue: 210/255))
                      .aspectRatio(contentMode: .fit)
                      .clipShape(Circle())
                      .clipped()
                      .padding(4)
                      .overlay(Circle().stroke(Color.black, lineWidth: 2))
                    Text("Welcome to PChat!")
                      .font(.title)
                    Text("You need to be logged in to use this app.")
                  } content: {
                    RootContentView()
                  }
            }
        }
    }
}
