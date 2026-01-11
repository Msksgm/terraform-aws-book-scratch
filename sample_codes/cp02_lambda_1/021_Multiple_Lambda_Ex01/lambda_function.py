import requests

def lambda_handler(event, context):
    global_ip = requests.get('https://ipinfo.io/ip').text

    return {
        'statusCode': 200,
        'body': global_ip
    }
