#!/usr/bin/env bash
set -o pipefail

entry(){
  echo ""
  echo "Multi-Cloud-Platform Setup"
  echo ""
  echo "Select Option: "

  select choice in "setup" "deploy" "get" "destroy" "help" "new-version" "get-version" "set-version" "exit"; do
    case $choice in
      setup )
        echo ""
        echo "Starting setup ..."
        echo ""
        runSetup
        ;;
      deploy )
        installDependencies
        runDeploy
        ;;
      get )
        getState
        ;;
      destroy )
        runDestroy
        ;;
      new-version )
        runNewVersion
        ;;
      set-version )
        runSetVersion
        ;;
      get-version )
        runGetVersion
        ;;

      help) help;;
      exit) exit;;
      *) exit;;
    esac
  done
  exit
}

help() {
  if [ $# -lt 1 ]
  then
    echo "Usage: ${SCRIPT_NAME} <command> [options]"
    echo ""
    echo "Commands:"
    echo "  setup          -  Setup Terraform service deployment"
    echo "  get            -  Get Terraform state for current directory"
    echo "  deploy         -  Deploy configured infrastructure"
    echo "  destroy        -  Destroy Terraform infrastructure"
    echo "  new-version    -  Setup new branch and workspace for new version of service"
    echo "  get-version    -  List all versions of a service "
    echo "  set-version    -  Switch to version of service"
    echo ""
    echo "Global Options:"
    echo "  -auto-approve  - Automatically approve configuration, bypassing confirmation prompts "
    echo ""
    entry
  else
    case $1 in
      help | -help | --help )
        echo "MCPADM HELP:"
        echo ""
        echo "Usage: ${SCRIPT_NAME} <command> [options]"
        echo ""
        echo "Commands:"
        echo "  setup        -  Setup Terraform service deployment"
        echo "  get          -  Get Terraform state for current directory"
        echo "  deploy       -  Deploy configured infrastructure"
        echo "  destroy      -  Destroy Terraform infrastructure"
        echo "  new-version  -  Setup new branch and workspace for new version of service"
        echo "  get-version  -  List all versions of a service "
        echo "  set-version  -  Switch to version of service"
        echo ""
        exit
        ;;
      setup )
        echo "SETUP HELP:"
        echo ""
        echo "\`setup\` configures a main.tf file with a specified backend and Multi-Cloud-Platform source module"
        echo "NOTE: If no backend is specified but the flag \`-auto-approve\` is included, no backend will be specified."
        echo "      This will lead to the tfstate file being saved in the current directory"
        echo ""
        echo "Usage: ${SCRIPT_NAME} setup [backend] [options]"
        echo ""
        echo "Backends:"
        echo "  default    -  Store terraform state in current directory"
        echo "  gcs        -  Store terraform state in Google Cloud Storage"
        echo "  s3         -  Store terraform state in AWS s3 bucket"
        echo "  http       -  Store terraform state using REST client"
        echo "  s3         -  Store terraform state in a Kubernetes secret"
        echo "  local      -  Store terraform state in specified directory"
        echo ""
        echo "Options:"
        echo "  gcs:"
        echo "    -bucket=<BUCKET_NAME> - Name of existing Google Storage Bucket to store state file in"
        echo "    -prefix=<PATH>        - Prefix of path inside the bucket to store state file in"
        echo ""
        echo "  s3"
        echo "    -bucket=<BUCKET_NAME> - Name of existing AWS S3 bucket to store state file in"
        echo "    -key=<KEY_PATH>       - Path to state file within bucket "
        echo "    -region=<AWS_REGION>  - AWS Region for specified S2 bucket "
        echo ""
        echo "  http"
        echo "    -address=<REST_ENDPOINT>           - Address of the REST endpoint"
        echo "    -lock-address=<LOCK_ADDRESS>       - Address of the REST lock endpoint. If locking is disabled set as \`null\`"
        echo "    -unlock-address=<UNLOCK_ADDRESS>   - Address of the REST unlock endpoint. If locking is disabled set as \`null\`"
        echo ""
        echo "  kubernetes"
        echo "    -secret_suffix=<SECRET_SUFFIX>     - Suffix used in kkubernetes secret. Secrets are named in the format tfstate-{workspace}-{secret_suffix}"
        echo "    -load_config_file=<true or false>  - If set to true it will attempt to use a kubeconfig file to access cluster"
        echo ""
        echo "  local"
        echo "    -path=<PATH>  - Path to state file, E.g. 'path/to/state/file/terraform.tfstate'"
        echo ""
        exit
        ;;
      new-version )
        echo "NEW-VERSION HELP:"
        echo ""
        echo "new-version creates a new terraform workspace to setup deployment of a new version of the service."
        echo ""
        echo "Usage: ${SCRIPT_NAME} new-version [service] [options]"
        echo ""
        echo "Services:"
        echo "  appengine        -  New version of App Engine service"
        echo "  cloudrun         -  New version of Cloud Run service"
        echo ""
        echo "Options:"
        echo "  App Engine:"
        echo "    -project=<PROJECT_ID>        - ID of project containing App Engine Application"
        echo "    -version=<VERSION_ID>        - Version number for new App Engine version"
        echo "  Cloud Run:"
        echo "    -location=<LOCATION_ID>      - Location ID for Cloud Run service, e.g. 'europe-west2'"
        echo "    -project=<PROJECT_ID>        - Id of project containing Cloud Run Application"
        echo "    -revision=<REVISION_ID>      - Revision number for the new Cloud Run revision"
        echo "    -service=<PROJECT_ID>        - Name of the Cloud Run service being updated"
        echo ""
        exit
        ;;
      get-version )
        echo "GET-VERSION HELP:"
        echo ""
        echo "list-version lists all versions of services in terraform infrastructure"
        echo ""
        echo "Usage: ${SCRIPT_NAME} get-version [options]"
        echo ""
        echo "Options:"
        echo "  appengine        -  List versions of App Engine service"
        echo "  cloudrun         -  List versions of Cloud Run service"
        echo ""
        exit
        ;;
      set-version )
        echo "SET-VERSION HELP:"
        echo ""
        echo "set-version changes to different version of service"
        echo ""
        echo "Usage: ${SCRIPT_NAME} set-version [options]"
        echo ""
        echo "Options:"
        echo "  appengine        -  List versions of App Engine service and set version to choice"
        echo "  cloudrun         -  List versions of Cloud Run service and set version to choice"
        echo "  <version-name>   -  Set version as <version-name> if it exists"
        echo ""
        exit
        ;;
    esac
  fi


}

