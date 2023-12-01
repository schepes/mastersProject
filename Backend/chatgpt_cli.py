# Backend/chatgpt_cli.py

import argparse
from services.chatgpt.chatgpt_service import ChatGPTService

def main():
    parser = argparse.ArgumentParser(description="Interact with ChatGPT API.")
    parser.add_argument('prompt', type=str, help="Prompt to send to ChatGPT")
    args = parser.parse_args()

    service = ChatGPTService()
    response = service.get_response(args.prompt)
    print(response)

if __name__ == "__main__":
    main()
