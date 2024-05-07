# Mock Interview App

## Overview
The Mock Interview app is a Swift-based application designed to simulate mock interviews for users preparing for job interviews. It leverages Firebase for backend services including authentication and data storage, and integrates with OpenAI's GPT models to generate dynamic interview questions and feedback.

## Features
- **User Authentication**: Secure login and registration functionality.
- **Real-time Chat Interface**: Users can engage in a chat-like interface where they receive and respond to interview questions.
- **AI-Driven Interaction**: Utilizes OpenAI's API to generate interview questions and analyze responses.
- **Profile Management**: Users can manage their profiles and settings.

## Technologies Used
- **Swift**: Primary programming language for app development.
- **Firebase**: Used for authentication, data storage, and hosting.
- **OpenAI API**: Powers the AI-based mock interview functionalities.
- **SwiftUI**: Used for building the user interface.

## Setup and Installation
1. **Clone the repository:**
```bash
git clone https://github.com/yourusername/MockInterview.git
```
2. **Install dependencies:**
   Navigate to the project directory and install the required CocoaPods.
```bash
pod install
```
3. **Firebase Configuration:**
   Ensure that `GoogleService-Info.plist` from Firebase is added to the project.

4. **OpenAI API Key:**
   Set your OpenAI API key in `Constants.swift`.
```swift
// UIForRecruTraining/Constants.swift
enum Constants{
static let openAIApiKey = "your-openai-api-key"
}
```

4.1 **Optional API Key Configuration**
In the `ChatViewModel2.swift` file, you can uncomment and comment these lines, so that the user will have to input API Key instead of using th API key under constants.
```swift
let openAI = OpenAI(apiToken: "\(Constants.openAIApiKey)")
// let openAI = OpenAI(apiToken: "apiKey")
```


5. **Run the application:**
   Open the `.xcworkspace` file in Xcode and run the project.

## Usage
- **Login/Signup**: Start by creating an account or logging in.
- **Start an Interview**: Choose the type of interview you want to simulate.
- **Interact with AI**: Respond to the AI-generated questions and receive feedback.

## Contributing
Contributions are welcome! Please fork the repository and submit pull requests with your proposed changes.

## License
This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.

## Contact
For support or queries, reach out via [email](mailto:support@mockinterview.com).
