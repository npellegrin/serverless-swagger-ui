import boto3
from flask import Flask, request

import awsgi
from blueprints import swagger_ui_blueprint

# Boto3 client for API export calls
boto3_api_client = boto3.client("apigateway")

# Flask app for service Lambda proxy requests
app = Flask(__name__)

# URL for exposing Swagger UI (without trailing '/')
# This must match the URL configured in API Gateway, without stage name
# Stage-aware behavior will be implemented into blueprint directly
SWAGGER_UI_EXTERNAL_PATH = '/api-docs'

# The URL of the Swagger JSON file
# This must point on the generated swagger definition from API Gateway export
SWAGGER_DEFINITION_URL = 'swagger.json'

# Call factory function to create our blueprint
swaggerui_blueprint = swagger_ui_blueprint(
    # Swagger UI static files will be mapped to '{swagger_ui_external_path}/dist/'
    SWAGGER_UI_EXTERNAL_PATH,
    SWAGGER_DEFINITION_URL,
    # Swagger UI config overrides
    # See: https://swagger.io/docs/open-source-tools/swagger-ui/usage/configuration/
    config={},
    # OAuth config, if required
    # See https://github.com/swagger-api/swagger-ui#oauth2-configuration .
    # oauth_config={
    #    'clientId': "your-client-id",
    #    'clientSecret': "your-client-secret-if-required",
    #    'realm': "your-realms",
    #    'appName': "your-app-name",
    #    'scopeSeparator': " ",
    #    'additionalQueryStringParams': {'test': "hello"}
    # }
)


@swaggerui_blueprint.route("/swagger.json")
def expose_swagger_definition():
    """ Expose Swagger definition for Swagger UI or any other
        software understanding the OpenAPI definition."""
    api_identifier = request.environ["awsgi.event"]["requestContext"]["apiId"]
    api_stage = request.environ["awsgi.event"]["requestContext"]["stage"]

    export = boto3_api_client.get_export(
        restApiId=api_identifier,
        stageName=api_stage,
        exportType="swagger",
        accepts="application/json",
    )

    return export["body"].read().decode('utf-8')


# Register Swagger UI blueprint
app.register_blueprint(swaggerui_blueprint)


def lambda_handler(event, context):
    """AWS lambda handler, serving Swagger UI"""

    # Use awsgi to pass AWS Lambda proxy request to Flask application
    # and convert result to AWS Lambda proxy response format
    return awsgi.response(app, event, context, base64_content_types={"image/png"})
