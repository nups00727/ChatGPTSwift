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
            if viewModel.loadingState == .loading {
                VStack {
                    Spacer()
                    ProgressView()
                    Text("Loading chats...")
                        .foregroundStyle(.gray.opacity(0.7))
                    Spacer()
                }
            } else {
                chatSelection
                ScrollViewReader { scrollView in
                    List(viewModel.messages.filter({$0.role != .system})) { message in
                        messageView(message: message)
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                            .id(message.id)
                            .onAppear(){
                                withAnimation {
                                    scrollToBottom(scrollView: scrollView,
                                                   id: lastMessageId(id: message.id))
                                }
                            }
                            .onChange(of: viewModel.messages) { _, _ in
                                scrollToBottom(scrollView: scrollView,
                                               id: lastMessageId(id: message.id))
                            }
                    }
                    .background(Color(uiColor: .systemGroupedBackground))
                    .listStyle(.plain)
                }
                messageInputView
            }
        }
        .navigationTitle(viewModel.chat?.topic ?? "New Chat")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.fetchChats()
        }
    }
    
    private func lastMessageId(id: String?) -> String {
        if let lastMessage = viewModel.messages.last,
           lastMessage.id == id {
            return id ?? "0"
        }
        return "0"
    }
    
    @MainActor
    private func scrollToBottom(scrollView: ScrollViewProxy, id: String) {
        scrollView.scrollTo(id, anchor: .bottom)
    }
    
    @ViewBuilder
    var chatSelection: some View {
        Group {
            if let model = viewModel.chat?.model?.rawValue {
                Text(model)
                    .padding(.horizontal, 15)
                    .foregroundStyle(.purple)
                    .background(Color(uiColor: .systemGroupedBackground))
                    .frame(height: 40)
                    .cornerRadius(12)
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
                sendMessage()
            }
            
            Button(action: {
                sendMessage()
            }) {
                Text("Send")
                    .foregroundStyle(Color.white)
                    .padding()
                    .background(Color.indigo)
                    .cornerRadius(12)
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal)
    }
    
    private func sendMessage() {
        Task {
            do {
                try await viewModel.sendMessage()
            } catch {
                print(error)
            }
        }
    }
 
}

#Preview {
    ChatView()
}
