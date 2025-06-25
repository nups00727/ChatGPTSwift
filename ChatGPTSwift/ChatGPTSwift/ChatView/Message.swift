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
    var content: String
    let role: ChatQuery.ChatCompletionMessageParam.Role
}

struct OpenAIChatBody: Codable {
    let model: String
    let messages: [OpenAIChatmessage]
}

struct OpenAIChatmessage: Codable {
    let role: ChatQuery.ChatCompletionMessageParam.Role
    let content: String
}

//enum SenderRole: String, Codable {
//    //case developer
//    case user
//    case assistant
//    case system
//}
