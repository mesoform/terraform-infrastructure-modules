# Cloud Identity Management

## Getting set-up
### Required APIs
- cloudidentity.googleapis.com
- resourcemanager.googleapis.com
- iam.googleapis.com
- cloudresourcemanager.googleapis.com

### Service account configuration
Create a service account with the following settings
* add Domain-wide delegation of authority
* configure OAuth consent screen
    * set OAuth consent to internal
* add the service account's client ID to API access in http://admin.google.com (Security > API Controls > Manage Domain Wide Delegation)
    * give it these scopes:
        * https://www.googleapis.com/auth/admin.directory.user,
        * https://www.googleapis.com/auth/admin.directory.group
* add the service account email address to Groups Admin in Cloud Identity 
  (Account > Admin roles > Groups Admin > Admins > Assign Service Accounts)
* download key to be used by applications. I.e. gcloud or Terraform

### Cloud Identity details
* get your Customer ID and save it for later
    * `gcloud organizations list`
    * Google Admin console https://admin.google.com > Account Settings

## How to use

```terraform
variable google_directory_customer_id {
  type = string
}
variable google_directory_group_id {
  type = string
  default = "a-development@mesoform.com"
}

module cloud_identity_group {
  source = "../../../../gcp/resource-manager/cloud_identity_group"
  google_directory_customer_id = var.google_directory_customer_id
  google_directory_group_id = var.google_directory_group_id
  google_directory_group_name = "testing managing CI Groups"
}

module cloud_identity_group_members {
  source = "../../../../gcp/resource-manager/cloud_identity_group_membership"
  google_directory_group_id = module.cloud_identity_group.google_groups_uid
  google_directory_group_members = {
    "mr-wendal@mesoform.com": ["MANAGER", "MEMBER"]
    "mr-dole@mesoform.com": ["MEMBER"]
  }
}

```
```shell
terraform init
GCLOUD_KEYFILE_JSON=/path/to/key-you-downloaded-above.json terraform apply -auto-approve
```
Pass in the customer ID when prompted

## Some other notes on Cloud Identity Groups. 

Roles assigned to users in groups must include MEMBER as a minimum. I.e.  OWNERs must also be MEMBERs

Once an owner is added to a group, there must always be one. So, when deleting members from groups there must be at an
 error could be returned like: `Cannot remove the OWNER role in membership 'groups/00xvir7l0m3ajlz/memberships/110310809372019845450'
 because it's the last OWNER role in the Google Groups`

When users don't exist, and so can't be added as members, a confusing message can be returned which looks like it's
 stating that the group doesn't exist: `Error: Error creating GroupMembership: googleapi: Error 403: Error(2028):
 Permission denied for resource groups/01y810tw0iun7dw (or it may not exist).`