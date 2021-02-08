function runSetup() {
    "terraform{" > main.tf
    Write-Host ""
    Write-Host "Configure backend"
    Write-Host ""
    Write-Host "Select Option:"
    Write-Host "1: GCS"
    Write-Host "2: s3"
    Write-Host "3: http"
    Write-Host "4: kubernetes"
    Write-Host "5: local"
    $choice = Read-Host -Prompt "Input Choice"
    switch ($choice)
    {
        1{
            gcsBackend
            break
        }
        2{
            s3Backend
            break
        }
        3{
            httpBackend
            break
        }
        4{
            kubernetesBackend
            break
        }
        5{
            break
        }
        Default {
            break
        }
    }
    "}" >> main.tf
    "module mcp{" >> main.tf
    "  source = ""github.com/mesoform/terraform-infrastructure-modules//mcp""" >> main.tf
    "}" >> main.tf

    cat main.tf
    $accept = Read-Host -Prompt "Are you happy with this configuration? [y]es or [n]o"
    switch ($accept)
    {
        y {
            Write-Host ""
            Write-Host "Setup Complete"
            Write-Host ""
            break
        }
        n {
            Write-Host ""
            Write-Host "Configuration rejected"
            Write-Host ""
            $restart = Read-Host -Prompt "Restart setup? [y]es or [n]o: "
            switch ($restart)
            {
                y {
                    Write-Host ""
                    Write-Host "Restarting setup ... "
                    Write-Host ""
                    runSetup
                    break
                }
                Default {
                    Write-Host ""
                    Write-Host "Deleting main.tf ..."
                    Write-Host ""
                    rm main.tf
                    entry
                    break
                }
            }
            break
        }
        Default {
            Write-Host ""
            Write-Host "Invalid choice, configuration rejected"
            Write-Host ""
            break
        }
    }
    entry
}

function gcsBackend() {
    "  backend ""gcs""{" >> main.tf
    $bucket = Read-Host -Prompt "Enter bucket name"
    "    bucket = ""$bucket""" >> main.tf
    $prefix = Read-Host -Prompt "Enter gcs prfix"
    "    prefix = ""$prefix""" >> main.tf
    "  }" >> main.tf
}

function s3Backend() {
    "  backend ""s3""{" >> main.tf
    $bucket = Read-Host -Prompt "Enter bucket name"
    "    bucket = ""$bucket""" >> main.tf
    $key = Read-Host -Prompt "Enter key name"
    "    key = ""$key""" >> main.tf
    $region = Read-Host -Prompt "Enter region"
    "    region = ""$region""" >> main.tf
    "  }" >> main.tf
}

function httpBackend() {
    "  backend ""http""{" >> main.tf
    $address = Read-Host -Prompt "Enter address"
    "    address = ""$address""" >> main.tf
    $lock_address = Read-Host -Prompt "Enter lock address"
    "    lock_address = ""$lock_address""" >> main.tf
    $unlock_address = Read-Host -Prompt "Enter unlock address"
    "    unlock_address = ""$unlock_address""" >> main.tf
    "  }" >> main.tf
}

function kubernetesBackend() {
    "  backend ""kubernetes""{" >> main.tf
    $secret_suffix = Read-Host -Prompt "Ebter secret suffix: "
    "    secret_suffix = ""$secret_suffix""" >> main.tf
    $load_config_file = Read-Host -Prompt "Load config file?"
    "    load_config_file = ""$load_config_file""" >> main.tf
    "  }" >> main.tf
}

function runDeploy() {
    Write-Host ""
    Write-Host "Initialising terraform ..."
    Write-Host ""
    terraform init
    terraform apply
}

function runDestroy(){
    Write-Host ""
    Write-Host "Creating plan for destroying resources..."
    Write-Host ""
    terraform destroy
}

function getState() {
    Write-Host ""
    Write-Host "Getting Terraform state ... "
    Write-Host ""
    terraform refresh
    terraform show
}

function runNewVersion(){
    Write-Host ""
    Write-Host "Checking for repository ... "
    Write-Host ""
    Write-Host "New version of: 1) AppEngine   2) Cloudrun "
    Write-Host "    1) App Engine  "
    Write-Host "    2) Cloud Run "
    Write-Host "    3) Cancel "
    Write-Host ""
    $choice = Read-Host
    switch ($choice) {
        1{
            appEngineVersion
            break
        }
        2{
            cloudRunVersion
            break
        }
        3{
            entry
            break
        }
        default{
            Write-Host ""
            Write-Host "Invalid Inupt"
            Write-Host ""
            runNewVersion
            break
        }
    }

}