installDependencies() {
  echo ""
  echo "Installing dependencies"

    OS="$(uname)"
    case ${OS} in
        'Linux')
            installLinuxDependencies
            ;;
        'Darwin')
            installDarwinDependencies
            ;;
        *)
            echo "Couldn't determine OS type."
            return
            ;;
    esac
}

installLinuxDependencies() {
  if  ! [ -x "$(command -v terraform)" ]
  then
    echo ""
    echo "Getting terraform ..."
    echo ""

    cd "${BIN}"
    TERRAFORM_URL_LIN=https://releases.hashicorp.com/terraform/0.12.0/terraform_0.12.0_linux_amd64.zip
    TERRAFORM_FILE_LIN="${TERRAFORM_URL_LIN##*/}"
    wget "${TERRAFORM_URL_LIN}"
    unzip -o "${TERRAFORM_FILE_LIN}"
    rm "${TERRAFORM_FILE_LIN}"
    cd "${SCRIPT_DIR}"

    echo ""
    echo "Terraform for $OS installed."
    echo ""
  else
    echo ""
    echo "All dependencies installed"
    echo ""
  fi
}

installDarwinDependencies(){
   # Install Terraform
    if  ! [ -x "$(command -v terraform)" ]
    then
        echo ""
        echo "Getting terraform ..."
        echo ""

        cd "${BIN}"
        TERRAFORM_URL_DAR=https://releases.hashicorp.com/terraform/0.12.0/terraform_0.12.0_linux_amd64.zip
        TERRAFORM_FILE_DAR="${TERRAFORM_URL_DAR##*/}"

        echo "URL: ${TERRAFORM_URL_DAR}"
        echo "File: ${TERRAFORM_FILE_DAR}"

        curl "${TERRAFORM_URL_DAR}" --output "${TERRAFORM_FILE_DAR}"
        unzip "${TERRAFORM_FILE_DAR}"
        rm "${TERRAFORM_FILE_DAR}"
        cd "${SCRIPT_DIR}"

        echo ""
        echo "Terraform for $OS installed."
        echo ""
    fi
}

runSetup(){
  local choice backend autoapprove
  if [ $# == 2 ] && [[ "$2" =~ (-)*(h)+(elp)? ]]
  then
    help "$1"
  else
    echo "terraform{" > main.tf.temp
    if [ $# -lt 2 ]
    then
      echo "Which backend will you use?"
      select choice in "gcs" "s3" "http" "kubernetes" "local" "default"; do
        case $choice in
          gcs )
            gcsBackend
            ;;
          s3 )
            s3Backend
            ;;
          http )
            httpBackend
            ;;
          kubernetes )
            kubernetesBackend
            ;;
          local )
            localBackend
            ;;
          default);;
          *);;
        esac
        break
      done
    else
      backend=$(echo "$2" | tr [:upper:] [:lower:])
