//
//  Item.swift
//  ChatGPTSwift
//
//  Created by Nupur Sharma on 21/06/25.
//

import Foundation
import OpenAI
import FirebaseFirestore

struct Message: Codable, Hashable, Identifiable {
    var createdAt: FireStoreDate = FireStoreDate()
    @DocumentID var id: String?
    let content: String
    let role: SenderRole
}

struct OpenAIChatBody: Codable {
    let model: String
    let messages: [OpenAIChatmessage]
}

struct OpenAIChatmessage: Codable {
    let role: SenderRole
    let content: String
}

enum SenderRole: String, Codable {
    //case developer
    case user
    case assistant
    case system
}
