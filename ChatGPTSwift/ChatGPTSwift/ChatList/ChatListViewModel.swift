//
//  ChatListViewModel.swift
//  ChatGPTSwift
//
//  Created by Nupur Sharma on 24/06/25.
//

import SwiftUI
import FirebaseFirestore
import OpenAI

@Observable class ChatListViewModel {
    
    var chats: [AppChat] = []
    var loadingState: ChatListState = .none
    private let db = Firestore.firestore()
    
    func fetchChats(user: String?) {
        
        if loadingState == .none {
            loadingState = .loading
            db.collection("chats").whereField("owner", isEqualTo: user ?? "").addSnapshotListener { [weak self] snapshot, error in
                guard let self = self, let documents = snapshot?.documents, !documents.isEmpty else {
                    self?.loadingState = .noResults
                    return
                }
                
                self.chats = documents.compactMap({ docSnapshot -> AppChat? in
                    return try? docSnapshot.data(as: AppChat.self)
                })
                .sorted(by: {$0.lastMessageSentAt > $1.lastMessageSentAt})
                loadingState = .resultFound
            }
        }
    }
    
    func createChat(user: String?, topic: String = "New Chat") async throws -> String {
        let document = try await db.collection("chats").addDocument(data:
                                                                        ["lastMessageSentAt": Date(),
                                                                         "owner": user ?? "",
                                                                         "topic": topic])
        return document.documentID
    }
    
    func deleteChat(chat: AppChat) {
        guard let id = chat.id else { return }
        db.collection("chats").document(id).delete()
    }
}

enum ChatListState {
    case loading
    case noResults
    case resultFound
    case none
}

struct AppChat: Codable {
    @DocumentID var id: String?
    let topic: String?
    var model: ChatModel?
    let lastMessageSentAt: FireStoreDate
    let owner: String
    
    var lastMessageTimeAgo: String {
        let now = Date()
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: lastMessageSentAt.date, to: now)
        let timeUnits: [(value: Int?, unit: String)] = [
            (components.year, "year"),
            (components.month, "month"),
            (components.day, "day"),
            (components.hour, "hour"),
            (components.minute, "minute"),
            (components.second, "second")
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
    case chatGPT4_1 = "GPT 4.1"
    
    var tintColor: Color {
        switch self {
        case .chatGPT40:
            return .green
        case .chatGPT4_1:
            return .purple
        }
    }
    
    var model: Model {
        switch self {
        case .chatGPT40:
            return .gpt4_o
        case .chatGPT4_1:
            return .gpt4_1
        }
    }
}

struct FireStoreDate: Codable, Hashable, Comparable {
    var date: Date
    init(date: Date = Date()) {
        self.date = date
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let timeStamp = try container.decode(Timestamp.self)
        self.date = timeStamp.dateValue()
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        let timeStamp = Timestamp(date: date)
        try container.encode(timeStamp)
    }
    static func < (lhs: FireStoreDate, rhs: FireStoreDate) -> Bool {
        lhs.date < rhs.date
    }
    
}
