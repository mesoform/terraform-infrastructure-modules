# Multi-Cloud Platform Module

# The MCP adapters have now moved to their own repositories
## https://github.com/mesoform/Multi-Cloud-Platform-Foundations.git for foundational infrastructure adapters
## https://github.com/mesoform/Multi-Cloud-Platform-Services.git for service adapters


* [Information](#Information)  
* [Structure](#Structure)     
* [Setup](#Setup)
* [MMCF](#MMCF)  
* [project.yml](#projectyml)      
* [Google Cloud Platform Adapters](#google-cloud-platform)  
    * [App Engine](docs/GCP_APP_ENGINE.md)  
    * [Cloud Run](docs/GCP_CLOUDRUN.md)  
* [Kubernetes adapter](docs/KUBERNETES.md)  
* [Contributing](#Contributing)  
* [License](#License)  

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
    L project.yml
    L gcp_ae.yml
    L micro-service1/
    |     L src/
    |     L resources/
    L micro-service2/
    |     L __init__.py
    |     L resources
```

Specifications for different target platforms can be found below

## Setup
To use the MCP modules to deploy your service, download the `mcpadm.sh` (Linux or Mac), or `mcpadm.ps1` (Windows), 
and run the setup within a `/terraform` sub-directory of your service. 

```
mesoform-service/
L project.yml
L gcp_ae.yml
L micro-service1/
|     L src/
|     L resources/
L micro-service2/
|     L __init__.py
|     L resources
L terraform/              <----Run setup in this directory
|     L main.tf
```
Running `./mcpadm.sh setup` will interactively configure a `main.tf` file with a backend for managing terraform state, and the modules for all available adaptors.  
Running:
```shell
./mcpadm.sh setup gcs -bucket=bucket-id -prefix=tf-state-files -auto-approve
```
Would produce the following main.tf file:
```hcl
terraform{
  backend "gcs" {
    bucket = bucket-id
    prefix = tf-state-files
  }
}
module{
  source = "github.com/mesoform/terraform-infrastructure-modules/mcp"
}
```
Run `mcpadm.sh setup -help` for more setup options.

The `mcpadm` scripts can also get, deploy and destroy terraform infrastructure, as well as configure workspaces for management of multiple service versions.

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
## Google Cloud Platform 
* [App Engine](docs/GCP_APP_ENGINE.md)  
* [Cloud Run](docs/GCP_CLOUDRUN.md)  

Manage serverless deployments to Google Cloud using the App Engine or the Cloud Run adapter. 
To use these adapters you will need an existing Google Cloud account, either with an existing project, or that you can create a project in.   

An example `gcp_ae.yml` configuration:
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
## Kubernetes
* [K8s adapter documentation](docs/GCP_APP_ENGINE.md)

Use this module to interact with kubernetes resources. To use this module you must have a configured and running kubernetes cluster.

The `KUBE_CONFIG_PATH` environment variable must be set to the path of the config file for the cluster you will use.  
Run the following command to set the path to the default location:  
Linux:
```bash
 export KUBE_CONFIG_PATH=~/.kube/config
 ```
Windows Power Shell:
```powershell
 $Env:KUBE_CONFIG_PATH=~/.kube/config
```
NOTE: replace `~/.kube/config` with custom path if not using the default. Or set multiple paths with `KUBE_CONFIG_PATHS`

Kubernetes resources are configured with `k8s.yml` file.  Example shown below:
```yaml
components:
  specs:
    app_1: 
      deployment:
        metadata:
          name: "mosquitto"
          namespace:
            labels:
            app: "mosquitto"
        spec:
          selector:
            match_labels:
              app: "mosquitto"
          template:
            metadata:
              labels:
                app: "mosquitto"
            spec:
              container:
                - name: "mosquitto"
                  image: "eclipse-mosquitto:1.6.2"
                  port:
                    - container_port: 1883
                  resources:
                    limits:
                      cpu: "0.5"
                      memory: "512Mi"
                    requests:
                      cpu: "250m"
                      memory: "50Mi"
      config_map:
        metadata:
          name: "mosquitto-config-file"
          labels:
            env: "test"
        data:
          'test': 'test'
        data_file:
          - ../resources/mosquitto.conf
        binary_data:
          bar: L3Jvb3QvMTAw
        binary_file:
          - ../resources/binary.bin
      secret:
        metadata:
          annotations:
            key1:
            key2:
          name: "mosquitto-secret-file"
          namespace:
          labels:
            env: "test"
        type: Opaque
        data:
          login: login
          password: password
          data_file:
          - ../resources/secret.file
```

## Contributing

Please read [CONTRIBUTING.md](https://github.com/mesoform/terraform-infrastructure-modules/blob/master/CONTRIBUTING.md) for the process for submitting pull requests.

## License

This project is licensed under the [MPL 2.0](https://www.mozilla.org/en-US/MPL/2.0/FAQ/)

