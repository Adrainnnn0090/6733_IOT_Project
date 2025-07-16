//
//  DC6733App.swift
//  DC6733
//
//  Created by Jo on 2025/7/15.
//

import SwiftUI

@main
struct DC6733App: App {
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(appState)
        }
    }
}
