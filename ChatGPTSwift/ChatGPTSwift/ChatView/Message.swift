//
//  Item.swift
//  ChatGPTSwift
//
//  Created by Nupur Sharma on 21/06/25.
//

import Foundation

struct Message: Codable {
    let timestamp: Date
    let id: UUID
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