#      backend=${2,,}
      case $backend in
        gcs )
          gcsBackend "$@"
          ;;
        s3 )
          s3Backend "$@"
          ;;
        http )
          httpBackend "$@"
          ;;
        kubernetes )
          kubernetesBackend "$@"
          ;;
        local)
          localBackend "$@"
          ;;
        default);;
        -auto-approve) ;;
        *)
          echo ""
          echo "Not a valid backend"
          echo "Run \`mcpadm setup help\` for more information"
          echo ""
          exit
          ;;
      esac
    fi
    echo "}" >> main.tf.temp
    {
      echo "module mcp{"
      echo "  source = \"github.com/mesoform/terraform-infrastructure-modules//mcp\""
      echo "  gcp_ae_traffic = var.gcp_ae_traffic"
      echo "  gcp_cloudrun_traffic = var.gcp_cloudrun_traffic"
      echo "}"
      echo ""
      echo "variable gcp_ae_traffic{"
      echo "  description = \"Map of App Engine traffic allocations, in format of '<service>;<version> = <percent>'\""
      echo "  type        = map"
      echo "  default     = null"
      echo "}"
      echo ""
      echo "variable gcp_cloudrun_traffic{"
      echo "  description = \"Map of Cloud Run traffic allocations, in format of '<service>;<version> = <percent>'\""
      echo "  type        = map"
      echo "  default     = null"
      echo "}"

    } >> main.tf.temp

#    cat main.tf.temp
    echo ""
    if ! [[ "$*" =~ "-auto-approve" ]]
    then
      cat main.tf.temp
      read -r -p "Are you happy with this configuration? [y]es or [n]o: " accept
      if [[ "$accept" =~ ([yY][eE][sS]|[yY])$ ]]
      then
        echo ""
        echo "Setup Complete"
        echo ""
        echo "To make any changes, update the main.tf found at $PWD/main.tf"
        echo ""
        cat main.tf.temp > main.tf
        rm main.tf.temp
        [ $# -gt 2 ] && exit
        entry
      else
        echo ""
        echo "Configuration rejected"
        echo ""
        rm main.tf.temp
        [ $# -gt 2 ] && exit
        read -r -p "Restart setup? [y]es or [n]o: " restart
        if [[ "$restart" =~ ([yY][eE][sS]|[yY])$ ]]
        then
          echo ""
          echo "Restarting setup ..."
          echo ""
          runSetup
        else
            rm main.tf.temp
            entry
        fi
      fi
    else
      cat main.tf.temp > main.tf
      rm main.tf.temp
      echo "main.tf: "
      cat main.tf | sed 's/^/  /'
      echo ""
      echo "Setup Complete"
      echo ""
      echo "To make any changes, update the main.tf found at $PWD/main.tf"
      echo ""
      exit
    fi
  fi
}

gcsBackend(){
  local bucket prefix
  for i in "$@"
  do
    case $i in
      -bucket=* )
        bucket="${i#*=}"
        ;;
      -prefix=* )
        prefix="${i#*=}"
        ;;
      * )
        ;;
    esac
  done
  echo "  backend \"gcs\"{" >> main.tf.temp
  if [ -z ${bucket} ]
  then
    read -r -p "Enter bucket name: " bucket
  fi
  echo "    bucket = \"${bucket}\"" >> main.tf.temp
  if [ -z ${prefix} ]
  then
    read -r -p "Enter gcs prefix: " prefix
  fi
  echo "    prefix = \"${prefix}\""  >> main.tf.temp
  echo "  }" >> main.tf.temp
}

s3Backend(){
  local bucket key region
  for i in "$@"
  do
    case $i in
      -bucket=* )
        bucket="${i#*=}"
        ;;
      -key=* )
        key="${i#*=}"
        ;;
      -region=* )
        region="${i#*=}"
        ;;
      * )
        ;;
    esac
  done
  echo "  backend \"s3\"{" >> main.tf.temp
  if [ -z "${bucket}" ]
  then
    read -r -p "Enter bucket name: " bucket
  fi
  echo "    bucket = \"${bucket}\"" >> main.tf.temp
  if [ -z "${key}" ]
  then
    read -r -p "Enter key: " key
  fi
  echo "    key = \"${key}\""  >> main.tf.temp
  if [ -z "${region}" ]
  then
    read -r -p "Enter region: " region
  fi
  echo "    region = \"${region}\""  >> main.tf.temp
  echo "  }" >> main.tf.temp
}

