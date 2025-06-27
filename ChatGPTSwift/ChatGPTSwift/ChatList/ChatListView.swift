//
//  ChatListView.swift
//  ChatGPTSwift
//
//  Created by Nupur Sharma on 24/06/25.
//

import SwiftUI

struct ChatListView: View {
    
    @State var viewModel = ChatListViewModel()
    @Environment(AppState.self) private var appState: AppState
    @State var topic: String = ""
    @State var showingAlert: Bool = false
    @State var submit: () -> Void = {}
    
    
    var body: some View {
        Group {
            switch viewModel.loadingState {
            case .loading, .none:
                Text("loading...")
            case .noResults:
                Text("No results found")
            case .resultFound:
                List {
                    ChatListChildView(viewModel: viewModel)
                }
            }
        }
        .navigationTitle("Chats")
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showingAlert = true
                    topic = ""
                } label: {
                    Image(systemName: "square.and.pencil")
                }
                .alert("", isPresented: $showingAlert) {
                    TextField("Enter your topic of chat", text: $topic)
                    Button("Create Chat", action: {
                        showingAlert = false
                        Task {
                            do {
                               let chatId = try await viewModel.createChat(user: appState.currentUser?.uid,
                                                                           topic: topic)
                                appState.navigationPath.append(chatId)
                            } catch {
                                print(error)
                            }
                        }
                    })
                }
            }
        })
        .navigationDestination(for: String.self, destination: { chatId in
            ChatView(viewModel: .init(chatID: chatId))
        })
        .onAppear {
            if viewModel.loadingState == .none {
                viewModel.fetchChats(user: appState.currentUser?.uid)
            }
        }
    }
}

#Preview {
    ChatListView()
}

struct ChatListChildView: View {
    var viewModel = ChatListViewModel()
    
    var body: some View {
        ForEach(viewModel.chats, id: \.id) { chat in
            NavigationLink(value: chat.id) {
                VStack(alignment: .leading) {
                    HStack {
                        Text(chat.topic ?? "New Chat")
                            .font(.headline)
                        Spacer()
                        Text(chat.model?.rawValue ?? "")
                            .font(.caption2)
                            .fontWeight(.semibold)
                            .foregroundStyle(chat.model?.tintColor ?? .white)
                            .padding(6)
                            .background((chat.model?.tintColor ?? .white).opacity(0.1))
                            .clipShape(Capsule(style: .continuous))
                        
                    }
                    Text("\(chat.lastMessageTimeAgo)")
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
            }
            .swipeActions(edge: .trailing) {
                Button(role:.destructive) {
                    //todo
                    viewModel.deleteChat(chat: chat)
                } label: {
                    Label("Delete", image: "trash.fill")
                }
            }
        }
    }
}
