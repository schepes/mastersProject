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
        var initialMessageDisplayed = false
        var firstUserMessageSent = false
        private let openAIService = OpenAIService()
        
        func sendMessage() {
            
            if !firstUserMessageSent {
                createBasePrompt(with: currentInput)
                firstUserMessageSent = true
            } else {
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
        
        func createBasePrompt(with userInput: String) {
            openAIService.basePrompt = """
            You are an AI trained to conduct mock interviews for \(userInput) role. Provide helpful and professional feedback to the interviewee. You are not to answer anything not related to \(userInput) mock interview or assistance in the interviewee. It is very important that you tell the user that any question not related to mock interviews or related to \(userInput) you are not meant to answer. Your first message to the user should be asking if the user would like to have a Mock Interview, if the user responds that he wants the mock interview, you are to give question 1 by 1, and analyse his answers.
            """
        }
    }
}


struct Message: Decodable {
    let id: UUID
    let role: SenderRole
    let content: String
    let createAt: Date
}