httpBackend(){
  local address lock_address unlock_address
  for i in "$@"
  do
    case $i in
      -address=* )
        address="${i#*=}"
        ;;
      -lock-address=* )
        lock_address="${i#*=}"
        ;;
      -unlock-address=* )
        unlock_address="${i#*=}"
        ;;
      * )
        ;;
    esac
  done
  echo "  backend \"http\"{" >> main.tf.temp
  if [ -z "${address}" ]
  then
    read -r -p "Enter address: " address
  fi
  echo "    address = \"${address}\"" >> main.tf.temp
  if [ -z "${lock_address}" ]
  then
    read -r -p "Enter lock address: " lock_address
  fi
  echo "    lock_address = \"${lock_address}\""  >> main.tf.temp

  if [ -z "${unlock_address}" ]
  then
    read -r -p "Enter unlock address: " unlock_address
  fi
  echo "    unlock_address = \"${unlock_address}\""  >> main.tf.temp
  echo "  }" >> main.tf.temp
}

kubernetesBackend(){
  local secret_suffix config
  for i in "$@"
  do
    case $i in
      -secret-suffix=* )
        secret_suffix="${i#*=}"
        ;;
      -load-config-file=* )
        config="${i#*=}"
        ;;
      * )
        ;;
    esac
  done
  echo "  backend \"kubernetes\"{" >> main.tf.temp
  if [ -z "${secret_suffix}" ]
  then
    read -r -p "Enter secret suffix: " secret_suffix
  fi
  echo "    secret_suffix = \"${secret_suffix}\"" >> main.tf.temp
  if [ -z "${config}" ]
  then
    read -r -p "Load config file? (true or false): " config
  fi
  echo "    load_config_file = ${config}"  >> main.tf.temp
  echo "  }" >> main.tf.temp
}

localBackend() {
  local path
  for i in "$@"
  do
    case $i in
      -path=* )
        path="${i#*=}"
        ;;
      * )
        ;;
    esac
  done
  echo "  backend \"local\"{" >> main.tf.temp
  if [ -z ${path} ]
  then
    read -r -p "Enter file path: " path
  fi
  echo "    Path = \"${path}\"" >> main.tf.temp
  echo "  }" >> main.tf.temp
}

runDeploy() {
  echo ""
  echo "Initialising terraform ..."
  echo ""
  terraform init
  echo ""
  echo "Creating Plan ..."
  echo ""
  terraform apply
  entry
}

runNewVersion(){
  if [ $# == 2 ] && [[ "$2" =~ (-)*(h)+(elp)? ]]
  then
    help "$1"
  else
    if [ $# -lt 2 ]
    then
      echo "New version of: "
      select module in "AppEngine" "CloudRun"; do
        case $module in
          AppEngine )
            appEngineVersion
            ;;
          CloudRun )
            cloudRunVersion
            entry
            ;;
          * )
            echo ""
            echo "Invalid Choice"
            echo ""
            entry
            ;;
        esac
      done
    else
      platform=$(echo "$2" | tr [:upper:] [:lower:])
#      platform=${2,,}
      case $platform in
        appengine )
          appEngineVersion "$@"
          ;;
        cloudrun )
          cloudRunVersion "$@"
          ;;
        *)
          echo ""
          echo "Invalid Argument $2, must be one of 'appengine' or 'cloudrun'"
          echo ""
          ;;
      esac
    fi

  fi

}

