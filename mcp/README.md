# Multi-Cloud Platform Module
## Contents
[Information](#Information)  
[Structure](#Structure)     
[MMCF](#MMCF)     
[project.yml](#projectyml)      
[gcp_ae.yml](#gcp_aeyml)

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

* **mcf_version**: (string) version of MCF to use. _Defaults to 1.0_
* **[REQUIRED] name**: (string) Name of the project. If you want to reference this in later configuration, it
 must meet the minimum requirements of the target platform(s) being deployed to. For example, 
 Google App Engine requires that many IDs/names must be 1-63 characters long, and comply with
 RFC1035. Specifically, the name must be 1-63 characters long and match the regular expression 
 [a-z]\([-a-z0-9]*[a-z0-9])?. The first character must be a lowercase letter, and all following 
 characters (except for the last character) must be a dash, lowercase letter, or digit. The last 
 character must be a lowercase letter or digit.
* **version**: (string) deployment version of your application/service. Version must contain only
 lowercase letters, numbers, dashes (-), underscores (_), and dots (.). Spaces are not allowed, and
 dashes, underscores and dots cannot be consecutive (e.g. "1..2" or "1.\_2") and cannot be at the 
 beginning or end (e.g. "-1.2" or "1.2\_")
* **labels**: (map) a collection of keys and values to represent labels required for your deployment.

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
* As a minimum, the account performing the deployment will need Storage Object Admin role on the
 project being deployed to.
* If creating a new project, the account performing the deployment also needs project creator role;
 and either organization viewer role or folder viewer role
 
#### Google App Engine basic configuration
* **create_google_project**: whether or not to create a new project with the details provided.
 _Default: false_
 implies the project will be deleted with the deployment when asked to delete.
* **[REQUIRED] project_id**: (string) The GCP project identifier. https://cloud.google.com/resource-manager/reference/rest/v1/projects#Project
* **project_name**: (string) more descriptive and human understandable identifier for the project. 
 Defaults to the `project_id`
* **auto_create_network**: (boolean) automatically create a default network in the Google project
* **billing_account**: (string) The alphanumeric ID of the billing account this project belongs to. 
* **[REQUIRED] location_id**: (string) The geographical location to serve the app from
* **auth_domain**: (string) The domain to authenticate users with when using App Engine's User API
* **serving_status**: (enum) The serving status of the app. Options are SERVING and STOPPED
* **iap**: (map) Settings for enabling Cloud Identity Aware Proxy. If iap map exists, the 
`oauth2_client_id` and `oauth2_client_secret` fields must be non-empty.
    * **enabled**: (boolean) IAP enabled or not. _Default: false_
    * **oauth2_client_id**: OAuth2 client ID to use for 
    the authentication flow
    * **oauth2_client_secret**: OAuth2 client secret to 
    use for the authentication flow. The SHA-256 hash of the value is returned in the 
    oauth2ClientSecretSha256 field
* **feature_settings**: (map) of optional settings to configure specific App Engine features. If
feature_settings map exists, `split_health_checks` must be non-empty
    * **split_health_checks**: (boolean) Set to false to use the legacy health check instead of the 
    readiness and liveness checks.

---- one of ----

* **organization_name**: (string) The name of the organization this project belongs to. Only one of
 organization_name or folder_id may be specified. To specify an organization for the project to 
 be part of, the account performing the deployment 
* **folder_id**: (string) The numeric ID of the folder this project should be created under. Only
 one of organization_name or folder_name may be specified. The folder ID can be found in the 
 [resource manager section of the GCP console](https://console.cloud.google.com/cloud-resource-manager)
 
---- end ----

* **components**: (map) of component (services) which make up the App Engine applications. The keys
 are unique IDs for each components where at least one must be named `default` and the value for 
 each key is another map of which the format depends on the App Engine version (Flexible or 
 standard) and is described below 


#### Google App Engine Standard component configuration

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
      env_variables:
        'env': dev
      threadsafe: True
    specs:
      app1:
        runtime: custom
        env: flex
        service: mesoform-admin
        manual_scaling:
          instances: 6
        inbound_services:
        - warmup
        derived_file_type:
        - java_precompiled
        auto_id_policy: default
        env_variables:
          'IS_GAE': 'true'
        api_version: 'user_defined'
        liveness_check:
          path: "/liveness_check"
          check_interval_sec: 10
          timeout_sec: 4
          failure_threshold: 2
          success_threshold: 2
        deployment:
          zip:
            source_url: http://zip.com
            files_count: 1
          cloud_build_options:
            app_yaml_path: /test_files
            cloud_build_timeout_sec: 900
      default:
        runtime: java8
        manual_scaling:
          instances: 1
        inbound_services:
        - warmup
        derived_file_type:
        - java_precompiled
        threadsafe: False
        auto_id_policy: default
        env_variables:
          'IS_GAE': 'true'
        api_version: 'user_defined'
        handlers:
        - url: (/.*)
          static_files: __static__\1
          upload: __NOT_USED__
          require_matching_file: True
          login: optional
          secure: optional
        - url: /.*
          script: unused
          login: optional
          secure: optional
        skip_files: app.yaml
```