# Google Cloud Run 
Cloud run manages the deployment of scalable containerized serverless applications applications [(Documentation)](https://cloud.google.com/run)
### gcp_cloudrun.yml
#### Prerequisites
* If creating a new project your must have an existing billing account ID to specify in the `billing_account` setting
* Cloud run retrieves images hosted in Container Registry or Artifact Registry.  
If creating a project, there must be an existing image that you have access to (public/global),
which is specified with the `image_uri` value in `gcp_clourun.yml`.
If using an existing project you can use an image hosted within the projects Container Registry or Artifact Registy,
provided you have the correct IAM permissions to access it.  

#### Cloud run specs
| Key | Type | Required | Description | Default |
|:----|:----:|:--------:|:------------|:-------:|
| `project_id` | string | true | The ID of the project to be used for the service | none |
| `location_id` | string | true | Location ID of the project used| none |
| `create_google_project` | bool | false | Whether to create a new project for services| false |
| `billing_account` | string | true if `create_google_project` is true | The alphanumeric ID of the billing account this project belongs to. | none |
| `create_artiface_registry` | bool | false | whether to create an artifact registry repository| false |
| `name` | string | true | Name for Cloud Run Service, unique within cloud run region and cannot be updated | none |
| `image_uri` | string | true | URI of where the image to be hosted is contained | none |
| `auth` | bool | true | Whether authentication is required to access service| false |
| `environment_vars` | map | false | Any environment variables to include as for image. Key is the name of the variable and value is the string it represents| none |
| `iam` | map | true if `auth = true` | If authentication is required to access the service, include the iam block| false |
| `iam.binding` | map | true if `replace_policy = true`, otherwise include if you want to update bindings | A block of roles and the members who will be assigned the roles. Keys should be the role, and the value for each key is the list of members assigned that role| none |
| `iam.bindings.[role].members` | list | true if `iam.bindings` has values| Members who will be assigned the role for the iam policy [details](#IAM Usage)| none |
| `iam.replace_policy` | bool | false | Sets IAM policy, replacing any existing policy attached| true |
| `iam.binding` | bool | false | Updates IAM policy to grant role to specified members| false |
| `iam.add_member` | map | false | Adds a member who can can use a specified policy. If a binding policy exists the policy for `add_member` must be different. This must include the keys `role` and `member`, with `member` following the same format as an item in `iam.members`| none |
| `domain_name` | string | false | Custom domain name for service, domain must already exist| none |
| `traffic` | list | false | list of traffic allocation configs across revisions| none |
| `traffic.-.percent` | map | true if `traffic.-` exists | The percentage of traffic for revision, if `revision_name` is not specified latest revision is used| none |
| `traffic.-.revision_name` | string | false | The name of the revision the traffic should be allocated to | 'latest_revision' is set to true by default |

#### IAM Usage
##### Policy/Member Settings
Setting `replace_policy=true` defines the whole policy and will replace any policy attatched to the cloudrun service defined.
If this is an initial deployment with no previous IAM policies set, `replace_policy` should be set to `true` and all role bindings required should be defined in `bindings`.
If there is an existing policy which you want to update, not replace, set `replace_policy` to `false` and include one role in `bindings` to update.
Similarly, if there are existing role bindings, which you would like to add a member to, use `add_member` to assign that role to the member without replacing members already assigned to that role.  
**NOTE:** Cannot have `add_member` if `replace_policy = true`, but can have `add_member` if both `replace_policy = false` and `bindings` has a value as long as they are not set for the same role.  

##### Member Definition
`iam.members` is a list of members in the form `{member_type}:{member}` which must be one of ([more info](https://www.terraform.io/docs/providers/google/r/cloud_run_service_iam.html#member-members)):
* `"allUsers:"`
* `"allAuthenticatedUsers:"`
* `"user:{emailid}"`
* `"serviceAccount:{emailid}"`
* `"group:{emailid}"`
* `"domain:{domain}"`

More information can be found in the terraform [documentation](https://www.terraform.io/docs/providers/google/r/cloud_run_service_iam.html).

#### Example
```yaml
project_id: <id>
location_id: "europe-west1"
create_google_project: true
create_artifact_registry: true

components:
  specs:
    default:
      name: default
      containers:
        image: location-docker.pkg.dev/project-id/repository/image
      environment_vars:
        'EG': 'something'
        'EG2': 'something-else'
      metadata:
        annotations:
          "run.googleapis.com/client-name": "terraform"  
      auth: true
      iam:
        replace_policy: true
        bindings:
          #Here 'viewer' is the role which the members are assigned to
          'viewer':
            members:
              - "user:user@example.com"
              - "allAuthenticatedUsers:"
          'admin':
            members:
              - "user:admin@example.com"
        add_member:
          role: 'admin'
          member: 'user: admin@example.com'
      domain_name: "domain.com"
      #Use hyphens to separate traffic configurations, making a list of configurations
      traffic:
        -
          percent: 25
        -
         percent: 75
         revision_name: "revision"

```