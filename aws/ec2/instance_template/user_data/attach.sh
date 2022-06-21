#!/bin/bash

REGION=$(curl http://169.254.169.254/latest/meta-data/placement/region)
INSTANCE=$(curl http://169.254.169.254/latest/meta-data/instance-id)
aws ec2 describe-volumes --region $REGION --filters "Name=tag:Name,Values=swarm_node*" > EBS.txt
readarray -t VOLUMES < <(cat EBS.txt | jq '.Volumes[] | {Id: .VolumeId, Name: .Tags[] | select(.Key=="Device_name") .Value}' | jq '.Id' | sed 's/^\"//;s/\"$//')
readarray -t NAMES < <(cat EBS.txt | jq '.Volumes[] | {Id: .VolumeId, Name: .Tags[] | select(.Key=="Device_name") .Value}' | jq '.Name' | sed 's/^\"//;s/\"$//')

LEN=${#VOLUMES[@]}

for (( i=0; i<$LEN; i++ ))
do
 echo "${VOLUMES[$i]}"
 aws ec2 attach-volume --volume-id ${VOLUMES[$i]} --instance-id $INSTANCE --device ${NAMES[$i]} --region $REGION
done
