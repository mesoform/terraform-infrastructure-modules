The presented module allows you to deploy two Auto Scaling groups with a different set of parameters - blue and green.
The AMI for an instance can be set explicitly - using the ami_id variable, or by specifying the owner and AMI name in the ami_owner and ami_name variables.

Together with Auto Scaling groups, a VPC is created that connects to ASG as well as a custom security group.
security group parameters:
 - port range;
 - the source (inbound rules) for the traffic to allow.

VPC options:
 - public subnet CIDR

Together with ASG, EBS volumes are created: one persistent - for data and another stateful - for saving the state of the system.
Options:
 - availability zone;
 - size;
 - encryption;
 - disk type;
 - device name - block volume name when joining an instance

In case of failure of an instance included in the ASG, the script specified in user data will connect the existing persistent and stateful EBS volumes to the newly created instance. The belonging of an EBS volume to a specific type and instance is indicated in the tags.