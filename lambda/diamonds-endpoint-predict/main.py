import logging
import boto3

logger = logging.getLogger()
logger.setLevel("INFO")

sagemaker = boto3.client("runtime.sagemaker")
sagemaker_endpoint = "diamonds-predict-endpoint"

columns = ["cut", "color", "clarity", "price", "x", "y", "z", "table"]

def predict(event, context):
    logger.info(f"Input data:\n{event}")

    # Format data as CSV
    try:
        csv_data = "\n".join([",".join([float(record[col]) for col in columns]) for record in event])
        logger.info(f"CSV-converted data:\n{csv_data}")
    except:
        logger.error("Invalid input format.")
        return {
            "status": 400,
            "request_id": context.aws_request_id,
            "message": "Invalid input format.",
            "body": event
        }
    
    # Call the endpoint and get the prediction (TODO)
    try:
        predictions = [0] * len(event)
        logger.info(f"Predicted classes:\n{predictions}")
    except:
        logger.error("Sagemaker invocation error.")
        return {
            "status": 500,
            "request_id": context.aws_request_id,
            "message": "Sagemaker invocation error.",
            "body": event
        }

    # Return the prediction
    return {
        "status": 200,
        "request_id": context.aws_request_id,
        "predictions": [
            { "label": predictions[i], "body": record }
            for i, record in enumerate(event)
        ]
    }