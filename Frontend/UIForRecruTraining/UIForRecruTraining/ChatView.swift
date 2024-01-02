//
//  ChatView.swift
//  UIForRecruTraining
//
//  Created by Diego Bobrow on 1/1/24.
//

import SwiftUI

struct ChatView: View {
    @ObservedObject var viewModel = ViewModel()
    var body: some View {
        
        VStack {
            ScrollView {
                ForEach(viewModel.messages.filter({$0.role != .system}), id: \.id) { message in
                messageView(message: message)}
            }
            HStack{
                Image("ic-microphone")
                    .padding()
                TextField("Message", text: $viewModel.currentInput)
                    .font(.chatMessage)
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
                    .padding(.vertical, 10)
                    .background(.white)
                    .cornerRadius(25)
                    .overlay( RoundedRectangle(cornerRadius: 25)
                        .inset(by: 0.5)
                        .stroke(Color(red: 0.85, green: 0.87, blue: 0.91), lineWidth: 1)
                              

                    )
                Button{
                    viewModel.sendMessage()
                } label:{
                    Text("Send")
                        .font(.chatMessage)
                }
            }
            .padding()
            
        }
        .background(Color("Background"))
        
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Image("ic-two-lines")
            }
            
            ToolbarItem(placement: .principal) {
                Text("Mock Interview")
                    .font(.navModelTitle)
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Image("ic-write-pad")
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func messageView(message: Message) -> some View {
        HStack {
            if message.role == .user { Spacer()}
            Text(message.content)
                .font(.chatMessage)
            if message.role == .assistant { Spacer()}
        }
    }
}

#Preview {
    ChatView()
}
