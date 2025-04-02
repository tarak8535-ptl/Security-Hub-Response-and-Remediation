import boto3
import json
import time
import os
def lambda_handler(event, context):
    # Grab non-logged VPC ID from Security Hub finding
    noncompliantVPC = str(event['detail']['findings'][0]['Resources'][0]['Details']['Other']['vpcId'])
    findingId = str(event['detail']['findings'][0]['Id'])
    # import lambda runtime vars
    lambdaFunctionName = os.environ['AWS_LAMBDA_FUNCTION_NAME']
    lambdaFunctionSeshToken = os.environ['AWS_SESSION_TOKEN']                
    # Get Flow Logs Role ARN from env vars
    DeliverLogsPermissionArn = os.environ['flowLogRoleARN']              
    # Import boto3 clients
    cwl = boto3.client('logs')
    ec2 = boto3.client('ec2')
    securityhub = boto3.client('securityhub')              
    # set dynamic variable for CW Log Group for VPC Flow Logs
    vpcFlowLogGroup = "VPCFlowLogs/" + noncompliantVPC + lambdaFunctionSeshToken         
    # create cloudwatch log group
    try:
        create_log_grp = cwl.create_log_group(logGroupName=vpcFlowLogGroup)
    except Exception as e:
        print(e)
        raise              
    # wait for CWL creation to propagate
    time.sleep(3)              
    # create VPC Flow Logging
    try:
        enableFlowlogs = ec2.create_flow_logs(
        DryRun=False,
        DeliverLogsPermissionArn=DeliverLogsPermissionArn,
        LogGroupName=vpcFlowLogGroup,
        ResourceIds=[ noncompliantVPC ],
        ResourceType='VPC',
        TrafficType='REJECT',
        LogDestinationType='cloud-watch-logs'
        )
        print(enableFlowlogs)
    except Exception as e:
        print(e)
        raise
    # wait for Flow Log creation to propogate
    time.sleep(2)
    # searches for flow log status, filtered on unique CW Log Group created earlier
    try:
        confirmFlowlogs = ec2.describe_flow_logs(
        DryRun=False,
        Filters=[
            {
                'Name': 'log-group-name',
                'Values': [ vpcFlowLogGroup ]
            },
        ]
        )
        flowStatus = str(confirmFlowlogs['FlowLogs'][0]['FlowLogStatus'])
        if flowStatus == 'ACTIVE':
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
                        'Text': 'Flow logging is now enabled for VPC ' + noncompliantVPC,
                        'UpdatedBy': lambdaFunctionName
                    },
                    RecordState='ACTIVE'
                )
                print(response)
            except Exception as e:
                print(e)
                raise
        else:
            print('Enabling VPC flow logging failed! Remediate manually')
            return 1
    except Exception as e:
        print(e)
        raise