function runSetup() {
    Write-Host ""
    Write-Host "Initialising terraform ..."
    Write-Host ""
    terraform init
    Write-Host ""
    Write-Host "Creating Plan ..."
    Write-Host ""
    terraform plan -out="plan.tfplan"
    If (Test-Path plan.tfplan){
        $accept = Read-Host -Prompt "Do you wish to apply this plan? (Only 'yes' accepted)"
        switch -Exact ($accept)
        {
            "yes" {
                Write-Host ""
                Write-Host "Applying Plan..."
                Write-Host ""
                terraform apply plan.tfplan
                Remove-Item plan.tfplan
                break
            }
            default {
                Write-Host ""
                Write-Host "Apply Aborted"
                Write-Host ""
            }
        }
    } else {
        Write-Host ""
        Write-Host "Terraform Plan Failed "
        Write-Host ""
        exit
    }
}

function runDestroy(){
    Write-Host ""
    Write-Host "Creating plan for destroying resources..."
    Write-Host ""
    terraform plan -destroy -out="destroy.tfplan"
    If (Test-Path destroy.tfplan){
        $accept = Read-Host -Prompt "Do you wish to destroy resources? (Only 'yes' accepted)"
        switch -Exact ($accept)
        {
            "yes"{
                Write-Host ""
                Write-Host "Destroying resources... "
                Write-Host ""
                terraform destroy -auto-approve
                Remove-Item destroy.tfplan
                break
            }
            default{
                Write-Host ""
                Write-Host "Destroy Aborted "
                Write-Host ""
            }
        }
    } else {
        Write-Host ""
        Write-Host "Destroy plan failed"
        Write-Host ""
        exit
    }
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
    Write-Host "1: Setup     - Deploy services"
    Write-Host "2: Destroy   - Destroy current infrastructure resources"
    Write-Host "3: Get       - Get the current state of infrastructure"
    Write-Host "4: Exit      - Exit Setup"
    Write-Host ""
    $choice = Read-Host -Prompt "Input Choice"
    switch ($choice)
    {
        1{
            runSetup
            break
        }
        2{
            runDestroy
            break
        }
        3{
            getState
            break
        }
        4{
            exit
        }
        default{
            Write-Host ""
            Write-Host "Invalid Inupt"
            Write-Host ""
            entry
        }
    }
    entry
}

entry