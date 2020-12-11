An example of using the MMCF module to deploy a Google App Engine application, Google Cloud Run service, and Kubernetes Engine services.

The following configuration is used to deploy the specified structure:

Mesoform-service /
  Lmcp/
  Lapp_1 /
  |  Lbuild /
  |    Lhelloworld /
  Lapp_2 /
  |  Lresources /
  Lterraform /
  Lk8s.yml
  Lgcp_ae.yml
  Lgcp_cloudrun.yml
  Lproject.yml

Consider the contents of directories and files:

mcp
The directory contains the files needed to create Google App Engine, Google Cloud Run and Kubernetes Engine services.

app_1
The directory contains files with the source code of application 1 (in our example, Google App), Dokerfile, a list of dependencies required for the application to work.

app_2
The directory contains configuration files, secrets and others necessary for the correct operation of containers deployed in the Kubernetes engine

terrraform
The storage location of the main module main.tf with the location of the mcp directory. All components of the MMCF module are deployed from this directory.

K8s.yml
Kubernetes Engine Services Configuration File

gcp_ae.yml
Google App Engine Services Configuration File

gcp_cloudrun.yml
Google Cloudrun Services Configuration File

project.yml
Project details


To deploy Kubernetes Engine services, you need to have a running kubernetes cluster and be connected to it. To deploy Google App Engine and Google Cloud Run services, you need to create a project in which these services will be deployed. For the convenience of work, it is possible to create various projects for the Kubernetes cluster and Google App Engine. Due to implementation specifics, Google Cloud Platform does not allow uninstalling a Google App Engine application without deleting the entire project. Therefore, it will be advisable to create a separate project for it so as not to delete the project containing the Kubernetes cluster if necessary. After creating a project, you need to set the current project using the command

gcloud config set project project_name

and enable the container.googleapis.com service for the current project using the command

gcloud services enable container.googleapis.com

The considered configuration assumes the use of the image stored in the container registry service. To build and download it, you need to run the command

gcloud builds submit --tag gcr.io/project_name/helloworld

from the directory containing the Dockerfile, in our case it is app_1 / build / helloworld.

After completing the preparatory steps, you can deploy the services described in the configuration files. To do this, run the terraform apply command from the terraform directory. After entering the confirmation, the required services will be deployed automatically.

The terraform destroy command, run from the terraform directory, is used to remove deployed services. Its execution will remove Kubernetes and Cloud Run services, and when you try to remove the Google App Engine application, you will receive the following error:

Error: Error when reading or editing Project Service global-cluster-2 / run.googleapis.com: Error disabling service "run.googleapis.com" for project "global-cluster-2": Error waiting for api to disable: Error code 9, message: [Hook call / poll resulted in failed op for service 'run.googleapis.com': Please delete all resources before disabling the API.] With failed services [run.googleapis.com]

Error: Error when reading or editing AppVersion: googleapi: Error 400: Cannot delete the final version of a service (module). Please delete the whole service (module) in order to delete this version.


As noted above, you can only uninstall the Google App Engine app along with a project. However, even if you delete the current project and try to deploy the Google App Engine application in a new project, you will receive a message stating that you cannot rerun the already running application.

You can deploy the application in a new project by deleting the .terraform directory, the terraform.tfstate, terraform.tfstate.backup files from the directory containing the main.tf module and reinitializing the terraform with the terraform init command. After that, when the terraform apply command is executed, all the necessary services will be deployed to the new project automatically.
