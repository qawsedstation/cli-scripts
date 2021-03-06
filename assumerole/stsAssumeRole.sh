#!/bin/bash

IAMUSER=username # IAM username
SESSIONNAME=devtest # give this the same name as the profile configured in ~/.aws/config
ROLEARN=arn:aws:iam::123456123456:role/AdminAccess # Role to assume (as per profile in ~/.aws/config)

AWSIDACCOUNT=987654123456 # AWS Account which hosts the IAM user login

awsprofile default # see README.md - needs to use the profile configured for the ID account (to assume roles)
DURATION=3600 #seconds - max 1 hour, min 15 min

MFASERIAL=arn:aws:iam::$AWSIDACCOUNT:mfa/$IAMUSER

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
	export AWS_ACCESS_KEY_ID=`cat /tmp/get_token.tmp | grep CREDENTIALS | awk '{print $2}'` #; echo "AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID"
	export AWS_SESSION_TOKEN=`cat /tmp/get_token.tmp | grep CREDENTIALS | awk '{print $5}'` #; echo "AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN"
	export AWS_SECRET_ACCESS_KEY=`cat /tmp/get_token.tmp | grep CREDENTIALS | awk '{print $4}'` #; echo "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY"
	echo -e "\nSession expires at: `cat /tmp/get_token.tmp | grep CREDENTIALS | awk '{print $3}'`\n"
	env | grep AWS
	echo ""
	rm -f /tmp/get_token.tmp
};export_vars
