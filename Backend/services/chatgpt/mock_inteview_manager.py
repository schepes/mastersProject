# Backend/services/mock_interview_manager.py

from .chatgpt_service import ChatGPTService

class MockInterviewManager:
    """
    A class to manage mock interviews using ChatGPT.
    """

    def __init__(self):
        """
        Initialize the MockInterviewManager.
        """
        self.chatgpt_service = ChatGPTService()
        self.interview_context = ""
        self.questions = []
        self.answers = []

    def start_interview(self):
        """
        Starts the mock interview by asking for the position and getting questions.
        """
        position = input("What position are you applying for? ")
        self.interview_context += f"Interview for the position of {position}. "

        # Generate interview questions
        prompt = self.interview_context + "Generate 5 relevant interview questions."
        self.questions = self.chatgpt_service.get_response(prompt).split('\n')

        # Start the interview with the first question
        self.ask_next_question()

    def ask_next_question(self):
        """
        Asks the next interview question.
        """
        if self.questions:
            question = self.questions.pop(0)
            print(question)
            return question
        else:
            self.analyze_answers()
            return None

    def answer_question(self, answer):
        """
        Stores the interviewee's answer and proceeds to the next question.
        """
        self.answers.append(answer)
        self.ask_next_question()

    def analyze_answers(self):
        """
        Analyzes the answers given during the interview and provides feedback.
        """
        analysis_prompt = self.interview_context + "\n".join(
            f"Q: {q}\nA: {a}" for q, a in zip(self.questions, self.answers)
        ) + "\n\nProvide detailed feedback on these answers."
        feedback = self.chatgpt_service.get_response(analysis_prompt)
        print("Feedback from ChatGPT:\n", feedback)

def main():
    interview_manager = MockInterviewManager()
    interview_manager.start_interview()

    # Loop to handle the interview questions and answers
    for _ in range(5):  # Adjust the number based on the number of questions generated
        answer = input("Your answer: ")
        next_question = interview_manager.answer_question(answer)
        if not next_question:  # Break the loop if there are no more questions
            break

if __name__ == "__main__":
    main()