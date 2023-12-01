# Backend/services/chatgpt/chatgpt_service.py

import openai
import os

class ChatGPTService:
    def __init__(self):
        """
        Initialize the ChatGPT service with the necessary API key.
        """
        self.api_key = os.getenv('OPENAI_API_KEY')
        if not self.api_key:
            raise ValueError("No OPENAI_API_KEY environment variable set.")
        openai.api_key = self.api_key

    def get_response(self, prompt, max_tokens=150):
        """
        Send a prompt to the OpenAI API and return the response.
        """
        try:
            response = openai.Completion.create(
                engine="text-davinci-003",
                prompt=prompt,
                max_tokens=max_tokens
            )
            return response.choices[0].text.strip()
        except openai.error.OpenAIError as e:
            # Handle OpenAI specific errors
            raise e
        except Exception as e:
            # Handle other exceptions
            raise e
