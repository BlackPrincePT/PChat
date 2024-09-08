//
//  Color+Custom.swift
//  pchat
//
//  Created by Petre Chkonia on 08.09.24.
//

import SwiftUI

extension Color {
    struct Custom {
        static let black: Color = Color(red: 10/255, green: 10/255, blue: 10/255)
        
        struct MessageBubble {
            static let blue: Color = Color(red: 175/255, green: 200/255, blue: 210/255)
            static let white: Color = Color(red: 255/255, green: 255/255, blue: 255/255)
        }
        
        struct Toolbar {
            static let white: Color = Color(red: 245/255, green: 245/255, blue: 245/255)
        }
        
        struct ChatBackground {
            static let white: Color = Color(red: 235/255, green: 235/255, blue: 235/255)
        }
    }
}
