//
//  ChatView.swift
//  UIForRecruTraining
//
//  Created by Diego Bobrow on 1/1/24.
//

import SwiftUI

struct ChatBubble: Shape {
    var myMessage : Bool
    func path(in rect: CGRect) -> Path {
        let width = rect.width
        let height = rect.height
        
        let bezierPath = UIBezierPath()
        if !myMessage {
            bezierPath.move(to: CGPoint(x: 20, y: height))
            bezierPath.addLine(to: CGPoint(x: width - 15, y: height))
            bezierPath.addCurve(to: CGPoint(x: width, y: height - 15), controlPoint1: CGPoint(x: width - 8, y: height), controlPoint2: CGPoint(x: width, y: height - 8))
            bezierPath.addLine(to: CGPoint(x: width, y: 15))
            bezierPath.addCurve(to: CGPoint(x: width - 15, y: 0), controlPoint1: CGPoint(x: width, y: 8), controlPoint2: CGPoint(x: width - 8, y: 0))
            bezierPath.addLine(to: CGPoint(x: 20, y: 0))
            bezierPath.addCurve(to: CGPoint(x: 5, y: 15), controlPoint1: CGPoint(x: 12, y: 0), controlPoint2: CGPoint(x: 5, y: 8))
            bezierPath.addLine(to: CGPoint(x: 5, y: height - 10))
            bezierPath.addCurve(to: CGPoint(x: 0, y: height), controlPoint1: CGPoint(x: 5, y: height - 1), controlPoint2: CGPoint(x: 0, y: height))
            bezierPath.addLine(to: CGPoint(x: -1, y: height))
            bezierPath.addCurve(to: CGPoint(x: 12, y: height - 4), controlPoint1: CGPoint(x: 4, y: height + 1), controlPoint2: CGPoint(x: 8, y: height - 1))
            bezierPath.addCurve(to: CGPoint(x: 20, y: height), controlPoint1: CGPoint(x: 15, y: height), controlPoint2: CGPoint(x: 20, y: height))
        } else {
            bezierPath.move(to: CGPoint(x: width - 20, y: height))
            bezierPath.addLine(to: CGPoint(x: 15, y: height))
            bezierPath.addCurve(to: CGPoint(x: 0, y: height - 15), controlPoint1: CGPoint(x: 8, y: height), controlPoint2: CGPoint(x: 0, y: height - 8))
            bezierPath.addLine(to: CGPoint(x: 0, y: 15))
            bezierPath.addCurve(to: CGPoint(x: 15, y: 0), controlPoint1: CGPoint(x: 0, y: 8), controlPoint2: CGPoint(x: 8, y: 0))
            bezierPath.addLine(to: CGPoint(x: width - 20, y: 0))
            bezierPath.addCurve(to: CGPoint(x: width - 5, y: 15), controlPoint1: CGPoint(x: width - 12, y: 0), controlPoint2: CGPoint(x: width - 5, y: 8))
            bezierPath.addLine(to: CGPoint(x: width - 5, y: height - 12))
            bezierPath.addCurve(to: CGPoint(x: width, y: height), controlPoint1: CGPoint(x: width - 5, y: height - 1), controlPoint2: CGPoint(x: width, y: height))
            bezierPath.addLine(to: CGPoint(x: width + 1, y: height))
            bezierPath.addCurve(to: CGPoint(x: width - 12, y: height - 4), controlPoint1: CGPoint(x: width - 4, y: height + 1), controlPoint2: CGPoint(x: width - 8, y: height - 1))
            bezierPath.addCurve(to: CGPoint(x: width - 20, y: height), controlPoint1: CGPoint(x: width - 15, y: height), controlPoint2: CGPoint(x: width - 20, y: height))
        }
        return Path(bezierPath.cgPath)
    }
}

struct ChatView: View {
    @ObservedObject var viewModel = ViewModel()
    var body: some View {
        
        VStack {
            ScrollView {
                if viewModel.messages.isEmpty {
                    Text("Welcome to Mock Interview Chat! This chat will help you prepare for your job interviews. Please let me know the position you are applying for, just tell the exact position name and nothing else.")
                        .font(.chatHistory)
                        .padding()
                        .foregroundColor(Color("MainColor"))
                        .background(Color.red)
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                        .onAppear {
                            // Set the flag to true so the initial message is not repeated
                            viewModel.initialMessageDisplayed = true
                        }
                }
                
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
                .padding()
                .background(message.role == .user ? Color.blue : Color.green)
                .clipShape(ChatBubble(myMessage: message.role == .user))
            
            if message.role == .assistant { Spacer()}
        }
    }
}

#Preview {
    ChatView()
}
