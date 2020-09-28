# Multi-Cloud Platform Module
## Contents
[Information](#Information)  
[Structure](#Structure)     
[MMCF](#MMCF)     
[project.yml](#projectyml)      
[gcp_ae.yml](#gcp_aeyml)    
[gcp_cloudrun.yml](#gcp_cloudrunyml)  
[Contributing](#Contributing)  
[License](#License)

## Information
Converter module for transforming MMCF (Mesoform Multi-Cloud Configuration Format) YAML into values
 for deploying to given target platform

## Structure
Each version of your application/service (AS) is defined in corresponding set of YAML configuration 
 files. As a minimum, your AS will require two files: project.yaml which contains some basic 
 configuration about your project, like the version of MCF to use; and another file containing the 
 target platform-specific configuration (e.g. gcp_ae.yml for Google App Engine). These files act as 
 a deployment description and define things like scaling, runtime settings, AS configuration and 
 other resource settings for the specific target platform.

If your application is made up of a number of microservices, you can structure such Component AS 
 (CAS) source code files and resources into sub-directories. Then, in the MMCF file, the deployment
 configuration for each CAS each will have its own definition in the `specs` section (described
 below). For example,

```
mesoform-service/
    L common.yml
    L gcp_ae.yml
    L micro-service1/
    |     L src/
    |     L resources/
    L micro-service2/
    |     L __init__.py
    |     L resources
``` 

Specifications for different target platforms can be found below 

## MMCF
MMCF is a YAML-based configuration allowing for simple mapping of platform APIs for deploying 
 applications. It follows the YAML 1.2 specification. For example, YAML anchors can be used to 
 reference values from other fields. For example, if you wanted `service` to be the same as name, 
 would write:

```yamlex
name: &name ecat-admin
service: *name
```

Reused anchors overwrite previous values. I.e. when anchors are repeated, the value of the last
 found anchor will be used.

For example, with the configuration:

```yamlex
components:
  common:
    env_variables:
      'env': dev
    threadsafe: True
    name: &name common-name
  specs:
    app1:
      name: &name ecat-admin
      runtime: custom
      env: flex
      service: *name
```

`service` will evaluate to `ecat-admin`

The following sections describe how to use MMCF for different target platforms. In each section, any
 required settings are stated so. Everything else is optional. Any defaults that are set within 
 MMCF are stated for each individual setting but this doesn't mean that you may not get some default
 set by the target platform. All expected settings, with their defaults from MMCF and the target
 platform will be output. Refer to the target platform's documentation for specifics

### project.yml

| Key | Type | Required | Description | Default |
|:----|:----:|:--------:|:------------|:-------:|
| `mcf_version` | string | false | version of MCF to use. | `1.0` |
| `name` | string | true | Name of the project. If you want to reference this in later configuration, it must meet the minimum requirements of the target platform(s) being deployed to. For example, Google App Engine requires that many IDs/names must be 1-63 characters long, and comply with RFC1035. Specifically, the name must be 1-63 characters long and match the regular expression [a-z]\([-a-z0-9]*[a-z0-9])?. The first character must be a lowercase letter, and all following characters (except for the last character) must be a dash, lowercase letter, or digit. The last character must be a lowercase letter or digit. | none |
| `version` | string | false | deployment version of your application/service. Version must contain only lowercase letters, numbers, dashes (-), underscores (_), and dots (.). Spaces are not allowed, and dashes, underscores and dots cannot be consecutive (e.g. "1..2" or "1.\_2") and cannot be at the beginning or end (e.g. "-1.2" or "1.2\_") | none |
| `labels` | map | false | a collection of keys and values to represent labels required for your deployment. | none |

Example:

```yamlex
mcf_version: "1.0"
name: &name "mesoform-frontend"
version: &deployment_version "1"
labels: &project_labels
  billing: central
  name: *name
```

### gcp_ae.yml
#### Prerequisites
##### IAM permission
* If creating a project from scratch, you must have a seed project on Google Cloud Platform that
 will be used as the build project and as a place for identity and access management. "Cloud 
 Resource Manager", "App Engine Admin, and "Cloud Billing" APIs need to be enabled on the 
 project. Even if you are running the deployment from a remote machine, you will need a service 
 account and key from this project.
 
* As a minimum, the account performing the deployment will need some roles on the project being 
 deployed to. If you are creating the project from scratch, then these will come with roles/owner
    * App Engine Admin
    * Cloud Build Service Account
    * Service Usage Admin
    * Storage Admin
    * Project IAM Admin

* Other roles when managing the whole project set-up are
    * roles/resourcemanager.folderViewer on the folder that you want to create the project in; or
     roles/resourcemanager.organizationViewer on the organization
    * roles/resourcemanager.projectCreator on the organization or folder
    * roles/billing.user on the organization
    * roles/storage.admin on GAE project
 
* If creating a new project, the account performing the deployment also needs project creator role;
 Project Billing Manager and either organization viewer role or folder viewer role
 
* You may need to download a service account key and set an environment variable if not being ran
 from within Google Cloud 
    * `export GOOGLE_CLOUD_KEYFILE_JSON=/path/to/my-key.json`
    * `export GOOGLE_APPLICATION_CREDENTIALS=/path/to/my-key.json`

 
#### Google App Engine basic configuration

| Key | Type | Required | Description | Default |
|:----|:----:|:--------:|:------------|:-------:|
| `project_id` | string | true | The GCP project identifier. https://cloud.google.com/resource-manager/reference/rest/v1/projects#Project | none | 
| `project_name` | string | false | more descriptive and human understandable identifier for the project. | value of `project_id` |
| `create_google_project` | boolean | false | whether or not to create a new project with the details provided. implies the project will be deleted with the deployment when asked to delete.| `false` |
| `billing_account` | string | true if `create_google_project` is true | The alphanumeric ID of the billing account this project belongs to. | none |
| `organization_name` | string | true if `create_google_project` is true | [MUTUALLY EXCLUSIVE WITH `folder_id`] The name of the organization this project belongs to. Only one of organization_name or folder_id may be specified. To specify an organization for the project to be part of, the account performing the deployment | none | 
| `folder_id` | string | true if `create_google_project` is true | [MUTUALLY EXCLUSIVE WITH `organization_name`]The numeric ID of the folder this project should be created under. Only one of organization_name or folder_name may be specified. The folder ID can be found in the [resource manager section of the GCP console](https://console.cloud.google.com/cloud-resource-manager) | none |
| `auto_create_network` | boolean | false | automatically create a default network in the Google project | none |
| `location_id` | string | true | The geographical location to serve the app from | none |
| `auth_domain` | string | false | The domain to authenticate users with when using App Engine's User API | none |
| `serving_status` | enum | false | The serving status of the app. Options are SERVING and STOPPED | none |
| `iap` | map | false | Settings for enabling Cloud Identity Aware Proxy. If iap map exists, the `oauth2_client_id` and `oauth2_client_secret` fields must be non-empty.  | none |
| `iap.enabled` | boolean | true within IAP context only | IAP enabled or not. | `false` |
| `iap.oauth2_client_id` | string | true within IAP context only | OAuth2 client ID to use for the authentication flow | none |
| `iap.oauth2_client_secret` | string | true within IAP context only | OAuth2 client secret to use for the authentication flow. The SHA-256 hash of the value is returned in the oauth2ClientSecretSha256 field | none |
| `feature_settings` | map | false | of optional settings to configure specific App Engine features. If feature_settings map exists, `split_health_checks` must be non-empty | none |
| `feature_settings.split_health_checks` | boolean | false | Set to false to use the legacy health check instead of the readiness and liveness checks. | none |
| `components` | map | true | map of app/service specifications and defaults for those specifications | none |
| `components.spec` | map | true | a set of key:value pairs where the keys are unique IDs for each components and at least one must be named `default`. The value for each key is another map, of which the format depends on the App Engine version (Flexible or standard) and is described below. | none |
| `components.common` | map | false | all attributes which can be specified for any service in components spec can be specified here as defaults which all services will use or chose to override | none |

Example:
```yamlex
create_google_project: true
project_id: &project_id protean-buffer-230514
organization_name: mesoform.com
folder_id: 320337270566
billing_account: "1234-5678-2345-7890"
location_id: "europe-west"
project_labels: &google_project_labels
  type: frontend


components:
  common:
    entrypoint: java -cp "WEB-INF/lib/*:WEB-INF/classes/." io.ktor.server.jetty.EngineMain
    runtime: java11
    env: flex
    env_variables:
      GCP_ENV: true
      GCP_PROJECT_ID: *project_id
    system_properties:
      java.util.logging.config.file: WEB-INF/logging.properties
  specs:
    experiences-search-sync:
      env: standard
    experiences-search:
      env: standard
    experiences-sidecar:
      env: standard
    default:
      root_dir: experiences-service
      runtime: java8
```

#### Google App Engine common attributes
Below is a list of attributes which are available to both GAE standard and GAE flexible apps (this 
 is not the same as components.common which is just a place to define defaults for all apps/services) 

| Key | Type | Required | Description | Default |
|:----|:----:|:--------:|:------------|:-------:|
| `env` | string | false | either `flex` or `standard` are the only values allowed here | `standard` |
| `root_dir` | string | false | on-disk directory for the app/service. The value is relative to the project root where the `gcp_ae.yml` and `project.yml` files are located. If this is omitted, MMCF will expect files to be in a directory of the same name as the app. So, for the default app, you will either need a directory called `default` or set this value to the real name of the directory | spec key name (I.e. the name of the app/service) |
| `runtime` | string | true | GAE available runtime. This differs between environment. Check the GAE docs for details | none |
| `entrypoint` | string | true | command to run to start the app/service when deployed to GAE | none |

#### Google App Engine Standard component configuration
attributes specific to only GAE standard

| Key | Type | Required | Description | Default |
|:----|:----:|:--------:|:------------|:-------:|
| static_files | string | false | | none |
| static_files.path | string | true within static_files context only | | none |
| upload_path_regex | string |  true within static_files context only | | none |

#### Manifest Files
For GAE deployments with a deployment type of `files`, a `mmcf-manifest.json` manifest file should be included. 

By default this file is located in the `<root_dir>/build` directory for the AS, and will contain the keys `artifactDir` and `contents`.

Example:
```json
{
  "artifactDir": "exploded-project-app",
  "contents": [
    "META-INF/MANIFEST.MF",
    "WEB-INF/logging.properties",
    "WEB-INF/classes/logback.xml",
    "WEB-INF/classes/application.conf",
    "WEB-INF/lib/annotations-4.1.1.4.jar",
    "WEB-INF/lib/commons-logging-1.2.jar",
    "WEB-INF/lib/gson-2.8.6.jar",
    "WEB-INF/lib/api-common-1.9.0.jar",
    "WEB-INF/lib/ktor-network-1.3.2.jar",
    "WEB-INF/lib/ktor-utils-jvm-1.3.2.jar",
    "WEB-INF/web.xml"
  ]
}
```

#### Troubleshooting Google App Engine
#### Error: "deployment.0.files": one of `deployment.0.files,deployment.0.zip` must be specified 
Receiving an error like below is likely caused by missing manifest files in the build directory
```bash
Error: "deployment.0.files": one of `deployment.0.files,deployment.0.zip` must be specified
  on .terraform/modules/deployment/mcp/gcp_ae.tf line 375, in resource "google_app_engine_standard_app_version" "self":
 375: resource "google_app_engine_standard_app_version" "self" {

```
#### Invalid function argument (`as => merge(lookup(local.gae.components, "common", {}), config))`)
```bash
Error: Invalid function argument

  on locals.tf line 45, in locals:
  45:       as => merge(lookup(local.gae.components, "common", {}), config)
    |----------------
    | local.gae.components is object with 2 attributes

Invalid value for "maps" parameter: argument must not be null.

```
gcp_ae.yml probably has a `common:` key with no values. I.e.
```yamlex
components:
  common:
  specs:
```
### gcp_cloudrun.yml
#### Prerequisites
* There must be an existing google project, with "Cloud Run" enabled with "Cloud Run Admin API" credentials
* Cloud run can only retrieve containers hosted in Container Registry, 
so your image must already be hosted in your projects container registry. 
  This can be done by running the command: 
  `$ gcloud builds submit --tag gcr.io/[PROJECT-ID]/[IMAGE]` from the containers directory. 
  `[PROJECT-ID]` is your Google Cloud Project id and `[IMAGE]` is the name you would like to name the image.
  
  Alternatively you can use docker to build and push to Container Registry
#### Cloud run basic configuration
| Key | Type | Required | Description | Default |
|:----|:----:|:--------:|:------------|:-------:|
| `project_id` | string | true | The ID of the project to be used for the service | none | 
| `location_id` | string | true | Location ID of the project used| none | 
| `name` | string | true | Name for Cloud Run Service, unique within cloud run region and cannot be updated | none | 
| `image_name` | string | true | Name of the image stored in Google Cloud Container Repository or | none | 
| `auth` | bool | true | Whether authentication is required to access service| false | 
| `environment_vars` | map | false | Any environment variables to include as for image. Key is the name of the variable and value is the string it represents| none | 
| `iam` | map | true if `auth = true` | If authentication is required to access the service, include the iam block| false | 
| `iam.role` | string | true if replacing or binding iam policy | The role the specified users will have for the service| none | 
| `iam.members` | map | ttrue if replacing or binding iam policy | Members who will be assigned the role for the iam policy| none | 
| `iam.replace_policy` | bool | false | Sets IAM policy, replacing any existing policy attached| true | 
| `iam.binding` | bool | false | Updates IAM policy to grant role to specified members| false | 
| `iam.add_member` | map | false | Adds a member who can can use a specified policy. If a binding policy exists the policy for `add_member` must be different. This must include the keys `role`, `member` and `member_type`, with `member_type` being either `"user"` or `"group"`| none | 
| `domain_name` | string | false | Custom domain name for service, domain must already exist| none | 
| `traffic` | list | false | list of traffic allocation configs across revisions| none | 
| `traffic.-.percent` | map | true if `traffic.-` exists | The percentage of traffic for revision, if `revision_name` is not specified latest revision is used| none | 
| `traffic.-.revision_name` | string | false | The name of the revision the traffic should be allocated to | 'latest_revision' is set to true by default | 

**NOTE**: Cannot have `binding` or `add_member` if using `replace_policy`, 
but can have `binding` and `add_member` at the same time as long as they are not set for the same role.
More information can be found in the terraform [documentation](https://www.terraform.io/docs/providers/google/r/cloud_run_service_iam.html).

##### Example
```yaml
project_id: <id>
location_id: "europe-west1"
create_google_project: true
create_artifact_registry: true

components:
  common:
    
    
  specs:
    name: default
#    image_location: container/artifact
#    image_project: default to same project
    image_name: image
    environment_vars:
      'EG': 'something'
      'EG2': 'something-else'
    metadata:
      annotations:
        "run.googleapis.com/client-name": "terraform"  
    auth: true
    iam: 
      replace_policy: false
      binding: true
      role: 'viewer'
      members:
        'member@example.com': 'user'
      add_member:
        role: 'admin'
        member: 'admin@example.com'
        member_type: 'user'
    domain_name: "domain.com"
    #Use hyphens to separate traffic configurations, making a list of configurations
    traffic:
      -
        percent: 25
      -
        percent: 75
        revision_name: "revision"
      

```
## Contributing

Please read [CONTRIBUTING.md](https://github.com/mesoform/terraform-infrastructure-modules/blob/master/CONTRIBUTING.md) for the process for submitting pull requests.

## License

This project is licensed under the [MPL 2.0](https://www.mozilla.org/en-US/MPL/2.0/FAQ/)
