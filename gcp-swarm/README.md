Auth with service account:  beekeeper@swarm-testing.iam.gserviceaccount.com by setting `credentials = file("account.json")`
to the path for to a token file in the provider, or set GCLOUD_KEYFILE_JSON to the path.

If you are running outside of Google Cloud and don't want to use a key you can set the application
default credentials to an identity which has the correct roles
```
gcloud auth application-default login
```
This opens a browser to request access for an identity like your own user account. Provided that it
has suitable permissions for the task, Terraform will read the file generated from this process. use
`--no-launch-browser` if behind a firewall.

To create network and instances:
```bash
$ cd terraform-infrastructure-modules/gcp-swarm/terraform
$ terraform init
$ terraform plan -var-file=dev.tfvars
$ terraform apply -var-file=dev.tfvars
```

To provision and setup docker swarm cluster:
```bash
$ cd ../ansible/
$ ansible-playbook -i inventory main.yml
```

This will setup a 3 node docker swarm cluster