import logging
import json
import boto3
import urllib3
import uuid
import time
import base64

logger = logging.getLogger()
logger.setLevel("INFO")

http = urllib3.PoolManager()
api_gateway = boto3.client("apigatewayv2")
api_gateway_endpoint = api_gateway.get_api(ApiId="diamonds-prediction-api")["ApiEndpoint"] + "/test/predict-diamonds"

dynamodb = boto3.client("dynamodb")
dynamodb_table_name = "diamonds-predictions"

def consume(event, context):
    logger.info(f"Input data:\n{event}")

    # Parse Kinesis records
    try:
        records = [json.loads(base64.b64decode(record_enc["kinesis"]["data"]).decode("utf-8")) for record_enc in event["Records"]]
        logger.info(f"Decoded input:\n{records}")
    except:
        logger.error(f"Input decoding failed.")
        return
    
    # Perform a POST request on the prediction endpoint
    try:
        request = http.request("POST", api_gateway_endpoint, body=json.dumps(records), headers={
            "Content-Type": "application/json",
            "X-Api-Key": "xxx"
        })
        predictions = json.loads(request.data)["predictions"]
        logger.info(f"Predicted classes:\n{predictions}")
    except:
        logger.error(f"Endpoint invocation failed.")
        return
    
    # Write results to DynamoDB
    try:
        # Prepare the dict for DynamoDB
        dynamodb_records = [{**{
            "id": { "S": str(uuid.uuid4()) },
            "timestamp": { "N": time.time() },
            "label": { "N": str(prediction["label"]) }
        }, **{
            c: { "N": str(prediction["body"][c]) } for c in prediction["body"]
        }} for prediction in predictions]
            
        # Put the item in DynamoDB
        dynamodb.batch_write_item(RequestItems={ dynamodb_table_name: [{ "PutRequest": { "Item": record } } for record in dynamodb_records] })
    except:
        logger.error(f"DynamoDB insertion failed.")
        return