import aws_cdk as cdk
from aws_cdk import aws_s3 as s3
from constructs import Construct

class BackendStack(cdk.Stack):

    def __init__(self, scope: Construct, construct_id: str, **kwargs) -> None:
        super().__init__(scope, construct_id, **kwargs)

        # S3 Bucket creation
        self.bucket = s3.Bucket(self,
                                "RecruTrainingRecordings",
                                versioned=True,
                                removal_policy=cdk.RemovalPolicy.DESTROY)


