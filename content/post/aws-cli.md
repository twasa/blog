---
title: "Aws Cli"
date: 2017-09-11T15:52:27+08:00
tags: [ "AWS" ]
categories: [ "AWS" ]
draft: true
---

# AWS CLI referneces
## syntax
```
aws [options] \<command> \<subcommand> [\<subcommand> ...] [parameters]
options:
--region
--profile
--filters "Name=instance-state-name,Values=running"
--query
```


## create or modify profile
```
aws configure --profile PROFILE
aws configure set default.s3.signature_version s3v4
aws configure set profile.your_profile_name.s3.signature_version s3v4
```

## create key pairs
```
aws --profile PROFILE --region REGION ec2 create-key-pair --key-name KEYNAME
```

## create IAM users and permission
```
aws --profile PROFILE iam create-user --user-name USERNAME
aws --profile PROFILE iam create-access-key --user-name USERNAME
aws --profile PROFILE iam put-user-policy --user-name USERNAME --policy-name POLICYNAME --policy-document  file://POLICYDOCUMENT
aws --profile PROFILE iam get-server-certificate --server-certificate-name CERTNAME XXXX
```

## SES, SNS
```
- aws --profile PROFILE --region REGION ses verify-email-identity --email-address YOUR@MAIL.ADDR
- aws --profile PROFILE --region REGION sns create-topic --name TOPICNAME
- aws --profile PROFILE --region REGION ses set-identity-notification-topic --identity YOUR@MAIL.ADDR --notification-type [Bounce, Complaint, Delivery] --sns-topic arn:aws:sns:us-east-1:EXAMPLE65304:MyTopic
- aws --profile PROFILE --region REGION sns subscribe --topic-arn arn:aws:sns:us-east-1:EXAMPLE65304:MyTopic --protocol email --notification-endpoint YOUR@MAIL.ADDR
```

## DynamoDB
```
aws --profile PROFILE --region REGION s3api dynamodb create-table --table-name TABLENAME --cli-input-json  file://JSONFILE
```

## Create VPC, Subnet, internet gateway, route-table, security-group, and associate
```
- aws ec2 --profile PROFILE--region REGION create-vpc --cidr-block 10.10.0.0/16
- aws ec2 --profile PROFILE--region REGION create-tags â€“resources vpc-xxxx -tags Key=Name,Value=$ENV_$LOCATION_VPC01
- aws ec2 --profile PROFILE--region REGION modify-vpc-attribute --vpc-id vpc-xxxx --enable-dns-hostnames
- aws ec2 --profile PROFILE--region REGION create-subnet --vpc-id vpc-xxxx --cidr-block 10.10.1.0/24
- aws ec2 --profile PROFILE--region REGION create-tags â€“resources subnet-xxxx â€“tags Key=Name,Value=$ENV_$LOCATION_VPC01_10.10.1.0
- aws ec2 --profile PROFILE--region REGION create-internet-gateway
- aws ec2 --profile PROFILE--region REGION create-tags -resources igw-xxxx -tag Key=Name,Value=$ENV_$LOCATION_VPC01_GW01
- aws ec2 --profile PROFILE--region REGION attach-internet-gateway --internet-gateway-id igw-xxxx --vpc-id vpc-xxxx
- aws ec2 --profile PROFILE--region REGION create-route-table â€“vpc-id vpc-xxxx
- aws ec2 --profile PROFILE--region REGION create-route --route-table-id rtb-xxxx --destination-cidr-block 0.0.0.0/0 --gateway-id igw-xxxx
- aws ec2 --profile PROFILE--region REGION associate-route-table --route-table-id rtb-xxxx --subnet-id subnet-xxxx
- aws ec2 --profile PROFILE--region REGION create-security-group --group-name $ENV_$LOCATION_VPC01_SG01 --description $ENV_$LOCATION_VPC01_SG01
- aws ec2 --profile PROFILE--region REGION authorize-security-group-ingress --group-name MySecurityGroup --protocol tcp --port 22 --cidr 203.0.113.0/24
- aws ec2 --profile PROFILE--region REGION run-instances --image-id ami-xxxx --count 1 --instance-type m4.xlarge --key-name MyKeyPair --security-group-ids sg-xxxx --subnet-id subnet-xxxx
- aws ec2 --profile PROFILE--region REGION allocate-address
- aws ec2 --profile PROFILE--region REGION describe-instances --instance-id i-xxx --query 'Reservations[\*].Instances[\*].NetworkInterfaces[*].NetworkInterfaceId' --output text
- aws --profile mp ec2 describe-instances --region us-west-2 --filters "Name=instance-state-name,Values=running" --query "Reservations[*].Instances[*].[Tags[?Key=='Name'].Value,PublicIpAddress]" --output text
- aws ec2 --profile PROFILE--region REGION associate-address --instance-id i-xxx --public-ip xxxx --network-interface-id eni-xxxx
```

