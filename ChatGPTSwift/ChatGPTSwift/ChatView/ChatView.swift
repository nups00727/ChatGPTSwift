//
//  ChatView.swift
//  ChatGPTSwift
//
//  Created by Nupur Sharma on 21/06/25.
//

import SwiftUI
import SwiftData

struct ChatView: View {
 
    @State var viewModel = ChatViewModel(chatID: "")
    
    var body: some View {
        VStack {
            chatSelection
            ScrollViewReader { scrollView in
                List(viewModel.messages.filter({$0.role != .system})) { message in
                    messageView(message: message)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        .id(message.id)
                        .onChange(of: viewModel.messages) { oldValue ,newValue in
                            scrollToBotton(scrollView: scrollView)
                        }
                }
                .background(Color(uiColor: .systemGroupedBackground))
                .listStyle(.plain)
            }
            messageInputView
        }
        .navigationTitle(viewModel.chat?.topic ?? "New Chat")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.fetchChats()
        }
    }
    
    private func scrollToBotton(scrollView: ScrollViewProxy) {
        guard !viewModel.messages.isEmpty, let lastMsg = viewModel.messages.last else {return}
        scrollView.scrollTo(lastMsg.id)
    }
    
    @ViewBuilder
    var chatSelection: some View {
        Group {
            if let model = viewModel.chat?.model?.rawValue {
                Text(model)
            } else {
                Picker(selection: $viewModel.selectedChatModel) {
                    ForEach(ChatModel.allCases, id: \.self) { model in
                        Text(model.rawValue)
                    }
                } label: {
                    Text("")
                }
                .pickerStyle(.segmented)
                .padding()
            }
        }
        
    }

    func messageView(message: Message) -> some View {
        HStack {
            if message.role == .user {Spacer()}
                Text(message.content)
                .padding(.horizontal)
                .padding(.vertical, 12)
                .foregroundStyle(message.role == .user ? Color.white : Color.black)
                .background(message.role == .user ? Color.purple : Color.gray.opacity(0.2))
                .cornerRadius(12)
            if message.role == .assistant {Spacer()}
            
        }
    }
    
    @ViewBuilder
    var messageInputView: some View {
        HStack {
            TextField("Type your message here...",
                      text: $viewModel.currentInput)
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
            .onSubmit {
                viewModel.sendMessage()
            }
            
            Button(action: {
                viewModel.sendMessage()
            }) {
                Text("Send")
                    .foregroundStyle(Color.white)
                    .padding()
                    .background(Color.indigo)
                    .cornerRadius(12)
            }
        }
        .padding()
    }
 
}

#Preview {
    ChatView()
}
