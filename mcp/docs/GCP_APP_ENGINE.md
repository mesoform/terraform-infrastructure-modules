#Google App Engine
App Engine allows for building scalable applications on serverless platforms [(Documentation)](https://cloud.google.com/appengine)
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