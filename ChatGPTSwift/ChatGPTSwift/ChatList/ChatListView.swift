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
                    viewModel.showProfile()
                } label: {
                    Image(systemName: "person.crop.circle.fill")
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    Task {
                        do {
                           let chatId = try await viewModel.createChat(user: appState.currentUser?.uid)
                            appState.navigationPath.append(chatId)
                        } catch {
                            print(error)
                        }
                    }
                } label: {
                    Image(systemName: "square.and.pencil")
                }
            }
        })
        .sheet(isPresented: $viewModel.isShowingProfileView, content: {
            ProfileView()
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
                    Text(chat.lastMessageTimeAgo)
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
