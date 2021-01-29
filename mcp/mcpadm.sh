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
        runNewVersion
        ;;
      get-version )
        runNewVersion
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
    echo "  setup        -  Setup Terraform service deployment"
    echo "  get          -  Get Terraform state for current directory"
    echo "  deploy       -  Deploy configured infrastructure"
    echo "  destroy      -  Destroy Terraform infrastructure"
    echo "  new-version  -  Setup new branch and workspace for new version of service"
    echo "  get-version  -  List all versions of a service "
    echo "  set-version  -  Switch to version of service"
    echo ""
    entry
  else
    case $1 in
      help )
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
      new-version )
        echo "new-version creates a new terraform workspace to setup deployment of a new version of the service."
        echo ""
        echo "Usage: ${SCRIPT_NAME} new-version [options]"
        echo ""
        echo "Options:"
        echo "  appengine        -  New version of App Engine service"
        echo "  cloudrun         -  New version of Cloud Run service"
        echo ""
        exit
        ;;
      get-version )
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
  echo "terraform{" > main.tf
  echo "Where would you like to deploy terraform to?"
  select choice in "gcs" "s3" "http" "kubernetes" "local"; do
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
      local) ;;
      *);;
    esac
    break
  done
  echo "}" >> main.tf
  {
    echo "module mcp{"
    echo "  source = \"github.com/mesoform/terraform-infrastructure-modules//mcp\""
    echo "}"
  } >> main.tf

  cat main.tf
  echo ""
  read -r -p "Are you happy with this configuration? [y]es or [n]o: " accept
    case $accept in
      y )
        echo ""
        echo "Setup Complete"
        echo ""
        entry
        ;;
      n)
        echo ""
        echo "Configuration rejected"
        echo ""
        read -r -p "Restart setup? [y]es or [n]o: " restart
          case $restart in
          y )
            echo ""
            echo "Restarting setup ..."
            echo ""
            runSetup
            ;;
          *)
            echo ""
            echo "Deleting main.tf..."
            echo ""
            rm main.tf
            entry
            ;;
          esac
        ;;
      *)
    esac
  entry

}

gcsBackend(){
  echo "  backend \"gcs\"{" >> main.tf
  read -r -p "Enter bucket name: " bucket
  echo "    bucket = \"${bucket}\"" >> main.tf
  read -r -p "Enter gcs prefix: " prefix
  echo "    prefix = \"${prefix}\""  >> main.tf
  echo "  }" >> main.tf
}

s3Backend(){
  echo "  backend \"gcs\"{" >> main.tf
  read -r -p "Enter bucket name: " bucket
  echo "    bucket = \"${bucket}\"" >> main.tf
  read -r -p "Enter key: " key
  echo "    key = \"${key}\""  >> main.tf
  read -r -p "Enter region: " region
  echo "    folder = \"${region}\""  >> main.tf
  echo "  }" >> main.tf
}

httpBackend(){
  echo "  backend \"gcs\"{" >> main.tf
  read -r -p "Enter address: " address
  echo "    address = \"${address}\"" >> main.tf
  read -r -p "Enter lock address: " lock_address
  echo "    lock_address = \"${lock_address}\""  >> main.tf
  read -r -p "Enter unlock address: " unlock_address
  echo "    unlock_address = \"${unlock_address}\""  >> main.tf
  echo "  }" >> main.tf
}

kubernetesBackend(){
  echo "  backend \"gcs\"{" >> main.tf
  read -r -p "Enter secret suffix: " secret_suffix
  echo "    secret_suffix = \"${secret_suffix}\"" >> main.tf
  read -r -p "Load config file? (true or false): " config
  echo "    load_config_file = ${config}"  >> main.tf
  echo "  }" >> main.tf
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
      platform=${2,,}
      case $platform in
        appengine )
          appEngineVersion
          ;;
        cloudrun )
          cloudRunVersion
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
  echo ""
  echo "App Engine Version Setup"
  echo ""
  read -r -p "Enter project id: " project
  read -r -p "Enter the version name/id: " version
  echo ""
  echo "Continue with these settings? "
  echo "    Project ID: $project"
  echo "    Version: $version "
  echo ""

  select item in "yes" "no" "cancel"; do
    case $item in
      yes )
        terraform workspace new "$BRANCH"
        terraform init
        terraform import 'module.mcp.google_app_engine_application.self[0]' "$project" || echo "Import failed /n" && exit
        versionHelp
        ;;
      cancel )
        echo "Cancelling setup"
        entry
        ;;
      * )
        appEngineVersion
        ;;
    esac
  done
}

cloudRunVersion(){
  echo ""
  echo "Cloud Run Revision Setup"
  echo ""
  read -r -p "Enter project id: " project
  read -r -p "Enter name of the Cloud Run service: " service
  read -r -p "Enter revision name/id: " revision
  read -r -p "Enter the location_id of the service: " location
  echo "Continue with these settings? "
  echo "    Project ID: $project"
  echo "    Service: $service"
  echo "    Revision: $revision"
  echo "    Location: $location "
  echo ""

  select item in "yes" "no" "cancel"; do
    case $item in
      yes )
        terraform workspace new "$BRANCH"
        terraform init
        terraform import "module.mcp.google_cloud_run_service.self[\"${service}\"]" "$location"/"$project"/"$service" || (echo "Import failed" && exit)
        terraform import "module.mcp.google_cloud_run_service_iam_policy.self[\"${service}\"]" projects/"$project"/locations/"$location"/services/"$service" || (echo "Import failed" && exit)
        versionHelp
        ;;
      cancel )
        echo "Cancelling setup"
        entry
        ;;
      * )
        cloudRunVersion
        ;;
    esac
  done
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
  "help" | "-help")
    help
    ;;
  "get" | "-get")
    getState "$@"
    ;;
  "new-version" | "-new-version")
    runNewVersion "$@"
    ;;
  "set-version" | "-set-version")
    runSetVersion "$@"
    ;;
  "get-version" | "-get-version")
    runGetVersion "$@"
    ;;
  "destroy" | "-destroy")
    runDestroy "$@"
    ;;
  *)
    entry
    ;;
esac
