# ECR wrapper scripts
## Prerequisites

### awsprofile

## ecr

```
Usage:
 ./ecr [action]

  Actions:
    login    - Docker login
    repos    - List ECR repos
    list     - List docker images in ECR (same as "images")
    images   - List docker images in ECR
    logout   - Logout from Docker
    profiles - List configured profiles
    whoami   - Current AWS CLI profile
```

## create_ecr

**Creates ECR repo**

*Make sure `test-ecrpullANDpushpull.json` is updated with relevant account number, etc.*

```
Usage:
 ./create_ecr [reponame] [json policydoc]
```
