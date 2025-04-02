import boto3
import json
import os
def lambda_handler(event, context):
    # Parse ARN of non-compliant resource from Security Hub CWE
    rawBucketInfo = str(event['detail']['findings'][0]['Resources'][0]['Id'])
    findingId = str(event['detail']['findings'][0]['Id'])
    # import lambda function name from env vars
    lambdaFunctionName = os.environ['AWS_LAMBDA_FUNCTION_NAME']
    # Remove ARN string, create new variable
    noncompliantCTBucket = rawBucketInfo.replace("arn:aws:s3:::", "")
    # import SSM and SecHub clients
    securityhub = boto3.client('securityhub')
    ssm = boto3.client('ssm')
    try:
        removeS3PublicReadWrite = ssm.start_automation_execution(
            DocumentName='AWS-DisableS3BucketPublicReadWrite',
            DocumentVersion='1', # default
            Parameters={
                'S3BucketName': [ noncompliantCTBucket ]
            }
        )
        print(removeS3PublicReadWrite)
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
        print("SSM automation execution failed")
        raise