//
//  ChatListView.swift
//  ChatGPTSwift
//
//  Created by Nupur Sharma on 24/06/25.
//

import SwiftUI

struct ChatListView: View {
    
    @State var viewModel = ChatListViewModel()
    
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
                    //Todo
                } label: {
                    Image(systemName: "person.crop.circle.fill")
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    //todo
                } label: {
                    Image(systemName: "square.and.pencil")
                }
            }
        })
        .onAppear {
            if viewModel.loadingState == .none {
                viewModel.fetchChats()
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
        }
    }
}
