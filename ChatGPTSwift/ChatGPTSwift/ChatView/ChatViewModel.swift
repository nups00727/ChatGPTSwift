//
//  ChatViewModel.swift
//  ChatGPTSwift
//
//  Created by Nupur Sharma on 21/06/25.
//
import SwiftUI

@Observable class ChatViewModel {
    var chat: AppChat?
    var messages: [Message] = []//[Message(timestamp: Date(), id: "1",
                                       //content: "You are psycology assistant and you do not have any knowledge about anything", role: .system)]
    var currentInput: String = ""
    private let service = OpenAIService()
    let chatID: String
    var selectedChatModel: ChatModel = ChatModel.chatGPT4
    
    init(chatID: String) {
        self.chatID = chatID
    }
    
    func fetchChats() {
//        messages = [
//            //AppChat(id: "1", topic: "test", model: .chatGPT4, lastMessageSentAt: Date(), owner: "123"),
//            Message(timestamp: Date(), id: "1",
//                                               content: "Hi, How r u?", role: .user),
//            Message(timestamp: Date(), id: "2",
//                                               content: "I am good thanks", role: .assistant)
//        ]
       
    }
    
    func sendMessage () {
        guard !currentInput.isEmpty else {return}
        let sentMessage = Message(id: UUID().uuidString,
                                  content: currentInput, role: .user)
        messages.append(sentMessage)
        currentInput.removeAll()
        
//        Task {
//            do {
//                let receivedMsgResponse = try await service.sendMessage(messages: messages)
//                guard let receivedMsg = receivedMsgResponse?.choices.first?.message else { return print("No 1st message received") }
//                let receivedMsg2 = Message(timestamp: Date(), id: "", content: receivedMsg.content, role: receivedMsg.role)
//                await MainActor.run {
//                    messages.append(receivedMsg2)
//                }
//               
//            } catch (let error) {
//                print("No message received \(error)")
//            }
//            
//        }
        
    }
    
}
