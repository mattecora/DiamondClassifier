import logging
import boto3
import json

logger = logging.getLogger()
logger.setLevel("INFO")

sagemaker = boto3.client("runtime.sagemaker")
sagemaker_endpoint = "diamonds-predict-endpoint"

columns = ["cut", "color", "clarity", "price", "x", "y", "z", "table"]

def predict(event, context):
    logger.info(f"Input data:\n{event}")

    # Parse input data:
    try:
        json_data = json.loads(event["body"])
    except:
        logger.error("Invalid input format.")
        return {
            "statusCode": 400,
            "headers": {},
            "body": json.dumps({
                "request_id": context.aws_request_id,
                "request_body": event["body"],
                "message": "Invalid input format."
            }),
            "isBase64Encoded": False
        }

    # Format data as CSV
    try:
        if type(json_data) != list:
            raise
        csv_data = "\n".join([",".join([str(float(record[col])) for col in columns]) for record in json_data])
        logger.info(f"CSV-converted data:\n{csv_data}")
    except:
        logger.error("Malformed input data.")
        return {
            "statusCode": 400,
            "headers": {},
            "body": json.dumps({
                "request_id": context.aws_request_id,
                "request_body": json_data,
                "message": "Malformed input data."
            }),
            "isBase64Encoded": False
        }
    
    # Call the endpoint and get the prediction (TODO)
    try:
        predictions = [0] * len(json_data)
        logger.info(f"Predicted classes:\n{predictions}")
    except:
        logger.error("Sagemaker invocation error.")
        return {
            "statusCode": 500,
            "headers": {},
            "body": json.dumps({
                "request_id": context.aws_request_id,
                "request_body": json_data,
                "message": "Sagemaker invocation error."
            }),
            "isBase64Encoded": False
        }

    # Return the prediction
    return {
        "statusCode": 200,
        "headers": {},
        "body": json.dumps({
            "request_id": context.aws_request_id,
            "predictions": [
                { "label": predictions[i], "body": record }
                for i, record in enumerate(json_data)
            ]
        }),
        "isBase64Encoded": False
    }