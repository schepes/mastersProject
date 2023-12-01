import os
import unittest
from unittest.mock import patch, MagicMock, mock_open
from moto import mock_s3
from services.s3_manager import S3Manager
from botocore.exceptions import ClientError
import boto3


class TestS3Manager(unittest.TestCase):

    @mock_s3
    def setUp(self):
        """
        Set up the mock S3 environment.
        """
        self.bucket_name = "backendstack-recrutrainingrecordingscdec32a0-1v5pwhxvdnv4x"
        self.s3 = boto3.resource('s3', region_name='us-east-1')
        self.s3.create_bucket(Bucket=self.bucket_name)
        self.s3_manager = S3Manager()

        # Validate the bucket was created
        try:
            self.s3.meta.client.head_bucket(Bucket=self.bucket_name)
        except ClientError:
            self.fail("Bucket was not created successfully.")


    @mock_s3
    def test_upload_file_success(self):
        """
        Test successful file upload.
        """
        bucket = self.s3.Bucket(self.bucket_name)
        self.assertTrue(bucket.creation_date is not None)
        mock_file_path = "mock_file.txt"
        # Ensure the read_data is a bytes object, as it would be for binary file content.
        mock_file_data = b"file content"

        # Mock open and os.path.getsize to simulate file being present and having a size.
        with patch("builtins.open", mock_open(read_data=mock_file_data)) as mock_file:
            with patch("os.path.getsize", return_value=len(mock_file_data)):
                upload_result = self.s3_manager.upload_file(mock_file_path)
                # Assert upload was successful
                self.assertTrue(upload_result)
                # Assert the file was called to be opened
                mock_file.assert_called_with(mock_file_path, 'rb')

    @mock_s3
    def test_upload_file_fail(self):
        """
        Test file upload failure due to ClientError.
        """
        mock_file_path = "mock_file.txt"
        # Mock the client's upload_file method to throw a ClientError
        with patch.object(self.s3_manager.s3_client, 'upload_file',
                          side_effect=ClientError({'Error': {}}, 'upload_file')):
            upload_result = self.s3_manager.upload_file(mock_file_path)
            # Assert upload was not successful
            self.assertFalse(upload_result)


if __name__ == '__main__':
    unittest.main()
