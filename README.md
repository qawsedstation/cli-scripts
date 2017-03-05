# cli-scripts
A collection of scripts (e.g. bash, aws cli, terraform, etc).

## Scripts
### awsprofile
[awsprofile](awsprofile) and [_setAWSenv.sh](awsprofile): script to set the profile for your terminal session. 

Include alias `awsprofile` in `~/.bash_profile`.

### assumerole
[assumerole](assumerole) and [stsAssumeRole.sh](assumerole): script to to assume role and get a temporary session token (for 1 hour). 

Include alias `assumerole` in `~/.bash_profile`.

### find-amis
[find-amis](find-amis): find AMIs in all regions _(Amzn Linux and Amzn Linux NAT)_

### keygen
[keygen](keygen): Script to generate a set of SSH keys with a passphrase, outputting to `~/.ssh/{KEYID}[.pub]`
