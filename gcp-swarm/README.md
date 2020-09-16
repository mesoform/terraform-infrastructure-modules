Auth with service account:  beekeeper@swarm-testing.iam.gserviceaccount.com

```
$ gcloud auth list
                  Credentialed Accounts
ACTIVE  ACCOUNT
*       beekeeper@swarm-testing.iam.gserviceaccount.com
To set the active account, run:
    $ gcloud config set account `ACCOUNT`
```


To create network and instances:
```bash
$ cd terraform-infrastructure-modules/gcp-swarm/terraform
$ terraform init
$ terraform plan -var-file=dev.tfvars -var project_id=my-project -var
$ terraform apply -var-file=dev.tfvars
```

To provision and setup docker swarm cluster:
```bash
$ cd ../ansible/
$ ansible-playbook -i inventory main.yml
```

This will setup a 3 node docker swarm cluster