//
//  ChatViewModel.swift
//  UIForRecruTraining
//
//  Created by Diego Bobrow on 1/2/24.
//

import Foundation
extension ChatView {
    class ViewModel: ObservableObject {
        @Published var messages: [Message] = []
        
        @Published var currentInput: String = ""
        private let openAIService = OpenAIService()
        
        func sendMessage() {
            let newMessage = Message(id: UUID(), role: .user, content: currentInput, createAt: Date())
            messages.append(newMessage)
            currentInput = ""
            
            Task {
                let response = await openAIService.sendMessage(messages: messages)
                guard let receivedOpenAIMessages = response?.choices.first?.message else {
                    print("ERROR: HAD no RESPONSE FROM OPEN AI")
                    return
                }
                let receivedMessage = Message(id:UUID(), role: receivedOpenAIMessages.role, content: receivedOpenAIMessages.content, createAt: Date())
                await MainActor.run{
                    messages.append(receivedMessage)
                }
            }
        }
    }
}

struct Message: Decodable {
    let id: UUID
    let role: SenderRole
    let content: String
    let createAt: Date
}
