//
//  ChatListView.swift
//  UIForRecruTraining
//
//  Created by Diego Bobrow on 5/1/24.
//

import SwiftUI

struct ChatListView: View {
    @StateObject var viewModel = ChatListViewModel()
    @EnvironmentObject var appState: AppState
    var body: some View {
        Group {
            switch viewModel.loadingState {
            case .loading, .none:
                Text("Loading chats...")
            case .noResults:
                Text("No chats.")
            case .resultFound:
                List {
                    ForEach(viewModel.chats) { chat in
                        NavigationLink(value: chat.id) {
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(chat.topic ?? "New Chat")
                                        .font(.headline)
                                    Spacer()
                                    Text(chat.model?.rawValue ?? "Default Value")
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
                        .swipeActions {
                            Button(role: .destructive) {
                                viewModel.deleteChat(chat: chat)
                            } label: {
                                Label("Delete", systemImage: "trash.fill")
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Chat History")
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    viewModel.showProfile()
                } label:{
                    Image("ic-settings-medium")
                }
                
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    Task {
                        do {
                            let chatID = try await viewModel.createChat(user: appState.currentUser?.uid)
                            appState.navigationPath.append(chatID)
                        }catch {
                            print(error)
                        }

                    }
                } label:{
                    Image("ic-write-pad-blue")
                }
                
            }
        })
        .sheet(isPresented: $viewModel.isShowingProfileView){
            SettingsView()
                .environmentObject(appState)
        }
        .navigationDestination(for: String.self, destination: {chatId in
            ChatView2(viewModel: .init(chatId: chatId))
        })
        .onAppear(){
            if viewModel.loadingState == .none {
                viewModel.fetchData(user: appState.currentUser?.uid)
            }
        }
    }
}

#Preview {
    ChatListView()
        .environmentObject(AppState())
}
