import boto3
import json
import time
import os
def lambda_handler(event, context):
    # Parse ARN of non-compliant resource from Security Hub CWE
    noncompliantCMK = str(event['detail']['findings'][0]['Resources'][0]['Id'])              
    # Remove ARN string, create new variable
    findingId = str(event['detail']['findings'][0]['Id'])
    # import lambda function name from env vars
    lambdaFunctionName = os.environ['AWS_LAMBDA_FUNCTION_NAME']
    formattedCMK = noncompliantCMK.replace("AWS::KMS::Key:", "")              
    # Import KMS & SecHub Clients
    kms = boto3.client('kms')
    securityhub = boto3.client('securityhub')        
    # Rotate KMS Key
    try:
        rotate = kms.enable_key_rotation(KeyId=formattedCMK)
        time.sleep(3)
    except Exception as e:
        print(e)
        raise
    try:    
        confirmRotate = kms.get_key_rotation_status(KeyId=formattedCMK)
        rotationStatus = str(confirmRotate['KeyRotationEnabled'])
        if rotationStatus == 'True':
            print("KMS CMK Rotation Successfully Enabled!")
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
                        'Text': 'Key Rotation successfully enabled for KMS key ' + formattedCMK,
                        'UpdatedBy': lambdaFunctionName
                    },
                    RecordState='ACTIVE'
                )
                print(response)
            except Exception as e:
                print(e)
                raise
        else:
            print("KMS CMK Rotation Failed! Please troubleshoot manually!")
    except Exception as e:
        print(e)
        raise