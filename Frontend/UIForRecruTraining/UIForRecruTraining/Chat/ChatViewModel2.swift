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

class ChatViewModel2: ObservableObject {
    @Published var chat: AppChat?
    @Published var messages: [AppMessage] = []
    @Published var messageText: String = ""
    @Published var selectedModel: ChatModel = .gpt3_5_turbo
    var chatId: String
    
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
                let basePrompt = "As an AI trained for mock interviews, you will guide the user through a \(messageText) role interview. Answer only with questions and feedback related to the job preparation. Do not answer unrelated queries. Start by asking if the user is ready to begin the mock interview."
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
