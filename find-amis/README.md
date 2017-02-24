# [amzn-ami.sh](amzn-ami.sh) - find Amazon Linux AMIs in all regions

**NOTE:** _This assumes you're using ***[`awsprofile`](../awsprofile)*** to set the environment variables_

**modify the filter string in the script:**

`FILTER="Name=name,Values=amzn-ami-minimal-hvm*2016.09.1.2017*ebs"`

## [amzn-nat-ami.sh](amzn-nat-ami.sh) - find Amazon Linux NAT AMIs in all regions
`FILTER="Name=name,Values=amzn-ami-vpc-nat-hvm*2016.09.1.2017*ebs"`

**amzn-ami.sh**

```
$ ./amzn-ami.sh
ap-south-1	ami-57daac38
eu-west-2	ami-54949e30
eu-west-1	ami-b7f3aed1
...

```

**amzn-ami.sh yaml**

```
$ ./amzn-ami.sh yaml
[yaml CloudFormation]
Mappings:
  RegionMap:
    ap-south-1:
      "64": "ami-57daac38"
    eu-west-2:
      "64": "ami-54949e30"
...

```
**amzn-ami.sh json**
```
$ ./amzn-ami.sh json
[json CloudFormation]
"Mappings" : {
  "RegionMap" : {
    "ap-south-1" : { "64" : "ami-57daac38"},
    "eu-west-2" : { "64" : "ami-54949e30"},
...
<<REMOVE LAST COMMA AND THIS LINE>>
  }
}
```
_this one needs work_

**amzn-ami.sh tf**

```
$ ./amzn-ami.sh tf
[terraform]
variable "aws_amis" {
  default = {
    ap-south-1 = "ami-57daac38"
    eu-west-2 = "ami-54949e30"
...
    us-west-2 = "ami-6e70cf0e"
  }
}
```