## S3
### list buckets
```
aws --profile PROFILE --region REGION s3api list-buckets
```

### create bucket    
```
aws --profile PROFILE s3api create-bucket --acl private --bucket qa-fw-ead98f12 --region REGION --create-bucket-configuration LocationConstraint=ap-northeast-1
```

### set bucket acl
```
aws --profile PROFILE --region REGION s3api put-bucket-acl --bucket qa-fw-ead98f12 --access-control-policy file://D:\workspace\Your\jsons\file.json
```


### enable bucket log
```
aws --profile PROFILE --region REGION s3api put-bucket-logging --bucket qa-fw-ead98f12 --bucket-logging-status file://D:\workspace\Your\jsons\file.json
```
### set bucket lifecycle
```
aws --profile PROFILE --region REGION s3api put-bucket-lifecycle-configuration --bucket qa-fw-ead98f12 --lifecycle-configuration  file://D:\workspace\Your\jsons\file.json
```

### create folders
```
aws --profile PROFILE --region eu-west-1 s3api put-object --bucket mp-eu-ead98f12 --key [8e15, dfa9, e94d, 487f, event]/
```

### upload file to bucket
```
aws --profile PROFILE --region REGION s3 cp FILEPATH/FILENAME s3://BUCKETNAME/FILENAME --acl public-read
```


### bucket policy for elb access logs, and IAM users
- rererence http://docs.aws.amazon.com/elasticloadbalancing/latest/classic/enable-access-logs.html

```
    {
      "Id": "Policy1429136655940",
      "Version": "2012-10-17",
      "Statement": [
        {
          "Sid": "Stmt1429136633762",
          "Action": [
            "s3:PutObject"
          ],
          "Effect": "Allow",
          "Resource": "arn:aws:s3:::BUCKETNAME/FOLDERNAME/AWSLogs/AWSACCOUNTID_OF_ELB/*",
          "Principal": {
            "AWS": [
              "ELBACCOUNTID"
            ]
          }
        }
      ]
    }
```

### for Cross-Account Access
- reference http://docs.aws.amazon.com/IAM/latest/UserGuide/tutorial_cross-account-with-roles.html

```
aws account A ID number 111111111111 (resources owner)
create a IAM role, Role Type = Role for Cross-Account Access, Provide access between AWS accounts you own, input another account ID, and Attach Policy, final copy Role ARN

aws account B ID number 222222222222 (resources accessor)
create a IAM Custom Policy for allow

{
  "Version": "2012-10-17",
  "Statement": {
    "Effect": "Allow",
    "Action": "sts:AssumeRole",
    "Resource": "arn:aws:iam::111111111111:role/RoleARN"
  }
}

create a IAM Custom Policy for deny
{
  "Version": "2012-10-17",
  "Statement": {
    "Effect": "Deny",
    "Action": "sts:AssumeRole",
    "Resource": "arn:aws:iam::111111111111:role/RoleARN"
  }
}

#Apply Allow Policy to resources access group, and apply Deny Policy to non-resources access group
```

## ELB(Classic Load Balancer)
### create
```
aws elb create-load-balancer --load-balancer-name my-load-balancer --listeners "Protocol=HTTP,LoadBalancerPort=80,InstanceProtocol=HTTP,InstancePort=80" --availability-zones us-west-2a us-west-2b

aws elb create-load-balancer --load-balancer-name my-load-balancer --listeners "Protocol=HTTP,LoadBalancerPort=80,InstanceProtocol=HTTP,InstancePort=80" "Protocol=HTTPS,LoadBalancerPort=443,InstanceProtocol=HTTP,InstancePort=80,SSLCertificateId=arn:aws:iam::123456789012:server-certificate/my-server-cert" --availability-zones us-west-2a us-west-2b
```

