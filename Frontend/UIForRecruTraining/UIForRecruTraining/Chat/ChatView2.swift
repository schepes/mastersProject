//
//  ChatView2.swift
//  UIForRecruTraining
//
//  Created by Diego Bobrow on 5/2/24.
//

import SwiftUI

struct ChatView2: View {
    @StateObject var viewModel: ChatViewModel2
    var body: some View {
        VStack {
            chatSelection
            ScrollViewReader { scrollView in
                List(viewModel.messages) { message in
                    messageView(for: message)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        .id(message.id)
                        .onChange(of: viewModel.messages) { 
                            scrollToBottom(scrollView: scrollView)
                        }
                }
                .background(Color("Background"))
                .listStyle(.plain)
            }
            messageInputView
        }
        .navigationTitle(viewModel.chat?.topic ?? "New Chat")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.fetchData()
        }
    }
    func scrollToBottom (scrollView: ScrollViewProxy){
        guard !viewModel.messages.isEmpty, let lastMessage = viewModel.messages.last else {
            return
        }
        
        withAnimation {
            scrollView.scrollTo(lastMessage.id)
        }
    }
    var chatSelection: some View {
        Group {
            if let model = viewModel.chat?.model?.rawValue {
                Text(model)
            } else {
                Picker(selection: $viewModel.selectedModel) {
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
    
    func messageView(for message: AppMessage) -> some View {
        HStack {
            if message.role == .user { Spacer()}
            Text(message.text)
                .font(.chatMessage)
                .padding()
                .background(message.role == .user ? Color.blue : Color.green)
                .clipShape(ChatBubble(myMessage: message.role == .user))
            
            if message.role == .assistant {
                Spacer()
            }
        }
    }
    
    var messageInputView: some View {
        HStack{
            Image("ic-microphone")
                .padding()
            TextField("Message", text: $viewModel.messageText)
                .font(.chatMessage)
                .padding(.leading, 20)
                .padding(.trailing, 20)
                .padding(.vertical, 10)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(25)
                .overlay( RoundedRectangle(cornerRadius: 25)
                    .inset(by: 0.5)
                    .stroke(Color(red: 0.85, green: 0.87, blue: 0.91), lineWidth: 1)
                )
                .onSubmit {
                    sendMessage()
                }
            Button{
                sendMessage()
            } label:{
                Text("Send")
                    .padding()
                    .foregroundStyle(.white)
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                    .font(.chatMessage)
            }
        }
        .padding()
    }
    
    func sendMessage() {
        Task {
            do {
                try await viewModel.sendMessage()
            }catch{
                print(error)
            }
        }
    }
}

#Preview {
    ChatView2(viewModel: .init(chatId: ""))
}
