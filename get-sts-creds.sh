#!/bin/bash
#If there are existing environment variables set, this can cause issues so we unset them first
unset AWS_SESSION_TOKEN
unset AWS_SECRET_ACCESS_KEY
unset AWS_ACCESS_KEY_ID

#Set the serial number of your MFA token
MFA="arn:aws:iam::ACCOUNT_ID:mfa/USER"

#Get the code from the MFA device
echo "Please enter MFA code"
read code

#Get the credentials from AWS and store the response in a variable
creds=`aws sts get-session-token --serial-number $MFA --token-code $code`

#Parse the response into separate variables
access_key=`echo $creds | jq .Credentials.AccessKeyId`
secret_key=`echo $creds | jq .Credentials.SecretAccessKey`
session_token=`echo $creds | jq .Credentials.SessionToken`

#Display the keys to the user for reference/confirm proper working
echo $access_key
echo $secret_key
echo $session_token

#Set the appropriate environment variables -- The sed statement is needed to strip the quotation marks
export AWS_ACCESS_KEY_ID=`echo $access_key | sed -e 's/^"//' -e 's/"$//'`
export AWS_SECRET_ACCESS_KEY=`echo $secret_key | sed -e 's/^"//' -e 's/"$//'`
export AWS_SESSION_TOKEN=`echo $session_token | sed -e 's/^"//' -e 's/"$//'`