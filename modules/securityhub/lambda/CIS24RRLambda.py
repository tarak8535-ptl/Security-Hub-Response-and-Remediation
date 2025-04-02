import boto3
import json
import time
import os
def lambda_handler(event, context):
    # Parse name of non-compliant resource from Security Hub CWE
    noncomplaintCloudTrail = str(event['detail']['findings'][0]['Resources'][0]['Details']['Other']['name'])
    findingId = str(event['detail']['findings'][0]['Id'])
    # import lambda runtime vars - imported session token to add to log group name to enforce uniqueness
    lambdaFunctionName = os.environ['AWS_LAMBDA_FUNCTION_NAME']
    lambdaFunctionSeshToken = os.environ['AWS_SESSION_TOKEN']              
    # Set name for Cloudwatch logs group
    cloudwatchLogGroup = 'CloudTrail/CIS2-4-' + noncomplaintCloudTrail + lambdaFunctionSeshToken
    # Import CloudTrail to CloudWatch logging IAM Role
    cloudtrailLoggingArn = os.environ['CLOUDTRAIL_CW_LOGGING_ROLE_ARN']              
    # set boto3 clients
    securityhub = boto3.client('securityhub')
    cwl = boto3.client('logs')
    cloudtrail = boto3.client('cloudtrail')              
    # create cloudwatch log group
    try:
        createGroup = cwl.create_log_group(
        logGroupName=cloudwatchLogGroup,
        )
        print(createGroup)
    except Exception as e:
        print(e)
        raise
    # wait for CWL group to propagate    
    time.sleep(2)              
    # get CWL ARN
    try:
        describeGroup = cwl.describe_log_groups(logGroupNamePrefix=cloudwatchLogGroup)
        cloudwatchArn = str(describeGroup['logGroups'][0]['arn'])
    except Exception as e:
        print(e)
        raise          
    # update non-compliant Trail
    try:
        updateCloudtrail = cloudtrail.update_trail(
        Name=noncomplaintCloudTrail,
        CloudWatchLogsLogGroupArn=cloudwatchArn,
        CloudWatchLogsRoleArn=cloudtrailLoggingArn
        )
        print(updateCloudtrail)
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
                    'Text': 'CloudWatch logging is now enabled for CloudTrail trail ' + noncomplaintCloudTrail,
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