//
//  ChatView.swift
//  ChatGPTSwift
//
//  Created by Nupur Sharma on 21/06/25.
//

import SwiftUI
import SwiftData

struct ChatView: View {
   // @Environment(\.modelContext) private var modelContext
   @State var viewModel = ChatViewModel()
    
    var body: some View {
        VStack {
            ScrollView {
                ForEach(viewModel.messages.filter({$0.role != .system}), id: \.id) { message in
                    messageView(message: message)
                }
            }
            HStack {
                TextField("Type your message here...",
                          text: $viewModel.currentInput)
                    .padding()
                Button(action: {
                    viewModel.sendMessage()
                }) {
                    Text("Send")
                }
            }
        }
        .padding()
    }

    func messageView(message: Message) -> some View {
        HStack {
            if message.role == .user {Spacer()}
                Text(message.content)
                .padding()
                .background(message.role == .user ? Color.blue : Color.gray.opacity(0.2))
            if message.role == .assistant {Spacer()}
            
        }
    }
 
}

#Preview {
    ChatView()
}
