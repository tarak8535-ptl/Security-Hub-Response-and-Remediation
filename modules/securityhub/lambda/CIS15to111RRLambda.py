import boto3
def lambda_handler(event, context):
    try:
        iam = boto3.client('iam')
        response = iam.update_account_password_policy(
            MinimumPasswordLength=14,
            RequireSymbols=True,
            RequireNumbers=True,
            RequireUppercaseCharacters=True,
            RequireLowercaseCharacters=True,
            AllowUsersToChangePassword=True,
            MaxPasswordAge=90,
            PasswordReusePrevention=24,
            HardExpiry=True
            )
        print(response)
        print("IAM Password Policy Updated")      
    except Exception as e:
        print(e)
        raise