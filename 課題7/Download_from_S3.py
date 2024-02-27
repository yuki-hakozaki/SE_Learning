import boto3

# AWSの設定情報
AWS_REGION = 'ap-northeast-1'

# S3の設定情報
S3_BUCKET_NAME = 'cts-cloudformation-test-bucket'
S3_OBJECT_KEY = 'sample.txt'  # S3のファイルパス
LOCAL_PATH = '/home/ec2-user/sample.txt'  # EC2内の保存先のファイルパス

def download_from_s3():
    s3_client = boto3.client('s3', region_name=AWS_REGION)
    s3_client.download_file(S3_BUCKET_NAME, S3_OBJECT_KEY, LOCAL_PATH)
    print(f"Downloaded {S3_OBJECT_KEY} from S3 to {LOCAL_PATH}")

if __name__ == "__main__":
    download_from_s3()
