//
//  ChatGPTViewModel.swift
//  ChatGPTSwift
//
//  Created by Nupur Sharma on 25/06/25.
//

class ChatGPTViewModel {
    let chatID: String
    
    init(chatID: String) {
        self.chatID = chatID
    }
}

struct AppMessage: Identifiable, Hashable, Codable {
    let id: String
    
}
