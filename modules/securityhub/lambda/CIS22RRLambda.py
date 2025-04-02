import boto3
import json
import os
def lambda_handler(event, context):
    # parse non-compliant trail from Security Hub finding
    noncompliantTrail = str(event['detail']['findings'][0]['Resources'][0]['Details']['Other']['name'])
    findingId = str(event['detail']['findings'][0]['Id'])
    # import lambda function name from env vars
    lambdaFunctionName = os.environ['AWS_LAMBDA_FUNCTION_NAME']
    # import boto3 clients for CT & SH
    cloudtrail = boto3.client('cloudtrail')
    securityhub = boto3.client('securityhub')             
    # turn on cloudtrail log file validation
    try:
        response = cloudtrail.update_trail(Name=noncompliantTrail,EnableLogFileValidation=True)
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
                    'Text': 'Re-enabled Log File Validation sucessfully!',
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
        print("Enabling log file validation has failed! Please remediate manually!")
        raise