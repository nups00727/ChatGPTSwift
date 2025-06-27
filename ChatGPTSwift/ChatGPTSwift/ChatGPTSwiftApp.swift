//
//  ChatGPTSwiftApp.swift
//  ChatGPTSwift
//
//  Created by Nupur Sharma on 21/06/25.
//

import SwiftUI
import SwiftData

@main
struct ChatGPTSwiftApp: App {
   @Bindable var appState = AppState()

    var body: some Scene {
        WindowGroup {
            if appState.isLoggedIn {
                NavigationStack(path: $appState.navigationPath) {
                    ChatListView()
                        .environment(appState)
                }
            } else {
                AuthView()
                    .environment(appState)
            }
        }
    }
}
