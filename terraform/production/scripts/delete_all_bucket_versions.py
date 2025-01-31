import boto3
import argparse

# Parse the bucket name from command line arguments
parser = argparse.ArgumentParser(description="Delete all object versions in a specific S3 bucket")
parser.add_argument('bucket_name', type=str, help='The name of the S3 bucket')
args = parser.parse_args()

BUCKET = args.bucket_name

# Initialize the S3 resource
s3 = boto3.resource('s3')
bucket = s3.Bucket(BUCKET)

# Delete all object versions in the bucket
for version in bucket.object_versions.all():
    print(f"Deleting object version: {version.object_key} (Version: {version.id})")
    version.delete()

print(f"All object versions deleted from bucket: {BUCKET}")
