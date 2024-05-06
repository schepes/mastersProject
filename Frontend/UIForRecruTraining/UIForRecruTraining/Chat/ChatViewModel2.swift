//
//  ChatViewModel2.swift
//  UIForRecruTraining
//
//  Created by Diego Bobrow on 5/2/24.
//

import OpenAI
import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore
import SwiftUI

class ChatViewModel2: ObservableObject {
    @Published var chat: AppChat?
    @Published var messages: [AppMessage] = []
    @Published var messageText: String = ""
    @Published var selectedModel: ChatModel = .gpt3_5_turbo
    var chatId: String
    
    @AppStorage("openai_api_key") var apiKey = ""
    
    let db = Firestore.firestore()
    
    init(chatId: String) {
        self.chatId = chatId

        if chatId.isEmpty {
            createNewChat()
        } else {
            fetchData()
        }
    }
    
    private func createNewChat() {
        // Creates a new chat document and assigns a generated ID to 'chatId'
        let newChatRef = db.collection("chats").document()
        newChatRef.setData(["createdAt": Timestamp()]) { error in
            if let error = error {
                print("Error creating new chat: \(error)")
            } else {
                DispatchQueue.main.async {
                    self.chatId = newChatRef.documentID
                    self.fetchData()
                }
            }
        }
    }
    
    
    func fetchData(){
        guard !chatId.isEmpty else {
            print("Error: chatId is empty")
            return
        }
        db.collection("chats").document(chatId).getDocument(as: AppChat.self) { result in
            switch result {
            case .success(let success):
                DispatchQueue.main.async {
                    self.chat = success
                }
            case .failure(let failure):
                print(failure)
            }
        }
        
        db.collection("chats").document(chatId).collection("messages").getDocuments { querySnapshot, error in
            guard let documents = querySnapshot?.documents, !documents.isEmpty else {return}
            
            self.messages = documents.compactMap({ snapshot -> AppMessage? in
                do {
                    var message = try snapshot.data(as: AppMessage.self)
                    message.id = snapshot.documentID
                    return message
                } catch {
                    return nil
                }
            })
            
        }
    }
    
    func sendMessage() async throws {
        var newMessage = AppMessage(id: UUID().uuidString, text: messageText, role: .user)
        
        do {
            let documentRef = try storeMessage(message: newMessage)
            newMessage.id = documentRef.documentID
        } catch {
            print(error)
        }
        
        if messages.isEmpty {
            setupNewChat()
            await MainActor.run{ [newMessage] in
                messages.append(newMessage)
                let basePrompt = """
You are an AI specially programmed for mock interviewing for the \(messageText) role, your objective is to assist candidates in preparing effectively for their specific job roles. You will adhere to the following structured approach to ensure efficient and relevant training:

1. **Introduction and Query about Candidate's Background:**
   - Begin by inquiring about the user’s experience related to the \(messageText) role. Adjust the complexity of your questions based on their responses to optimally challenge them based on their experience and the level they are applying. When asking them ensure to let them know that their response will help the interview to be tailored to their level, but give them the option to already start the interview.

2. **Sequential Questioning:**
   - Pose interview questions relevant to the \(messageText) role one at a time, ensuring you wait for a response before moving forward.

3. **Immediate Feedback:**
   - After each answer, provide feedback. If the answer is off-topic, inform the user by saying, 'That response doesn't directly address the question we're focusing on. Could you elaborate more on [specific aspect related to the question]?'

4. **Feedback Options:**
   - After providing some feedback for the answer, if the answer was related to the question, also Offer the user a choice after your feedback—whether they would like to hear the optimal answer (Which should be an example answer that you would create, with specifics and exactly how an answer should look like) or prefer to have their response refined to match what would typically be expected in an interview for the \(messageText) role, or proceed to next question

5. **Handling Irrelevant or Nonsensical Responses:**
   - If the user’s responses drift into irrelevance or nonsense, interject with: 'This seems a bit off the mark. Remember, for the \(messageText) role, you might want to focus on [correct aspect]. What is essential here is [detail what was supposed to be covered].'

6. **Correcting Conceptual Errors:**
   - When you detect a misunderstanding or incorrect claim related to the \(messageText) role, immediately correct the error. Provide a clear, correct explanation by stating, 'Actually, in the \(messageText) role, it's important to understand that [provide the correct concept or practice].' And Point out their mistake

7. **Conclusion and Additional Support:**
    -Make sure the interview is no more then 6 questions at first. After six questions you should ask if the user wants to conclue or go for additional questions. If they go for additional questions, then ask the same again for every additional question If they want or not to conclude the interview or ask additional question.
   - Conclude the interview by asking if they found the mock interview helpful, if they'd like to go over any points again, or if there's anything else related to the \(messageText) role they need clarity on.


Your primary role is to ensure the user remains focused, is well-prepared with informative feedback and corrections, and achieves a practical understanding of what is expected in interviews for their targeted job role.
"""
                if chat?.topic == nil || chat?.topic?.isEmpty == true {
                    updateChatTopic(topic: messageText)
                }
                messageText = ""
                Task{
                    try await generateResponse(for: newMessage, withAdditionalPrompt: basePrompt)
                }
               
            }


        } else {
            // Regular chat message interaction
            await MainActor.run{ [newMessage] in
                messages.append(newMessage)
                messageText = ""
            }
            try await generateResponse(for: newMessage)
        }
    }
    
    private func updateChatTopic(topic: String) {
        chat?.topic = topic
        db.collection("chats").document(chatId).updateData(["topic": topic])
    }
    
    private func storeMessage(message: AppMessage) throws -> DocumentReference {
        return try db.collection("chats").document(chatId).collection("messages").addDocument(from: message)
    }
    
    private func setupNewChat() {
        db.collection("chats").document(chatId).updateData(["model": selectedModel.rawValue])
        DispatchQueue.main.async { [weak self] in
            self?.chat?.model = self?.selectedModel
        }
    }
    
    private func generateResponse(for message: AppMessage, withAdditionalPrompt prompt: String? = nil) async throws {
        let openAI = OpenAI(apiToken: "\(Constants.openAIApiKey)")
       // let openAI = OpenAI(apiToken: "apiKey")
        var queryMessages = messages.map { appMessage -> ChatQuery.ChatCompletionMessageParam in
            return ChatQuery.ChatCompletionMessageParam(role: appMessage.role, content: appMessage.text)!
        }
        
        if let prompt = prompt {
            let systemMessage = AppMessage(id: UUID().uuidString, text: prompt, role: .system)
            queryMessages.insert(ChatQuery.ChatCompletionMessageParam(role: .system, content: prompt)!, at: 0)
            await MainActor.run {
                messages.append(systemMessage)
            }
            _ = try storeMessage(message: systemMessage)
        }


        let query = ChatQuery(messages: queryMessages, model: chat?.model?.model ?? .gpt4_turbo)
        for try await result in openAI.chatsStream(query: query) {
            guard let newText = result.choices.first?.delta.content else { continue }
            await MainActor.run {
                if let lastMessage = messages.last, lastMessage.role != .user, lastMessage.role != .system {
                    messages[messages.count - 1].text += newText
                } else {
                    let newMessage = AppMessage (id: result.id, text: newText, role: .assistant)
                    messages.append(newMessage)
                }
            }
        }
        
        if let lastMessage = messages.last {
            _ = try storeMessage(message: lastMessage)
        }
    }
}

struct AppMessage: Identifiable, Codable, Hashable {
    @DocumentID var id: String?
    var text: String
    let role: ChatQuery.ChatCompletionMessageParam.Role
    var createdAt: FirestoreDate = FirestoreDate()
}
