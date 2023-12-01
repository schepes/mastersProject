import boto3
from botocore.exceptions import ClientError
import os

class S3Manager:
    def __init__(self):
        self.bucket_name = "backendstack-recrutrainingrecordingscdec32a0-1v5pwhxvdnv4x"
        self.s3_client = boto3.client('s3')

    def upload_file(self, file_path, object_name=None):
        """
        Upload a file to an S3 bucket

        :param file_path: File to upload
        :param object_name: S3 object name. If not specified, only the file name is used
        :return: True if file was uploaded, else False
        """
        if object_name is None:
            object_name = os.path.basename(file_path)  # Extracts file name from file_path

        try:
            self.s3_client.upload_file(file_path, self.bucket_name, object_name)
            print(f"File {file_path} uploaded successfully to {self.bucket_name}.")
            return True
        except ClientError as e:
            print(f"An error occurred: {e}")
            return False
