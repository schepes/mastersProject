//
//  ChatView2.swift
//  UIForRecruTraining
//
//  Created by Diego Bobrow on 5/2/24.
//

import SwiftUI

struct ChatView2: View {
    @StateObject var viewModel: ChatViewModel2
    @State private var inputHeight: CGFloat = 18
    @Environment(\.presentationMode) var presentationMode
    @StateObject var audioRecorder = AudioRecorder()
    @StateObject var speechRecognizer = SpeechRecognizer()
    @State private var secondsElapsed = 0
    @State private var recordingTimer: Timer?
    @State private var showingTimer = false
    private let maxInputHeight: CGFloat = UIScreen.main.bounds.height / 3
    var body: some View {
        VStack {
            chatSelection
            ScrollViewReader { scrollView in
                if viewModel.messages.isEmpty {
                    Text("Welcome to Mock Interview Chat! This chat will help you prepare for your job interviews. Please let me know the position you are applying for, just tell the exact position name and nothing else.")
                        .font(.chatHistory)
                        .padding()
                        .foregroundColor(Color.black)
                        .background(Color.red)
                        .clipShape(RoundedRectangle(cornerRadius: 25))

                }
                List(viewModel.messages.filter { $0.role != .system }) { message in
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
        .navigationBarBackButtonHidden(true)
        .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        backButton // Custom back button
                    }
                    ToolbarItem(placement: .principal) {
                        Text(viewModel.chat?.topic ?? "New Chat")
                            .font(.appTitle)
                            .foregroundColor(Color("MainColor"))
                    }
            ToolbarItem(placement: .navigationBarTrailing) {
                newChatButton
            }
                }
        .onAppear {
            viewModel.fetchData()
        }
        .onTapGesture {
            self.dismissKeyboard()
        }
    }
    var newChatButton: some View {
        Button(action: {
        }){
            Image("ic-write-pad")
                .aspectRatio(contentMode: .fit)
        }
    }
    var backButton: some View {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image("ic-two-lines")
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(Color("MainColor"))
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
                .foregroundStyle(message.role == .user ? Color("LetterBubbleUser") : Color.black)
                .padding()
                .background(message.role == .user ? Color("MainColor") : Color("AssistantBubble"))
                .clipShape(ChatBubble(myMessage: message.role == .user))
            
            if message.role == .assistant {
                Spacer()
            }
        }
    }
    
    var messageInputView: some View {
            HStack {
                VStack{
                    if showingTimer {
                        Text("Recording: \(secondsElapsed) sec")
                            
                            .background(Color.red)
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                    }
                    Button(action: {}) { // Empty action to maintain the button's clickable behavior.
                        Image("ic-microphone")
                        
                    }
                    .onLongPressGesture(minimumDuration: .infinity, maximumDistance: .infinity, pressing: { isPressing in
                        if isPressing {
                            startRecording() // Start recording when button is pressed
                        } else {
                            stopRecording()  // Stop when released
                        }
                    }, perform: {})
                    .padding()
                }

                ZStack(alignment: .topLeading) {
                    TextEditor(text: $viewModel.messageText)
                        .font(.chatMessage)
                        .frame(minHeight: 36, maxHeight: inputHeight)
                        .padding(10)
                        .scrollContentBackground(.hidden) // Restoring this property
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(25)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .inset(by: 0.5)
                                .stroke(Color.gray.opacity(0.1), lineWidth: 1)
                        )
                        .onChange(of: viewModel.messageText) { _ in
                            updateInputHeight()
                        }
                    
                    if viewModel.messageText.isEmpty {
                        Text("Message")
                            .foregroundColor(.gray)
                            .padding(18)
                            .font(.chatMessage)
                    }
                }
                

                Button(action: sendMessage) {
                    Text("Send")
                        .padding()
                        .background(Color("MainColor"))
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                        .font(.chatMessage)
                }
            }
            .padding()
        }

        private func updateInputHeight() {
            let newSize = heightForTextEditor(text: viewModel.messageText)
            if newSize > inputHeight && newSize < maxInputHeight {
                inputHeight = newSize
            } else if newSize < inputHeight {
                inputHeight = max(18, newSize)  // Reset to min height if text is removed
            }
        }

        private func heightForTextEditor(text: String) -> CGFloat {
            let textView = UITextView()
            textView.text = text
            textView.font = UIFont.systemFont(ofSize: 16)  // Adjust the font size as per your design
            let size = CGSize(width: UIScreen.main.bounds.width - 150, height: CGFloat.infinity)
            let estimatedSize = textView.sizeThatFits(size)
            return estimatedSize.height
        }

    
    
    func startRecording() {
        audioRecorder.setupRecorder()
        audioRecorder.startRecording()
        showingTimer = true
        secondsElapsed = 0
        recordingTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.secondsElapsed += 1
        }
    }

    func stopRecording() {
        audioRecorder.stopRecording()
        recordingTimer?.invalidate()
        recordingTimer = nil
        showingTimer = false
        let recordedFileURL = audioRecorder.audioRecorder.url
        speechRecognizer.transcribeAudio(from: recordedFileURL) { transcription in
            DispatchQueue.main.async {
                if let transcription = transcription {
                    viewModel.messageText = transcription
                }
            }
        }
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
