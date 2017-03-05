# assumerole

## Purpose
Assume role and get a temporary session token (for 1 hour). Useful for using tools like Terraform which require `AWS_SESSION_TOKEN` variable.

## Requirements
* bash! (i.e. Mac or Linux only)
* aws cli installed and configured (run `aws configure` to set default profile)
* [awsprofile](../awsprofile) configured

## Configuration
1. `alias assumerole=". PATH/TO/stsAssumeRole.sh"` to your `~/.bash_profile` _(this needs to be launched using the precending ". " to export the set vars into the terminal session, hence not just launching stsAssumeRole.sh directly)_
2. modify `PATH/TO/stsAssumeRole.sh` and modify 
```
IAMUSER=username
SESSIONNAME=profile name (e.g. gg20sandbox - use the name of the target account)
ROLEARN=arn:aws:iam::521234567825:role/PowerUserAccess

```
3. open a new terminal and run `assumerole`
