#!/bin/bash
FILTER="Name=product-code,Values=aw0evgkw8e5c1q413zgy5pjce" # CentOS Linux 7 x86_64 HVM - https://wiki.centos.org/Cloud/AWS
OUTPUT=$1
# OWNERID=679593333241 # all of the "marketplace"
aws sts get-caller-identity > /dev/null

get_regions(){
	aws ec2 describe-regions \
		--out text | awk '{print $NF}'
}

find_ami(){
	AWS_DEFAULT_REGION=$REGION
	AMI=$(aws ec2 describe-images \
		--filters "$FILTER" \
		--query "Images[].ImageId" \
		--out text | awk '{print $NF}')
}

print_ami_default(){
	echo -e "$REGION	$AMI"
}

print_ami_json(){
	echo -e "    \"$REGION\" : { \"HVM64\" : \"$AMI\"},"
}

print_ami_yaml(){
	echo -e "        $REGION:\n            HVM64: $AMI"
}

print_ami_tf(){
	echo -e "    $REGION = \"$AMI\""
}

if [[ "$OUTPUT" == "" ]]
	then for REGION in $(get_regions); do find_ami; print_ami_default; done
fi
if [[ "$OUTPUT" == "json" ]]
	then echo -e "[json CloudFormation]\n\"Mappings\" : {\n  \"RegionMap\" : {"
	for REGION in $(get_regions); do find_ami; print_ami_json; done
	echo -e "<<REMOVE LAST COMMA AND THIS LINE>>"
	echo -e "  }\n}"
fi
if [[ "$OUTPUT" == "yaml" ]]
	then echo -e "[yaml CloudFormation]\nMappings:\n    AWSRegionArch2AMI:"
	for REGION in $(get_regions); do find_ami; print_ami_yaml; done
fi
if [[ "$OUTPUT" == "tf" ]]
	then echo -e "[terraform]\nvariable \"aws_amis\" {\n  default = {"
	for REGION in $(get_regions); do find_ami; print_ami_tf; done
	echo -e "  }\n}"
fi
