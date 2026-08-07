#!/bin/bash

## Creating and naming a S3 bucket ##
 aws sts get-caller-identity
 aws s3api create-bucket \
 --bucket capstone-web-bucket \
 --region us-east-1

 ## Configuring the S3 bucket for static website hosting ##
aws s3 website \
 s3://capstone-web-bucket \
--index-document index.html

## Syncing the local files to the S3 bucket ##
aws s3 sync . \
s3://capstone-web-bucket \
--exclude ".git/*"

## Verifying the S3 bucket website configuration ##
aws s3api get-bucket-website \
--bucket capstone-web-bucket

## Disabling the S3 bucket public access block ##
aws s3api put-public-access-block \
--bucket capstone-web-bucket \
--public-access-block-configuration '{
    "BlockPublicAcls": false,
    "IgnorePublicAcls": false,
    "BlockPublicPolicy": false,
    "RestrictPublicBuckets": false
}'

## Setting the S3 bucket policy to allow public read access ##
aws s3api put-bucket-policy \
--bucket capstone-web-bucket \
--policy '{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadForStaticWebsite",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::capstone-web-bucket/*"
        }
    ]
}'

## Getting the S3 bucket website URL ##
aws s3api get-bucket-website \
--bucket capstone-web-bucket \
--query "WebsiteConfiguration.IndexDocument.Suffix" \
--output text   

