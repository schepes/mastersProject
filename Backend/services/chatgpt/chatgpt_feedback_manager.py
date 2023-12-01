from .chatgpt_service import ChatGPTService

class ChatGPTFeedbackManager:
    """
    A class to manage interactions with ChatGPT for feedback.
    """

    def __init__(self):
        """
        Initialize the ChatGPTFeedbackManager.
        """
        self.chatgpt_service = ChatGPTService()

    def get_feedback(self, transcribed_text):
        """
        Sends the transcribed text to ChatGPT and retrieves feedback.

        :param transcribed_text: The transcribed text from an audio recording.
        :return: Feedback from ChatGPT.
        """
        prompt = f"Please revise this audio and give feedback on how to make the content more clear when presenting to an audience:\n\n{transcribed_text}"
        return self.chatgpt_service.get_response(prompt)
