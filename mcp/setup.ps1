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
    $folder = Read-Host -Prompt "Enter folder name"
    "    folder = ""$folder""" >> main.tf
    "  }" >> main.tf
}
function s3Backend() {
    "  backend ""gcs""{" >> main.tf
    $bucket = Read-Host -Prompt "Enter bucket name"
    "    bucket = ""$bucket""" >> main.tf
    $key = Read-Host -Prompt "Enter key name"
    "    key = ""$key""" >> main.tf
    $region = Read-Host -Prompt "Enter region"
    "    region = ""$region""" >> main.tf
    "  }" >> main.tf
}
function httpBackend() {
    "  backend ""gcs""{" >> main.tf
    $address = Read-Host -Prompt "Enter address"
    "    address = ""$address""" >> main.tf
    $lock_address = Read-Host -Prompt "Enter lock address"
    "    lock_address = ""$lock_address""" >> main.tf
    $unlock_address = Read-Host -Prompt "Enter unlock address"
    "    unlock_address = ""$unlock_address""" >> main.tf
    "  }" >> main.tf
}
function kubernetesBackend() {
    "  backend ""gcs""{" >> main.tf
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

function entry() {
    Write-Host "------------------------------------------------------"
    Write-Host "Multi-Cloud Plaform Setup"
    Write-Host ""
    Write-Host "Select Option:"
    Write-Host "1: Setup     - Configure main.tf for services"
    Write-Host "2: Deploy    - Deploy Services"
    Write-Host "3: Destroy   - Destroy current infrastructure resources"
    Write-Host "4: Get       - Get the current state of infrastructure"
    Write-Host "5: Exit      - Exit Setup"
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
            runDestroy
            break
        }
        4{
            getState
            break
        }
        5{
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