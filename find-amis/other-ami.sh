#!/bin/bash
# FILTER="Name=name,Values=CIS Amazon Linux Benchmark v2.0.0.1 - Level 1-6a859cee-81c9-40fd-8aac-dbc8738b8690-ami-72edc965.3"
FILTER="Name=owner-id,Values=679593333241"
OUTPUT=$1
OWNERID=679593333241 # CIS

get_regions(){
	aws ec2 describe-regions --out text | awk '{print $NF}'
}

find_ami(){
	AWS_DEFAULT_REGION=$REGION
	AMI=$(aws ec2 describe-images --owners self 679593333241 --filters "$FILTER" --query "Images[].ImageId" --out text | awk '{print $NF}')
}

print_ami_default(){
	echo -e "$REGION	$AMI"
}

print_ami_json(){
	echo -e "    \"$REGION\" : { \"64\" : \"$AMI\"},"
}

print_ami_yaml(){
	echo -e "    $REGION:\n      \"64\": \"$AMI\""
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
	then echo -e "[yaml CloudFormation]\nMappings:\n  RegionMap:"
	for REGION in $(get_regions); do find_ami; print_ami_yaml; done
fi
if [[ "$OUTPUT" == "tf" ]]
	then echo -e "[terraform]\nvariable \"aws_amis\" {\n  default = {"
	for REGION in $(get_regions); do find_ami; print_ami_tf; done
	echo -e "  }\n}"
fi
