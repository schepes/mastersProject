from aws_cdk import core as cdk
from constructs import Construct

class BackendStack(cdk.Stack): 

    def __init__(self, scope: Construct, construct_id: str, **kwargs) -> None:
        super().__init__(scope, construct_id, **kwargs)

        print ('hello')
        # The code that defines your stack goes here

        # example resource
        # queue = sqs.Queue(
        #     self, "BackendQueue",
        #     visibility_timeout=Duration.seconds(300),
        # )

