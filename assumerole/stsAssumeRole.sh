#!/bin/bash
IAMUSER=gg.jake
SESSIONNAME=ggdestest
ROLEARN=arn:aws:iam::528557666825:role/SuperAdminAccess

awsprofile default

AWSIDACCOUNT=604083106117
MFASERIAL=arn:aws:iam::$AWSIDACCOUNT:mfa/$IAMUSER
DURATION=3600 #seconds

# awsprofile gghub; aws sts assume-role --role-arn arn:aws:iam::528557666825:role/SuperAdminAccess --role-session-name SAggdestest --serial-number arn:aws:iam::604083106117:mfa/$IAMUSER --token-code 459350
 # Using AWS profile gghub in region eu-west-1
 # {
 #     "AssumedRoleUser": {
 #         "AssumedRoleId": "AROAJVIWVVVGTPKVFJMGI:SAggdestest",
 #         "Arn": "arn:aws:sts::528557666825:assumed-role/SuperAdminAccess/SAggdestest"
 #     },
 #     "Credentials": {
 #         "SecretAccessKey": "m/HCyVJJ9qthXeLLAypaAkM8l6dpEvIIotLKcrzv",
 #         "SessionToken": "FQoDYXdzEHUaDLq45aoEObz/fW8cCSLOATkiz0K042LOKENH8Eg6RucXGBPSY+cdoKl506mFDabMQu2XNb/N0p5BnxdOtCHHxxG2ETNDgHSqbaKLYQ/rtYQ+Eh6E5re1u/WGqk8/HYkRyHgJt2s+i++e0Xs0xGoJVM0AoEqGiMuPi0UXZtlxAdPyqbmb+kTFHC/V5w6juU2o7VSG1sVukyyaF4JQyUVx+mzXEV4Cn3DQcRnC6iS7MgxevK1etlsmmsabKYQbxhvBVcWsHHRag1bqRL7Lovzoa0HQDXb7t9YCBokDl7CiKJPy2sUF",
 #         "Expiration": "2017-03-01T13:05:39Z",
 #         "AccessKeyId": "ASIAJQGO4RIO2LX3OTSQ"
 #     }
 # }
 # AWS_ACCESS_KEY_ID="ASIAJQGO4RIO2LX3OTSQ"
 # AWS_SECRET_ACCESS_KEY="m/HCyVJJ9qthXeLLAypaAkM8l6dpEvIIotLKcrzv"
 # AWS_SESSION_TOKEN="FQoDYXdzEHUaDLq45aoEObz/fW8cCSLOATkiz0K042LOKENH8Eg6RucXGBPSY+cdoKl506mFDabMQu2XNb/N0p5BnxdOtCHHxxG2ETNDgHSqbaKLYQ/rtYQ+Eh6E5re1u/WGqk8/HYkRyHgJt2s+i++e0Xs0xGoJVM0AoEqGiMuPi0UXZtlxAdPyqbmb+kTFHC/V5w6juU2o7VSG1sVukyyaF4JQyUVx+mzXEV4Cn3DQcRnC6iS7MgxevK1etlsmmsabKYQbxhvBVcWsHHRag1bqRL7Lovzoa0HQDXb7t9YCBokDl7CiKJPy2sUF"

_unset(){
	unset AWS_ACCESS_KEY_ID
	unset AWS_SESSION_TOKEN
	unset AWS_SECRET_ACCESS_KEY
	unset TOKEN
};_unset

get_token(){
	read -p "Enter MFA token: " TOKEN
	aws sts assume-role \
		--role-arn $ROLEARN \
		--role-session-name $SESSIONNAME \
		--serial-number $MFASERIAL \
		--duration-seconds $DURATION \
		--out text \
		--token-code $TOKEN \
		 > /tmp/get_token.tmp
};get_token

export_vars(){
	# echo ""
	export AWS_ACCESS_KEY_ID=`cat /tmp/get_token.tmp | grep CREDENTIALS | awk '{print $2}'` #; echo "AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID"
	export AWS_SESSION_TOKEN=`cat /tmp/get_token.tmp | grep CREDENTIALS | awk '{print $5}'` #; echo "AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN"
	export AWS_SECRET_ACCESS_KEY=`cat /tmp/get_token.tmp | grep CREDENTIALS | awk '{print $4}'` #; echo "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY"
	echo -e "\nSession expires at: `cat /tmp/get_token.tmp | grep CREDENTIALS | awk '{print $3}'`\n"
	env | grep AWS
	echo ""
	rm -f /tmp/get_token.tmp
	# cat /tmp/get_token.tmp
};export_vars
