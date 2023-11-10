import boto3
from botocore.exceptions import ClientError

##TODO test properly once we have UI

class CognitoManager:
    def __init__(self, region):
        """
        Initializes the CognitoManager with the specified AWS region.

        Args:
            region (str): The AWS region where the Cognito User Pool is located.
        """
        self.client = boto3.client('cognito-idp', region_name=region)
        self.user_pool_id = 'us-east-1_IU0nufsCj'
        self.client_id = '6hhoeb1dqt878qipvodh295l08'

    def register_user(self, username, password, email):
        """
        Registers a new user in the AWS Cognito User Pool.

        Args:
            username (str): The username for the new user.
            password (str): The password for the new user.
            email (str): The email address of the new user.

        Returns:
            dict: The response from the Cognito service, including user details on success, or error information on failure.
        """
        try:
            response = self.client.sign_up(
                ClientId=self.client_id,
                Username=username,
                Password=password,
                UserAttributes=[
                    {
                        'Name': 'email',
                        'Value': email
                    },
                ]
            )
            return response
        except ClientError as e:
            return e.response

    def login_user(self, username, password):
        """
        Authenticates a user against the AWS Cognito User Pool.

        Args:
            username (str): The username of the user.
            password (str): The password of the user.

        Returns:
            dict: The response from the Cognito service, including authentication details on success, or error information on failure.
        """
        try:
            response = self.client.initiate_auth(
                ClientId=self.client_id,
                AuthFlow='USER_PASSWORD_AUTH',
                AuthParameters={
                    'USERNAME': username,
                    'PASSWORD': password
                }
            )
            return response
        except ClientError as e:
            return e.response
