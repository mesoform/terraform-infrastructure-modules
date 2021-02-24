# Google App Engine  
App Engine allows for building scalable applications on serverless platforms [(Documentation)](https://cloud.google.com/appengine)
### gcp_ae.yml
#### Prerequisites:
#### Container/Files
The build and delivery of the files/container for the application should be done prior to app engine deployment.   
##### Containers
Container image should be hosted in [artifact registry](https://cloud.google.com/artifact-registry/docs/docker), 
or [google container registry](https://cloud.google.com/container-registry/docs/pushing-and-pulling) (deprecated).   
##### Files  
A `mmcf-manifest.json` manifest file should be included in the subdirectory for each application. By default it is found in `<app_dir>/build`.
```
    mesoform-service/
        L project.yml
        L gcp_ae.yml
        L terraform/
            L main.tf
        L app1/
            L build/
                L mmcf-manifest.yml
                L exploded-project-app/
                    L ...
```
These files within the application directory should be stored in a [google cloud storage](https://cloud.google.com/storage/docs) bucket 
following the same directory structure as described in the manifest. 
All the files must be readable with the credentials supplied.  
An example manifest for an app:  
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
In cloud storage the locations of these `MANIFEST.MF` would be: `"https://storage.googleapis.com/<bucket>/<service name>/exploded-project-app/META-INF/MANIFEST.MF"`.
The key `bucket_name` is the name of the bucket which holds the services files. 

#### IAM permission
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
| `bucket_name` | string | true if deploying using files | name of the google storage bucket storing the AS files | value of `project_id` |
| `create_google_project` | boolean | false | whether or not to create a new project with the details provided. implies the project will be deleted with the deployment when asked to delete.| `false` |
| `billing_account` | string | true if `create_google_project` is true | The alphanumeric ID of the billing account this project belongs to. | none |
| `organization_name` | string | true if `create_google_project` is true | [MUTUALLY EXCLUSIVE WITH `folder_id`] The name of the organization this project belongs to. Only one of organization_name or folder_id may be specified. To specify an organization for the project to be part of, the account performing the deployment | none |
| `folder_id` | string | true if `create_google_project` is true | [MUTUALLY EXCLUSIVE WITH `organization_name`]The numeric ID of the folder this project should be created under. Only one of organization_name or folder_name may be specified. The folder ID can be found in the [resource manager section of the GCP console](https://console.cloud.google.com/cloud-resource-manager) | none |
| `auto_create_network` | boolean | false | automatically create a default network in the Google project | none |
| `location_id` | string | true | The geographical location to serve the app from | none |
| `auth_domain` | string | false | The domain to authenticate users with when using App Engine's User API | none |
| `serving_status` | enum | false | The serving status of the app. Options are SERVING and STOPPED | none |
| `flex_delay` | string | false | Delay creation of flexible app after creation of service account to avoid propagation error | "30s" |
| `iap` | map | false | Settings for enabling Cloud Identity Aware Proxy. If iap map exists, the `oauth2_client_id` and `oauth2_client_secret` fields must be non-empty.  | none |
| `iap.enabled` | boolean | true within IAP context only | IAP enabled or not. | `false` |
| `iap.oauth2_client_id` | string | true within IAP context only | OAuth2 client ID to use for the authentication flow | none |
| `iap.oauth2_client_secret` | string | true within IAP context only | OAuth2 client secret to use for the authentication flow. The SHA-256 hash of the value is returned in the oauth2ClientSecretSha256 field | none |
| `feature_settings` | map | false | of optional settings to configure specific App Engine features. If feature_settings map exists, `split_health_checks` must be non-empty | none |
| `feature_settings.split_health_checks` | boolean | false | Set to false to use the legacy health check instead of the readiness and liveness checks. | none |
| `components` | map | true | map of app/service specifications and defaults for those specifications | none |
| `components.spec` | map | true | a set of key:value pairs where the keys are unique IDs for each components and at least one must be named `default`. The value for each key is another map, of which the format depends on the App Engine version (Flexible or standard) and is described below. | none |
| `components.common` | map | false | all attributes which can be specified for any service in components spec can be specified here as defaults which all services will use or chose to override | none |
| `components.spec.<app>.migrate_traffic` | bool | false | will migrate all traffic to a new version of the deployed app | false |

Example:
```yamlex
create_google_project: true
project_id: &project_id <google project id>
bucket_name: <cloud storage bucket name>
organization_name: mesoform.com
folder_id: 0000000000
billing_account: "1234-5678-2345-7890"
location_id: "europe-west"
project_labels: &google_project_labels
  type: frontend

components:
  common:
    entrypoint: java -cp "WEB-INF/lib/*:WEB-INF/classes/." io.ktor.server.jetty.EngineMain
    runtime: java11
    threadsafe: True
    auto_id_policy: default
    derived_file_type:
      - java_precompiled
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
| `static_files` | string | false | | none |
| `static_files.path` | string | true within static_files context only | | none |
| `upload_path_regex` | string |  true within static_files context only | | none |

#### Google App Engine Flexible component Configuration  
An example flexible app engine configuration:  
```yaml
project_id: &project_id ae-flex-test
create_google_project: false
location_id: "europe-west2"
components:
  common:
    entrypoint: python main.py
    runtime: python38
    env: flex
    env_variables:
      GCP_PROJECT_ID: *project_id
  specs:
    default:
      version_id: v3
      deployment:
        container:
          image: "europe-west2-docker.pkg.dev/<project_id>/<repository_name>/helloworld:latest" 
      automatic_scaling: {} #Will use the default automatic_scaling settings
      resources: 
        memory_gb: 2
      readiness_check: 
        success_threshold: 3
```
***NOTE***: For the container image ensure that the tag or digest is included on the full URI  

### Deployment Versioning  
Multiple versions of a service can be deployed at once. 
* `gcp_ae.yml` will only contain the specifications for one version of each service.  
* Updating the container version or manifest will not produce a new app engine version, but will update the current deployment
* If the version key is updated in `gcp_ae.yml` a new deployment version will be made. 
  By default, 100% of traffic will be sent to this new version, and the old version will be destroyed. 
* To run multiple versions, [terraform workspaces](https://www.terraform.io/docs/state/workspaces.html) should be used.  
  E.g. to deploy a new version of an application:
    1. Make a new branch using VCS and make version and configuration changes to `gcp_ae.yml` 
    2. Make a new terraform workspace by running: `terraform workspace new <version name>` 
    3. Import google app engine configuration to state file by running `terraform import 'module.mcp.google_app_engine_application.self[0]' <project-id>`
    Without this step terraform will try to create a new `google_app_engine_application` resource, when only one per project is allowed, resulting in an error.
    4. Apply changes with `terraform apply`
    5. Commit terraform configuration and state files to VCS

#### Traffic
By default, 100% of traffic will be migrated to a newly declared version of app engine. 
If managing traffic for multiple versions, traffic percent should be specified for each version receiving traffic.  
Traffic can either be allocated by specifying a `gcp_ae_traffic.yml` file or by setting the environment variable `TF_VAR_gcp_ae_traffic` to a map of traffic allocations.  
Traffic should be a mapping of `<service>;<revision_id>` to a percentage of traffic to send.

Example of traffic assignment using environment variables:
```shell
export TF_VAR_gcp_ae_traffic='{"app1;v1" = 60, "app1;v2" = 40, "app1-service;v3" = 90, "app1-service;v4" = 10}'
```

Example of `gcp_ae_traffic.yml`:
```yaml
app1;v1: 60
app1;v2: 40
app1-service;v3: 90
app1-service;v4: 10 
```

If creating a new version in a new workspace, and not wanting to migrate or split traffic, set the variable `migrate_traffic` to `false` within the app specs in `gcp_ae.yml`.
This will make have the new version serving 0 traffic, and keep the original traffic split.

##### NOTE:
If replacing updating a version in place with `migrate_traffic` set to false, a new version will be created with 0% traffic, and Terraform will attempt to destroy the previous version. 
This will result in:
  ```
    Error when reading or editing AppVersion: googleapi: Error 400: Cannot delete a version with a non-zero traffic allocation. 
    Please update your traffic split to remove the allocation for this version and try again.
  ```
This is due to attempting to destroy the previous version which still has traffic. The previous version will not be destroyed, and will still be serving the set traffic amount. 
To resolve this, traffic for that version must be set to 0 before being destroyed.

### Requirements.txt

For applications that are dependent on third party libraries, define a `requirements.txt` file. 
For example a python web app using flask would need:
```text
Flask==1.1.2
```  

### Troubleshooting Google App Engine
#### Error: "deployment.0.files": one of `deployment.0.files,deployment.0.zip` must be specified
Receiving an error like below is likely caused by missing manifest files in the build directory
```bash
Error: "deployment.0.files": one of `deployment.0.files,deployment.0.zip` must be specified
  on .terraform/modules/deployment/mcp/gcp_ae.tf line 375, in resource "google_app_engine_standard_app_version" "self":
 375: resource "google_app_engine_standard_app_version" "self" {

Example:
```yaml
wait_for_load_balancer : false
metadata:
  name: "example-ingress"
spec:
  backend:
    service_name: "service"
    service_port: 8080
  rule:
    host:
    http:
      paths:
        - path: "/"
          backend:
            service_port: 8080
            service_name: "service"
        - path: "/"
          backend:
            service_port: 8080
            service_name: "service2"
  tls:
    secret_name: "tls-secret"
```
Invalid value for "maps" parameter: argument must not be null.

```
gcp_ae.yml probably has a `common:` key with no values. I.e.
```yamlex
components:
  common:
  specs:
```
####  Error 404: Unable to retrieve P4SA: [service-<project_number>@gcp-gae-service.iam.gserviceaccount.com] from GAIA. Could be GAIA propagation delay or request from deleted apps.  
This is most often a propogation delay with creation of service account for app engine.   
P4SA (Per-Product Per-Project Service Account) refers to the google managed service account for app engine.
The error means that a GAIA (Google Account and ID Administration) ID has not yet been associated with the service account for this project.   
A default of 30s has been added between the creation of the service account and creation of flexible app service, 
to ensure the service account has been created before app engine attempts to use it.  
If this error occurs set `flex_delay` to `"2m"` or more. E.g.

```yaml
project_id: project
create_google_project: false
location_id: "europe-west2"
flex_delay: "2m"     
components:
  specs:
    default:
      ...
```