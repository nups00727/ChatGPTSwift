//
//  ChatGPTViewModel.swift
//  ChatGPTSwift
//
//  Created by Nupur Sharma on 25/06/25.
//
import Foundation
import OpenAI

class ChatGPTViewModel {
    var chat: AppChat!
    
}

struct AppMessage: Identifiable, Hashable, Codable {
    let id: String?
    var text: String
    var role: SenderRole
    var createdAt: Date
    
}
