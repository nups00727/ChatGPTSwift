//
//  ChatListViewModel.swift
//  ChatGPTSwift
//
//  Created by Nupur Sharma on 24/06/25.
//

import SwiftUI

@Observable class ChatListViewModel {
    
    var chats: [AppChat] = []
    var loadingState: ChatListState = .none
    
    func fetchChats() {
        chats = [
            AppChat(id: "1", topic: "test", model: .chatGPT4, lastMessageSentAt: Date(), owner: "123"),
            AppChat(id: "2", topic: "test 1", model: .chatGPT40, lastMessageSentAt: Date(), owner: "123")
        ]
        loadingState = .resultFound
    }
}

enum ChatListState {
    case loading
    case noResults
    case resultFound
    case none
}

struct AppChat {
    let id: String
    let topic: String?
    let model: ChatModel?
    let lastMessageSentAt: Date
    let owner: String
    
    var lastMessageTimeAgo: String {
        let now = Date()
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: lastMessageSentAt, to: now)
        let timeUnits: [(value: Int?, unit: String)] = [
            (components.year, "year"),
            (components.year, "month"),
            (components.year, "day"),
            (components.year, "hour"),
            (components.year, "minute"),
            (components.year, "second")
        ]
        for unit in timeUnits {
            if let value = unit.value, value > 0 {
                    
                return "\(value) \(unit.unit)\(value == 1 ? "" : "s")"
            }
        }
        
        return "just now"
    }
}

enum ChatModel: String, Codable, CaseIterable, Hashable {
    case chatGPT40 = "GPT 4o"
    case chatGPT4 = "gpt 4"
    
    var tintColor: Color {
        switch self {
        case .chatGPT40:
            return .green
        case .chatGPT4:
            return .purple
        }
    }
}
