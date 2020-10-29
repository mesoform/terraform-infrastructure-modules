#!/usr/bin/env bash
set -o pipefail

entry(){
  echo ""
  echo "Multi-Cloud-Platform Setup"
  echo ""
  echo "Select Option: "

  select choice in "setup" "get" "destroy" "help" "exit"; do
    case $choice in 
      setup )
        installDependencies
        runSetup
        ;;
      get )
        installDependencies
        getState
        ;;
      destroy )
        installDependencies
        runDestroy
        ;;
      help) help;;
      exit) exit;;
      *) exit;;
    esac
  done
  exit
}

help() {
  echo "Usage: ${SCRIPT_NAME} <command> [options]"
  echo ""
  echo "Commands:"
  echo "  setup      Setup Terraform service deployment"
  echo "  get        Get Terraform state for current direectory"
  echo "  destroy    Destroy Terraform infrastructure"
  echo ""
  entry
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
    TERRAFORM_URL_LIN=https://releases.hashicorp.com/terraform/0.13.5/terraform_0.13.5_linux_amd64.zip
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
        TERRAFORM_URL_DAR=https://releases.hashicorp.com/terraform/0.11.14/terraform_0.11.14_darwin_amd64.zip
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

runSetup() {
  echo ""
  echo "Initialising terraform ..."
  echo ""
  terraform init
  echo ""
  echo "Creating Plan ..."
  echo ""
  terraform plan -var-file="./settings.tfvars" -out="plan.tfplan" 
  if [ -e plan.tfplan ] 
  then 
    read -r -p "Do you wish to apply this plan? (Only 'yes' accepted): " accept
    case $accept in 
      yes ) 
        echo ""
        echo "Applying Plan..."
        echo ""
        terraform apply plan.tfplan 
        rm plan.tfplan
        ;;
      *)
        echo ""
        echo "Applying Aborted"
        echo ""
        ;;
    esac
  else
    echo "Terraform plan failed" | exit 1
  fi
  entry
}

runDestroy() {
  echo ""
  echo "Creating plan for destroying resources..."
  echo ""
  terraform plan -destroy
  read -r -p "Do you wish to destroy resources as shown? (Only 'yes' accepted): " accept
    case $accept in 
      yes ) 
        echo ""
        echo "Destroying resources..."
        echo ""
        terraform destroy -auto-approve
        ;;
      *)
        echo ""
        echo "Destroy Aborted"
        echo ""
        ;;
    esac
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
  "setup" | "-setup")
    installDependencies
    runSetup
    ;;
  
  "help" | "-help")
    help
    ;;
  "get" | "-get")
    getState
    ;;
  "destroy" | "-destroy")
    runDestroy
    ;;
  *)
    entry
    ;;
esac
