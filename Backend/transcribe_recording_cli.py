import boto3
import time
from services.s3_manager import S3Manager
from services.transcribe_manager import TranscribeManager
from services.chatgpt.chatgpt_feedback_manager import ChatGPTFeedbackManager

def list_recordings(s3_manager):
    """
    List all recordings in the S3 bucket.
    """
    s3 = boto3.client('s3')
    response = s3.list_objects_v2(Bucket=s3_manager.bucket_name)

    if 'Contents' in response:
        return [item['Key'] for item in response['Contents']]
    else:
        return []

def main():
    # Initialize managers
    s3_manager = S3Manager()
    transcribe_manager = TranscribeManager()

    # List recordings
    recordings = list_recordings(s3_manager)
    print("Recordings in the bucket:")
    for recording in recordings:
        print(recording)

    # User selects a recording
    selected_recording = input("Enter the name of a recording to transcribe: ")
    if selected_recording not in recordings:
        print("Recording not found.")
        return

    # Transcribe the selected recording
    timestamp = int(time.time())
    job_name = "Transcription_" + selected_recording.replace('.mp3', '').replace('/', '_') + str(timestamp)
    transcription_text = transcribe_manager.transcribe_audio(
        f's3://{s3_manager.bucket_name}/{selected_recording}',
        job_name
    )

    if transcription_text:
        print("Transcribed Text:\n", transcription_text)
        # Ask user to proceed with ChatGPT feedback
        proceed = input("Would you like to get feedback from ChatGPT? (y/n): ").strip().lower()
        if proceed == 'y':
            chatgpt_manager = ChatGPTFeedbackManager()
            feedback = chatgpt_manager.get_feedback(transcription_text)
            print("Feedback from ChatGPT:\n", feedback)
        else:
            print("Feedback request cancelled.")
    else:
        print("Transcription failed or is still in progress.")

if __name__ == '__main__':
    main()