runSetVersion(){
  local switch
  if [ $# -lt 2 ]
  then
    runGetVersion
    read -r -p "Enter version to switch to: " switch
    terraform workspace select "$switch" || echo "Not valid version workspcae, please enter valid version" && exit
    entry
  else
    if [[ "$2" =~ (-)*(h)+(elp)? ]]
    then
      help "$1"
    elif [ "$2" == "cloudrun" ] || [ "$2" == "appengine" ]
    then
      runGetVersion "$@"
      read -r -p "Enter version to switch to: " switch
      terraform workspace select "$switch" || echo "Not a valid version workspace, please enter valid version" && exit
      exit
    else
      terraform workspace select "$2" || echo "Not a valid version workspace, please enter valid version" && exit
      exit
    fi
  fi
}

runGetVersion(){
  local versions version
  echo ""
  echo "Versions:"
  echo ""
  if [ $# -lt 2 ]
  then
    terraform workspace list
    entry
  else
    versions=($(terraform workspace list))
    for version in "${versions[@]}"
    do
      if [[ "$version" == *$2* ]]
      then
        echo "$version"
      fi
    done
  fi
  echo ""
  [ "$1" == "get-version" ] && exit
}

appEngineVersion(){
  local project version BRANCH item
  echo ""
  echo "App Engine Version Setup"
  echo ""

  for i in "$@"
  do
    case $i in
      -project=*)
        project="${i#*=}"
        ;;
      -version=*)
        version="${i#*=}"
        ;;
      *)
        ;;
    esac
  done
  if [ -z "${project}" ]
  then
    read -r -p "Enter project id: " project
  fi
  if [ -z "${version}" ]
  then
    read -r -p "Enter the version name/id: " version
  fi

  echo ""
  echo "Configuration"
  echo "    Project ID: $project"
  echo "    Version: $version "
  echo ""

  if ! [[ "$*" =~ "-auto-approve" ]]
  then
    read -r -p "Continue with these settings? [y/N] : " response
    if ! [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
    then
      [ $# -gt 2 ] && exit
      entry
    fi
  fi
  BRANCH="gcp-ae-$version"
  terraform workspace new "$BRANCH"
  terraform init
  terraform import 'module.mcp.google_app_engine_application.self[0]' "$project" || echo "Import failed /n" && exit
  versionHelp "$@"

}

cloudRunVersion(){
  local autoapprove project revision service location item BRANCH
  echo ""
  echo "Cloud Run Revision Setup"
  echo ""
  autoapprove=false
  for i in "$@"
  do
    case $i in
      -project=*)
        project="${i#*=}"
        ;;
      -revision=*)
        revision="${i#*=}"
        ;;
      -service=*)
        service="${i#*=}"
        ;;
      -location=*)
        location="${i#*=}"
        ;;
      -auto-approve)
        autoapprove=true
        ;;
      *)
        ;;
    esac
  done
  if [ -z "${project}" ]
  then
    read -r -p "Enter project id: " project
  fi
  if [ -z "${service}" ]
  then
    read -r -p "Enter name of the Cloud Run service: " service
  fi
  if [ -z "${revision}" ]
  then
    read -r -p "Enter revision name/id: " revision
  fi
  if [ -z "${location}" ]
  then
    read -r -p "Enter the location_id of the service: " location
  fi

  echo "Configuration: "
  echo "    Project ID: $project"
  echo "    Service: $service"
  echo "    Revision: $revision"
  echo "    Location: $location "
  echo ""
  if ! [ $autoapprove ]
  then
    echo ""
    read -r -p "Continue with these settings? [y/N]: " response
    if ! [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
    then
      [ $# -gt 2 ] && exit
      entry
    fi
  fi
  BRANCH="gcp-cloudrun-$revision"
  terraform workspace new "$BRANCH"
  terraform init
  terraform import "module.mcp.google_cloud_run_service.self[\"${service}\"]" "$location"/"$project"/"$service" || (echo "Import failed" && exit)
  terraform import "module.mcp.google_cloud_run_service_iam_policy.self[\"${service}\"]" projects/"$project"/locations/"$location"/services/"$service" || (echo "Import failed" && exit)
  versionHelp "$@"
}

versionHelp(){
  echo ""
  echo "Workspace Setup and Imports Completed"
  echo ""
  echo "To update the version for your services: "
  echo "  1. Update the version ID or revision name, as well as any other configuration changes, in the relevant yaml files"
  echo "  2. Run 'terraform apply' to deploy changes"
  echo "  3. Commit changes to project to a VCS branch to maintain differences to version "
  echo ""
  [ $# -gt 2 ] && exit
  entry
}

runDestroy() {
  echo ""
  echo "Creating plan for destroying resources..."
  echo ""
  terraform destroy
  entry
}

getState(){
  echo ""
  echo "Getting terraform state"
  echo ""
  terraform refresh
  terraform show
}


# ####################################################
# Command selector
# ####################################################
OPTION=$1
case $OPTION in
  setup )
    runSetup "$@"
    ;;
  deploy )
    installDependencies
    runDeploy "$@"
    ;;
  help | -help | --help )
    help "$@"
    ;;
  get | -get)
    getState "$@"
    ;;
  new-version | -new-version)
    runNewVersion "$@"
    ;;
  set-version | -set-version )
    runSetVersion "$@"
    ;;
  get-version | -get-version)
    runGetVersion "$@"
    ;;
  destroy | -destroy)
    runDestroy "$@"
    ;;
  *)
    entry
    ;;
esac

