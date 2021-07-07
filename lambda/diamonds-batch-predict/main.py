import os
import io
import logging
import boto3

logger = logging.getLogger()
logger.setLevel("INFO")

sagemaker = boto3.client("runtime.sagemaker")
sagemaker_endpoint = "diamonds-predictor-endpoint"

s3 = boto3.client("s3")

def predict(event, context):
    logger.info(f"Input data:\n{event}")

    for record in event["Records"]:
        # Get bucket and file path
        try:
            bucket = record["s3"]["bucket"]["name"]
            key = record["s3"]["object"]["key"]
            logger.info(f"Input file: {bucket}/{key}")
        except:
            logger.error(f"Invalid input format.")
            continue
            
        # Read the object from S3
        try:
            object_data = s3.get_object(Bucket=bucket, Key=key)['Body'].read().decode()
            logger.info(f"Input file read.")
        except:
            logger.error(f"Input read fail.")
            continue
        
        # Call the endpoint
        try:
            response = sagemaker.invoke_endpoint(EndpointName=sagemaker_endpoint, ContentType="text/csv", Accept="text/csv", Body=object_data)
            predictions = [int(x) for x in response['Body'].read().decode().split(",")]
            logger.info(f"Predictions retrieved.")
        except Exception as e:
            logger.error(f"Sagemaker invocation error. {e}")
            continue
        
        # Prepare the output file
        output_buffer = "\n".join([f"{predictions[i]},{line}" for i, line in enumerate(object_data.split("\n"))])

        # Write the output to S3
        try:
            s3.put_object(Bucket=bucket, Key=f"output/{os.path.basename(key)}", Body=output_buffer.encode("utf-8"))
            logger.error(f"Output write successful.")
        except:
            logger.error(f"Output write failed.")
            continue