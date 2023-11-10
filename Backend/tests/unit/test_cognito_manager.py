import pytest
from moto import mock_cognitoidp
import sys
import os

sys.path.append(os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))))

from backend.cognito_manager import CognitoManager

@pytest.fixture
def cognito_manager():
    # Mock AWS Cognito
    with mock_cognitoidp():
        yield CognitoManager(region="us-east-1")

def test_register_user(cognito_manager):
    # Test user registration
    # Assuming successful registration returns a specific response
    expected_response = {"some_key": "some_value"}  # Replace with expected response format
    response = cognito_manager.register_user("testuser", "password123", "testuser@example.com")
    assert response == expected_response

def test_login_user(cognito_manager):
    # Test user login
    # Assuming successful login returns a specific response
    expected_response = {"some_key": "some_value"}  # Replace with expected login response format
    response = cognito_manager.login_user("testuser", "password123")
    print('hello')
    assert response == expected_response
