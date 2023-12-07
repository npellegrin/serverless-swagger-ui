"""Sample of a Python lambda handler for your API"""


def lambda_handler(event, context):
    """Lambda response with AWS_PROXY integration"""
    return {
        "statusCode": 200,
        "body": "Hello from Lambda!"
    }
