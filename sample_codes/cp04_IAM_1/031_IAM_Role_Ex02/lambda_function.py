import os
import json
import boto3

def lambda_handler(event, context):
    # 環境変数からS3バケット名を取得
    s3_bucket = os.environ.get('S3_BUCKET_NAME')
    if not s3_bucket:
        raise ValueError("Environment variable 'S3_BUCKET_NAME' is not set.")

    s3_key = os.environ.get('S3_OBJECT_KEY_NAME')
    if not s3_key:
        raise ValueError("Environment variable 'S3_OBJECT_KEY_NAME' is not set.")

    # S3クライアントを作成
    s3_client = boto3.client('s3')

    # S3からファイルの中身を取得
    response = s3_client.get_object(Bucket=s3_bucket, Key=s3_key)
    content = response['Body'].read().decode('utf-8')

    # 必要に応じてレスポンスを返す
    return {
        'statusCode': 200,
        'body': json.dumps({
            'message': f"File '{s3_key}' successfully read from '{s3_bucket}'.",
            'content': json.loads(content)
        }, ensure_ascii=False)
    }
