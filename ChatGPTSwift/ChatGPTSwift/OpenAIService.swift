//
//  OpenAIService.swift
//  ChatGPTSwift
//
//  Created by Nupur Sharma on 21/06/25.
//

import Foundation

class OpenAIService {
    
  private let endpoint = "https://api.openai.com/v1/chat/completions"

    func sendMessage(messages: [Message]) async throws -> OpenAIChatResponse? {
        let openAIChatMessages = messages.map({ OpenAIChatmessage(role: $0.role, content: $0.content) })
        let openAIBody = OpenAIChatBody(model: "gpt-4o", messages: openAIChatMessages)
        
        var request = URLRequest(url: URL(string: endpoint)!)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = ["Authorization": "Bearer \(Constants.apiKey)",
                                       "Content-Type": "application/json"]
        request.httpBody = try JSONEncoder().encode(openAIBody)
        let (data, response) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(OpenAIChatResponse.self, from: data)
    }
}

struct OpenAIChatResponse: Codable {
    let choices: [OpenAIChoice]
}

struct OpenAIChoice: Codable {
    let message: OpenAIChatmessage
}
