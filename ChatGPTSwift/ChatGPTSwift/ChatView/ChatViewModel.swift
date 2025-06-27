//
//  ChatViewModel.swift
//  ChatGPTSwift
//
//  Created by Nupur Sharma on 21/06/25.
//
import SwiftUI
import FirebaseFirestore
import OpenAI

@Observable final class ChatViewModel: Sendable {
    var chat: AppChat?
    var messages: [Message] = []//[Message(timestamp: Date(), id: "1",
                                       //content: "You are psycology assistant and you do not have any knowledge about anything", role: .system)]
    var currentInput: String = ""
    var loadingState: ChatListState = .loading
    private let service = OpenAIService()
    let chatID: String
    var selectedChatModel: ChatModel = ChatModel.chatGPT4_1
    private let db = Firestore.firestore()
    
    init(chatID: String) {
        self.chatID = chatID
    }
    
    func fetchChats() {
        
        db.collection("chats").document(chatID).getDocument(as: AppChat.self) { [weak self] result in
            switch result {
            case .success(let appChat):
                DispatchQueue.main.async {
                    self?.loadingState = .resultFound
                    self?.chat = appChat
                }
            case .failure(let error):
                print(error)
                self?.loadingState = .resultFound
            }
        }
        
        db.collection("chats").document(chatID).collection("messages")
            .order(by: "createdAt", descending: false).getDocuments { snapshot, error in
                
            guard let documents = snapshot?.documents, !documents.isEmpty else {return}
           
            self.messages = documents.compactMap({ msg -> Message? in
                    do {
                        var message = try msg.data(as: Message.self)
                        message.id = msg.documentID
                        return message
                    } catch {
                       return nil
                    }
                })
        }
    }
    
    func sendMessage () async throws {
        guard !currentInput.isEmpty else {return}
        var sentMessage = Message(id: UUID().uuidString,
                                  content: currentInput, role: .user)
        
        do {
           let docRef = try storeMessage(message: sentMessage)
            sentMessage.id = docRef.documentID
        } catch {
            print(error)
        }
        
        if messages.isEmpty {
            await setupNewChat()
        }
        
        await MainActor.run { [sentMessage] in
            messages.append(sentMessage)
            currentInput.removeAll()
        }
        
        try await generateResponse(message: sentMessage)
    }
    
    //setup gpt model when 1st message sent by user
    private func setupNewChat() async {
        do {
            try await db.collection("chats").document(chatID).updateData(
                ["model": selectedChatModel.rawValue])
        } catch {
            print(error)
        }
        DispatchQueue.main.async { [weak self] in
            self?.chat?.model = self?.selectedChatModel
        }
    }
    
    /* Stores message in firebasestore
     Returns firebase document location */
    private func storeMessage(message: Message) throws -> DocumentReference {
        return try db.collection("chats").document(chatID).collection("messages").addDocument(from: message)
    }
    
    private func generateResponse(message: Message) async throws {
//                Task {
//                    do {
//                        let receivedMsgResponse = try await service.sendMessage(messages: messages)
//                        guard let receivedMsg = receivedMsgResponse?.choices.first?.message else { return print("No 1st message received") }
//                       
//        
//                    } catch (let error) {
//                        print("No message received \(error)")
//                    }
//        
//                }
        let openAI = OpenAI(apiToken: "\(Secrets.apiKey)")
        let queryMessages = messages.compactMap { appMessage in
            ChatQuery.ChatCompletionMessageParam(role: appMessage.role, content: appMessage.content)
        }
        let query = ChatQuery(messages: queryMessages , model: chat?.model?.model ?? .gpt4_1)
        
        for try await result in openAI.chatsStream(query: query) {
            guard let newText = result.choices.first?.delta.content else { continue }
            await MainActor.run {
                if let lastMessage = messages.last, lastMessage.role != .user {
                    //Append message to existing assistant responses
                    messages[messages.count - 1].content += "\(newText)"
                } else {
                    let newMessage = Message(id: result.id, content: newText, role: .assistant)
                    messages.append(newMessage)
                }
            }
        }
        if let lastMessage = messages.last {
            _ = try storeMessage(message: lastMessage)
        }
        
    }
    
}
