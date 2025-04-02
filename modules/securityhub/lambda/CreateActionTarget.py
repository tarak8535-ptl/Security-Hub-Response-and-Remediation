import boto3
import cfnresponse
import os
def lambda_handler(event, context):
    try:
        properties = event['ResourceProperties']
        region = os.environ['AWS_REGION']
        client = boto3.client('securityhub', region_name=region)
        responseData = {}
        if event['RequestType'] == 'Create':
            response = client.create_action_target(
                Name=properties['Name'],
                Description=properties['Description'],
                Id=properties['Id']
            )
            responseData['Arn'] = response['ActionTargetArn']
        elif event['RequestType'] == 'Delete':
            account_id = context.invoked_function_arn.split(":")[4]
            client.delete_action_target(
                ActionTargetArn=f"arn:aws:securityhub:{region}:{account_id}:action/custom/{properties['Id']}"
            )
        cfnresponse.send(event, context, cfnresponse.SUCCESS, responseData)
    except Exception as e:
        print(e)
        cfnresponse.send(event, context, cfnresponse.FAILED, {})