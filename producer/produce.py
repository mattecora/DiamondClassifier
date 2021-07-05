import boto3
import json
import pandas as pd

from time import sleep
from datetime import datetime

n = 5
total = 0

kinesis = boto3.client("kinesis")
kinesis_stream_name = "diamonds-data-stream"

s3 = boto3.client("s3")
s3_bucket_name = "aws-project-politomaster-sagemaker-data"
s3_file_path = "preprocess/prep_test.csv"

# Read test data from S3
test_object = s3.get_object(Bucket=s3_bucket_name, Key=s3_file_path)
test_data = pd.read_csv(test_object.get("Body")).drop("carat_class", axis=1)

while True:
    # Sample five records from the dataframe
    rows = test_data.sample(n=n).to_dict(orient="records")

    # Put records to Kinesis
    kinesis.put_records(
        Records=[
            {
                "Data": json.dumps(r).encode("utf-8"),
                "PartitionKey": "0"
            }
            for r in rows
        ],
        StreamName=kinesis_stream_name
    )

    total += n
    print(f"{datetime.now().isoformat()} - Records written: {n} - Total: {total}")

    # Sleep for five seconds
    sleep(5)