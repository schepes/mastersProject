import boto3
import time
import requests

class TranscribeManager:
    """
    A class to manage interactions with AWS Transcribe.
    """

    def __init__(self):
        self.transcribe_client = boto3.client('transcribe')

    def transcribe_audio(self, audio_file_uri, job_name, language_code='en-US'):
        """
        Starts an AWS Transcribe job to transcribe the given audio file.

        :param audio_file_uri: The URI of the audio file in S3 to be transcribed.
        :param job_name: A unique name for the transcription job.
        :param language_code: Language code for the transcription (default is 'en-US').
        :return: Transcription text as a string if the job is completed successfully, else None.
        """
        self.transcribe_client.start_transcription_job(
            TranscriptionJobName=job_name,
            Media={'MediaFileUri': audio_file_uri},
            MediaFormat='mp3',  # Adjust according to your audio file format
            LanguageCode=language_code
        )

        while True:
            status = self.transcribe_client.get_transcription_job(TranscriptionJobName=job_name)
            if status['TranscriptionJob']['TranscriptionJobStatus'] in ['COMPLETED', 'FAILED']:
                break
            time.sleep(5)  # Poll every 5 seconds

        if status['TranscriptionJob']['TranscriptionJobStatus'] == 'COMPLETED':
            transcript_uri = status['TranscriptionJob']['Transcript']['TranscriptFileUri']
            return self._fetch_transcript(transcript_uri)

        return None

    def _fetch_transcript(self, transcript_uri):
        """
        Fetches and extracts the transcription text from the given URI.

        :param transcript_uri: URI of the transcription result.
        :return: Transcribed text.
        """
        response = requests.get(transcript_uri)
        transcript = response.json()
        return transcript.get('results', {}).get('transcripts', [{}])[0].get('transcript', '')
