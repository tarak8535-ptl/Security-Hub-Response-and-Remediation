import boto3
import json
import datetime
import os
def lambda_handler(event, context):
    nonRotatedKeyUser = str(event['detail']['findings'][0]['Resources'][0]['Details']['Other']['userName'])
    findingId = str(event['detail']['findings'][0]['Id'])
    lambdaFunctionName = os.environ['AWS_LAMBDA_FUNCTION_NAME']
    
    iam = boto3.client('iam')
    securityhub = boto3.client('securityhub')
    iam_resource = boto3.resource('iam')
    try:
        todaysDatetime = datetime.datetime.now(datetime.timezone.utc)
        paginator = iam.get_paginator('list_access_keys')
        for response in paginator.paginate(UserName=nonRotatedKeyUser):
            for keyMetadata in response['AccessKeyMetadata']:
                accessKeyId = str(keyMetadata['AccessKeyId'])
                keyAgeFinder = todaysDatetime - keyMetadata['CreateDate']
                if keyAgeFinder <= datetime.timedelta(days=90):
                    print("Access key: " + accessKeyId + " is compliant")
                else:
                    print("Access key over 90 days old found!")
                    access_key = iam_resource.AccessKey(nonRotatedKeyUser, accessKeyId)
                    access_key.deactivate()
                    get_KeyStatus = iam.list_access_keys(UserName=nonRotatedKeyUser,MaxItems=20)
                    for keys in get_KeyStatus['AccessKeyMetadata']:
                        access_KeyId = str(keys['AccessKeyId'])
                        access_KeyStatus = str(keys['Status'])
                        
                        if access_KeyId == accessKeyId:
                            if access_KeyStatus == 'Inactive':
                                print('Access key over 90 days old deactivated!')
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
                                            'Text': 'Non compliant access key was deactivated sucessfully!',
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