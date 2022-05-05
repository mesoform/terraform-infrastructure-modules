#!/bin/bash
ls
aws ec2 describe-volumes --region us-east-1 --volume-ids vol-06d276a04a52eba30 > volume.json