import boto3
import json
import os
def lambda_handler(event, context):
    # Parse ARN of non-compliant resource from Security Hub CWE
    ctBucket = str(event['detail']['findings'][0]['Resources'][0]['Id'])
    findingId = str(event['detail']['findings'][0]['Id'])
    # import lambda function name from runtime env
    lambdaFunctionName = os.environ['AWS_LAMBDA_FUNCTION_NAME']
    # Remove ARN string, create new variable
    formattedCTBucket = ctBucket.replace("arn:aws:s3:::", "")
    # import Lambda env var for Access Logging Bucket
    accessLoggingBucket = os.environ['ACCESS_LOGGING_BUCKET']              
    # import SSM boto3 client
    securityhub = boto3.client('securityhub')
    ssm = boto3.client('ssm')              
    #excute automation with ConfigureS3BucketLogging Document
    try:
        response = ssm.start_automation_execution(
            DocumentName='AWS-ConfigureS3BucketLogging',
            DocumentVersion='1',
            Parameters={
                'BucketName': [ formattedCTBucket ],
                'GrantedPermission': [ 'READ' ],
                'GranteeType': [ 'Group' ],
                'GranteeUri': [ 'http://acs.amazonaws.com/groups/s3/LogDelivery' ], ## Must Use URI, fails with Canonical Group Id
                'TargetPrefix' : [ 'cloudtrail/' ],
                'TargetBucket': [ accessLoggingBucket ]
            }
        )
        print(response)
        try:
            response = securityhub.update_findings(
                Filters={
                    'Id': [
                        {
                            'Value': findingId,
                            'Comparison': 'EQUALS'
                        }
                    ]
                },
                Note={
                    'Text': 'Systems Manager Automation document to remove public access was successfully invoked. Refer to Automation results to determine efficacy',
                    'UpdatedBy': lambdaFunctionName
                },
                RecordState='ACTIVE'
            )
            print(response)
        except Exception as e:
            print(e)
            raise
    except Exception as e:
        print(e)
        raise