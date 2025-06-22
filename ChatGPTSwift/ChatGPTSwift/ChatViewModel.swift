//
//  ChatViewModel.swift
//  ChatGPTSwift
//
//  Created by Nupur Sharma on 21/06/25.
//
import SwiftUI

@Observable class ChatViewModel {
    var messages: [Message] = []
    var currentInput: String = ""
    private let service = OpenAIService()
    
    func sendMessage () {
        let sentMessage = Message(timestamp: Date(), id: UUID(), content: currentInput, role: .user)
        messages.append(sentMessage)
        currentInput.removeAll()
        
        Task {
            do {
                let receivedMsgResponse = try await service.sendMessage(messages: messages)
                guard let receivedMsg = receivedMsgResponse?.choices.first?.message else { return print("No 1st message received") }
                let receivedMsg2 = Message(timestamp: Date(), id: UUID(), content: receivedMsg.content, role: receivedMsg.role)
                await MainActor.run {
                    messages.append(receivedMsg2)
                }
               
            } catch (let error) {
                print("No message received \(error)")
            }
            
        }
        
    }
    
}