### modify attribute
```
aws elb modify-load-balancer-attributes --load-balancer-name XXXX --load-balancer-attributes CrossZoneLoadBalancing={Enabled=boolean},AccessLog={Enabled=boolean,S3BucketName=string,EmitInterval=integer,S3BucketPrefix=string},ConnectionDraining={Enabled=boolean,Timeout=integer},ConnectionSettings={IdleTimeout=integer},AdditionalAttributes=[{Key=string,Value=string},{Key=string,Value=string}]
```

## RDS
### create snapshot
```
aws --profile PROFILE --region REGION rds delete-db-instance --db-instance-identifier mp-op-rds --no-skip-final-snapshot --final-db-snapshot-identifier mp-op-rds-final-snapshot
```


### restore from snapshot
```
aws --profile PROFILE --region REGION rds restore-db-instance-from-db-snapshot --db-instance-identifier mp-op-rds --db-snapshot-identifier mp-op-rds-final-snapshot --db-instance-class db.m3.large --db-subnet-group-name mp-op-rds-subg --no-multi-az --no-publicly-accessible --no-auto-minor-version-upgrade
```


### wait rds available
```
aws --profile PROFILE --region REGION rds wait db-instance-available --db-instance-identifier mp-op-rds
```


### change parameter group
```
aws --profile PROFILE --region REGION rds modify-db-instance --db-instance-identifier RDSNAME --db-parameter-group-name PGNAME --vpc-security-group-ids SGID --apply-immediately)
```


### modify parameter group
```
- aws --profile PROFILE --region REGION rds modify-db-parameter-group --db-parameter-group-name PGNAME --cli-input-json
```


## Route53
### list hosted zones
```
aws --profile PROFILE --region REGION route53 list-hosted-zones
```


### get hosted zone info
```
aws --profile PROFILE --region REGION route53 get-hosted-zone --id "xxxxxxxxxxxx"
```


### list record sets of hosted zone
```
aws --profile PROFILE --region REGION route53 list-resource-record-sets --hosted-zone-id "xxxxxxxxxxxx"

aws --profile mp --region REGION route53 list-resource-record-sets --hosted-zone-id Z3FV870FH3DCS4 > "D:\workspace\MP\aws_r53_auto_before_dcd_rcd_modify.json"
aws --profile mp --region REGION route53 list-resource-record-sets --hosted-zone-id Z1L8DNQYY69L2Z > "D:\workspace\MP\aws_r53_local_before_dcd_rcd_modify.json"
```


### change resource record sets
```
aws --profile PROFILE --region REGION route53 change-resource-record-sets --hosted-zone-id "xxxxxxxxxxxx" --change-batch file://C:\awscli\route53\change-resource-record-sets.json

JSON Syntax:

{
  "Comment": "string",
  "Changes": [
    {
      "Action": "CREATE"|"DELETE"|"UPSERT",
      "ResourceRecordSet": {
        "Name": "string",
        "Type": "SOA"|"A"|"TXT"|"NS"|"CNAME"|"MX"|"NAPTR"|"PTR"|"SRV"|"SPF"|"AAAA",
        "SetIdentifier": "string",
        "Weight": long,
        "Region": "us-east-1"|"us-east-2"|"us-west-1"|"us-west-2"|"ca-central-1"|"eu-west-1"|"eu-west-2"|"eu-central-1"|"ap-southeast-1"|"ap-southeast-2"|"ap-northeast-1"|"ap-northeast-2"|"sa-east-1"|"cn-north-1"|"ap-south-1",
        "GeoLocation": {
          "ContinentCode": "string",
          "CountryCode": "string",
          "SubdivisionCode": "string"
        },
        "Failover": "PRIMARY"|"SECONDARY",
        "TTL": long,
        "ResourceRecords": [
          {
            "Value": "string"
          }
          ...
        ],
        "AliasTarget": {
          "HostedZoneId": "string",
          "DNSName": "string",
          "EvaluateTargetHealth": true|false
        },
        "HealthCheckId": "string",
        "TrafficPolicyInstanceId": "string"
      }
    }
    ...
  ]
}
```


## CloudWatch
### list-metrics
```
aws cloudwatch list-metrics --namespace "AWS/ELB"
#AWS Namespaces
http://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/aws-namespaces.html
```

### get-metrics-statistics
```
aws cloudwatch get-metric-statistics --metric-name CPUUtilization --start-time 2014-04-08T23:18:00 --end-time 2014-04-09T23:18:00 --period 3600 --namespace AWS/EC2 --statistics Maximum --dimensions Name=InstanceId,Value=i-abcdef
```

## decode-authorization-message

```
aws sts decode-authorization-message "MESSAGES"
```