function appEngineVersion(){
    Write-Host ""
    Write-Host "App Engine Versionn Setup"
    Write-Host ""
    $project = Read-Host -Prompt "Enter project id: "
    $version = Read-Host -Prompt "Enter version name/id: "
    Write-Host "Continue with these settings? "
    Write-Host "    Project Id: $project"
    Write-Host "    version: $version"
    $continue = Read-Host -Prompt "[y]es, [n]o or [c]ancel"
    switch ($continue){
        y{
            cd terraform
            terraform workspace new $branch
            terraform init
            try {
                terraform import 'module.mcp.google_app_engine_application.self[0]' "$project"
            }
            catch {
                Write-Host "Import Failed"
                exit
            }
            break
        }
        n{
            appEngineVersion
            break
        }
        c{
            Write-Host ""
            Write-Host "Cancelled Version Setup"
            Write-Host ""
            entry
            break
        }
        default{
            Write-Host "Invalid choice"
            appEngineVersion
            break
        }
    }
}

function cloudRunVersion(){
    Write-Host ""
    Write-Host "Cloud Run Revision Setup"
    Write-Host ""
    $project = Read-Host -Prompt "Enter project id: "
    $service = Read-Host -Prompt "Enter name of the Cloud Run service: "
    $revision = Read-Host -Prompt "Enter revision name/id: "
    $location = Read-Host -Prompt "Enter the location_id of the service: "
    Write-Host "Continue with these settings? "
    Write-Host "    Project Id: $project"
    Write-Host "    Service: $service"
    Write-Host "    Revision: $revision"
    Write-Host "    Location: $location"
    $continue = Read-Host -Prompt "[y]es, [n]o or [c]ancel"
    switch ($continue){
        y{
            cd terraform
            terraform workspace new $branch
            terraform init
            try {
                terraform import "module.mcp.google_cloud_run_service.self[\"${service}\"]" "$location"/"$project"/"$service"
                terraform import "module.mcp.google_cloud_run_service_iam_policy.self[\"${service}\"]" projects/"$project"/locations/"$location"/services/"$service"
            }
            catch {
                Write-Host "Import Failed"
                exit
            }
            versionHelp
            break
        }
        n{
            cloudRunVersion
            break
        }
        c{
            Write-Host ""
            Write-Host "Cancelled Version Setup"
            Write-Host ""
            entry
            break
        }
        default{
            cloudRunVersion
            break
        }
    }
}

function versionHelp(){
    Write-Host ""
    Write-Host "Workspace Setup and Imports Completed"
    Write-Host ""
    Write-Host "To update the version for your services: "
    Write-Host "  1. Update the version ID or revision name, as well as any other configuration changes, in the relevant yaml files"
    Write-Host "  2. Run 'terraform apply' to deploy changes"
    Write-Host "  3. Run 'git add -A && commit -m ""<commit message>""' to commit changes to yaml files and state files"
    Write-Host ""
    entry
}

function entry() {
    Write-Host "------------------------------------------------------"
    Write-Host "Multi-Cloud Plaform Setup"
    Write-Host ""
    Write-Host "Select Option:"
    Write-Host "1: Setup       - Configure main.tf for services"
    Write-Host "2: Deploy      - Deploy Services"
    Write-Host "3: New version - Set up new version of deployment"
    Write-Host "4: Destroy     - Destroy current infrastructure resources"
    Write-Host "5: Get         - Get the current state of infrastructure"
    Write-Host "6: Exit        - Exit Setup"
    Write-Host ""
    $choice = Read-Host -Prompt "Input Choice"
    switch ($choice)
    {
        1{
            runSetup
            break
        }
        2{
            runDeploy
            break
        }
        3{
            runNewVersion
            break
        }       
        4{
            runDestroy
            break
        }
        5{
            getState
            break
        }
        6{
            exit
        }
        default{
            Write-Host ""
            Write-Host "Invalid Inupt"
            Write-Host ""
            entry
            break
        }
    }
}

entry