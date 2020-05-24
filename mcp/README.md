# Multi-Cloud Platform Module
## Information
Converter module for transforming MCF (Mesoform Configuration Format) YAML into values for 
deploying to given target platform

## Directory structure
Each version of your application/service (AS) is defined in corresponding set of YAML configuration files.
 As a minimum, your AS will require two files: common.yaml which contains some basic configuration
 about your AS and the version of MCF to use; and another file containing the target 
 platform-specific configuration (e.g. gcp_ae.yml for Google App Engine). These files act as a 
 deployment descriptor and define things like scaling, runtime settings, AS configuration and other 
 resource settings for the specific target platform.

Each AS must sit in a dedicated sub-directory from the root of the repository, where the name of the
 directory is a unique ID of the AS and comply with RFC1035 (see below) For example

```
root/
    L as1/
    |     L common.yml
    |     L gcp_ae.yml
    L as2/
    |     L common.yml
    |     L gcp_ae.yml
``` 

If the target platform allows it, the directories can be organised into a logical hierarchy or main
 AS and micro-service ASs which make up the complete AS. For example

```
mesoform-service/
    L common.yml
    L gcp_ae.yml
    L micro-service1/
    |     L common.yml
    |     L gcp_ae.yml
    L micro-service2/
    |     L common.yml
    |     L gcp_ae.yml
``` 
Details on how Google App Engine would do such a thing can be found

## MCFv1
### project.yml

* **mcf_version**: (integer) version of MCF to use. Defaults to 1
* **name**: (string) Name of the resource. The name must be 1-63 characters long, and comply with
 RFC1035. Specifically, the name must be 1-63 characters long and match the regular expression 
 [a-z]([-a-z0-9]*[a-z0-9])?. The first character must be a lowercase letter, and all following 
 characters (except for the last character) must be a dash, lowercase letter, or digit. The last 
 character must be a lowercase letter or digit.
* **version**: (string) version of your application/service
* **labels**: (map) a collection of keys and values to represent labels required for your deployment.

Example:
```yamlex
mcf_version: 1
name: mesoform-admin
version: 1
labels:
  billing: central
```

### gcp_ae.yml
#### Google App Engine basic configuration
* **create_google_project**: whether or not to create a new project with the details provided.
 implies the project will be deleted with the deployment when asked to delete.
* **project_id**: (string) The GCP project identifier. https://cloud.google.com/resource-manager/reference/rest/v1/projects#Project
* **project_name**: (string) more descriptive and human understandable identifier for the project. 
 Defaults to the `project_id`
* **org_id**: (string) The numeric ID of the organization this project belongs to. Only one of
 org_id or folder_id may be specified
* **folder_id**: (string) The numeric ID of the folder this project should be created under. Only
 one of org_id or folder_id may be specified
* **billing_account**: (string) The alphanumeric ID of the billing account this project belongs to. 
* **location_id**: 
* **auth_domain**:
* **serving_status**:
* **iap_enabled**:
* **iap_oauth2_client_id**:
* **iap_oauth2_client_secret**:
* **split_health_checks**:
* **components**: (map) of component (services) which make up the App Engine applications. The keys
 are unique IDs for each components where at least one must be named `default` and the value for 
 each key is another map of which the format depends on the App Engine version (Flexible or 
 standard) and is described below 

YAML anchors can be used to reference values from other fields. For example, if you wanted `service`
 to be the same as name, would write:

```yamlex
name: &name ecat-admin
service: *name
```
#### Google App Engine Standard component configuration


Example:
```yamlex
create_google_project: true
project_id: my-mesoform-project
org_id: 123890123
billing_account: "1234-5678-2345-7890"


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