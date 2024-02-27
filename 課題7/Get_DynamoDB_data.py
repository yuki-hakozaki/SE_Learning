import boto3

# AWSの設定情報
AWS_REGION = 'ap-northeast-1'

# DynamoDBの設定情報
DYNAMO_TABLE_NAME = 'CTS-SampleTable'

def get_dynamodb_data():
    dynamo_client = boto3.client('dynamodb', region_name=AWS_REGION)
    response = dynamo_client.scan(TableName=DYNAMO_TABLE_NAME)

    # 結果を表示
    for item in response['Items']:
        print(item)

if __name__ == "__main__":
    get_dynamodb_data()
