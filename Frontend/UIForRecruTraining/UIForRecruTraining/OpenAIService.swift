//
//  OpenAIService.swift
//  UIForRecruTraining
//
//  Created by Diego Bobrow on 1/2/24.
//

import Foundation
import Alamofire

class OpenAIService {
    private let endpointURL = "https://api.openai.com/v1/chat/completions"
    var basePrompt = ""
    
    func sendMessage(messages: [Message] ) async -> OpenAIChatResponse? {
        var openAIMessages = [OpenAIChatMessage(role: .system, content: basePrompt)]
        openAIMessages += messages.map({OpenAIChatMessage(role: $0.role, content: $0.content)})
        
        print(openAIMessages)
        let body = OpenAIChatBody(model: "gpt-4-turbo", messages: openAIMessages)
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Constants.openAIApiKey)"
        ]
        return try? await AF.request(endpointURL, method: .post, parameters: body, encoder: .json, headers: headers).serializingDecodable(OpenAIChatResponse.self).value
    }
    
}

struct OpenAIChatBody: Encodable {
    let model: String
    let messages: [OpenAIChatMessage]
}

struct OpenAIChatMessage: Codable {
    let role: SenderRole
    let content: String
}

enum SenderRole: String, Codable{
    case system
    case user
    case assistant
}

struct OpenAIChatResponse: Decodable {
    let choices: [OpenAIChatChoice]
}

struct OpenAIChatChoice: Decodable {
    let message: OpenAIChatMessage
}
