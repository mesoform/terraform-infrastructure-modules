## MMCF Kubernetes adapter
### Information

To use kubernetes modules the `KUBE_CONFIG_PATH` environment variable must be set to the path of the config file.  
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

Kubernetes adapter for MMCF is designed to create Kubernetes resources in existing kubernetes clusters.
YAML is used to describe the configuration of Kubernetes resources.
The configuration is done within a `k8s.yml` file which defines the kubernetes resources to deploy for each service/application.

Structure is as shown below:
```yaml
components:
  specs:
    app_1: 
      deployment:
        ...
      secret:
        ...
    app_2:
      stateful_set:
        ...
      persistent_volume_claim:
        ...
      ...
```
The structure of the blocks for each of the modules are very similar to the structure used when working with the kubectl utility.
This allows existing kubernetes descriptions to be used when working with the Multi-CLoud-Platform module with minimum adaptation required.   
Kubernetes adapter modules are located in the mcp directory, in which other MMCF modules can be located.
The following Kubernetes adapter modules are currently available:

* [deployment](#deployment)
* [service](#service)
* [pod](#pod)
* [secret](#secret)
* [config_map](#config_map)
* [ingress](#ingress)
* [stateful_set](#stateful_set)
* [persistent_volume](#persistent_volume)
* [persistent_volume_claim](#persistent_volume_claim)
* [job](#job)
* [cron_job](#cron_job)
* [pod_autoscaler](#pod_autoscaler)

More information can be found about configuration of these resources in the  [Terraform]() and [Kubernetes]() documentation.

### deployment

The `K8S_deployment.tf` module is designed to create a deployment resource in an existing Kubrenetes cluster.
The parameters for the created deployment are described in the k8s_deployment.yml file, which includes
the required metadata and spec parameters.  
An example of a `deployment` block in `k8s.yml`:

```yaml
components:
  specs:
    app_1:
      deployment:
        metadata:
          name: "terraform-examlpe"
          namespace:
          labels:
            test: "MyExampleApp"
        spec:
          replicas: 2
          selector:
            match_labels:
              test: "MyExampleApp"
          template:
            metadata:
              labels:
                test: "MyExampleApp"
            spec:
              container:
                - name: "example"
                  image: "nginx:1.7.8"
                  resources:
                    limits:
                      cpu: "0.5"
                      memory: "512Mi"
                      requests:
                        cpu: "250m"
                        memory: "50Mi"
                  liveness_probe:
                    http_get:
                      port: 80
                      http_header:
                        name: X-Custom-Header
                        value: Awesome
                    initial_delay_seconds: 3
                    period_seconds: 3
```

### service

A Service is an abstraction which defines a logical set of pods and a policy by which to access them - sometimes called a micro-service.

The `K8S_service.tf` module is designed to create a service resource for a specified deployment or pod in an existing Kubrenetes cluster.
The parameters of the created service are described in the `service` block in `k8s.yml`, which includes the required metadata and spec parameters.  
An example of a `service` block in `k8s.yml`:

```yaml
components:
  specs:
    app_1:
      service:                  #Block starts here
        metadata:
          name: "terraform-example"
          namespace:
          labels:
            env: "test"
          generate_name:
        spec:
          selector:
            test: "MyExampleApp"
          port:
            - name: "nginx-listener"
              port: 8080
              target_port: 80
          type: LoadBalancer

```

### pod

A pod is a group of one or more containers, the shared storage for those containers, and options about how to run the containers.
Pods are always co-located and co-scheduled, and run in a shared context.

The `K8S_pod.tf` module is designed to create a pod resource in an existing Kubrenetes cluster.
The parameters for the generated pod are described in a `pod` block in the `k8s.yml` file, which includes
the required metadata and spec parameters.
An example of a `pod` block in `k8s.yml`:

```yaml
components:
  specs:
    app_1:
      pod:                  #Block starts here
        metadata:
          name: "nginx-example"
          namespace:
          labels:
            app: "TestApp"
        spec:
          dns_policy: None
          dns_config:
            nameservers:
              - 1.1.1.1
              - 8.8.8.8
              - 9.9.9.9
            searches:
              - example.com
            option:
              - name: ndots
                value: 1
              - name: use-vc
          env:
            name: environment
            value: test
          container:
            - name: "nginx-example"
              image: "nginx:1.7.8"
              port:
                - container_port: 8080
              liveness_probe:
                http_get:
                  port: 80
                  http_header:
                    name: X-Custom-Header
                    value: Awesome
                initial_delay_seconds: 3
                period_seconds: 3
```
### secret

The resource provides mechanisms to inject containers with sensitive information, such as passwords,
while keeping containers agnostic of Kubernetes. Secrets can be used to store sensitive information
either as individual properties or coarse-grained entries like entire files or JSON blobs.
The resource will by default create a secret which is available to any pod in the specified (or default) namespace.

The K8S_secret.tf module allows you to create a secret resource for its subsequent connection to the running container as volume.
The parameters of the created secret are described in the `secret` block in the `k8s.yml` file, which includes the required metadata parameter.
If necessary, transfer data from a file to the container, the file name and path to it are specified in the data_file section.
An example of a `secret` block in `k8s.yml`:

```yaml
components:
  specs:
    app_1:
      secret:                  #Block starts here
        metadata:
          name: "mosquitto-secret-file"
          labels:
            env: "test"
        type: Opaque
        data_file:
          - ../mosquitto/secret.file
```

### config_map

The resource provides mechanisms to inject containers with configuration data while keeping
containers agnostic of Kubernetes. Config Map can be used to store fine-grained information like
individual properties or coarse-grained information like entire config files or JSON blobs.

The `k8s_config_map.tf` module allows you to create a config_map resource for its subsequent connection
to a running container as volume. The parameters of the generated config_map are described in the `config_map` block of `k8s.yml` file,
which includes the required metadata parameter.  
If necessary, transfer data from a file to the container, the file name and path to it are specified in the data_file section.
An example of the `config_map` block in `k8s.yml`:

```yaml
components:
  specs:
    app_1:
      config_map:                  #Block starts here
        metadata:
          name: "mosquitto-config-file"
          labels:
            env: "test"
        data_file:
          - ../mosquitto/mosquitto.conf
```
### ingress
The resource defines a collection of rules to allow inbound connections to reach the endpoints defined by a backend.
Configuring Ingress can load balance traffic, terminate SSL, give external reachable urls and more.
An example of an `ingress` block in `k8s.yml`:

```yaml
components:
  specs:
    app_1:
      ingress:
        metadata:
          name: "example-ingress"
        spec:
          backend:
            service_name: "service"
            service_port: 8080
          rule:
            host:
            http:
              paths:
                - path: "/"
                  backend:
                    service_port: 8080
                    service_name: "service"

```

### stateful_set
Similarly to Deployment, StatefulSet manages Pods based on a container spec, but unlike Deployment, a statefulset maintains an identity for each pod.
Each pod has a persistent identifier that persists through rescheduling, and can claim a persistent_volume.
The `stateful_set` block in `k8s.yml` file is used to configure the deployment of a StatefulSet resource.  
**NOTE**: A template of a pod may be specified in `spec.template.spec`, which would be configured in the same way that [k8s_pod.yml](#pod) spec was.
Similarly `spec.volume_claim_template` is configured the same as [k8s_persistent_volume_claim.yml](#persistent_volume_claim).

Attributes configuration:

| Key | Type | Required | Description | Default |
|:----|:----:|:--------:|:------------|:-------:|
| `spec.selector.match_labels`| list | true | **(Must match pods template labels)** Label query over pods ht should match replica count | none |
| `spec.service_name`| string | true | Name of the service that governs StatefulSet **(Must exist before the StatfulSet)** | none |
| `spec.template`| map | true | Describes the pod that will be created | none |
| `spec.template.metadata`| map | true | Standard objects metadata | none |
| `spec.template.spec`| map | false | Pod spec template (see spec section of [k8s_pod.yml](#pod))  | none |
| `spec.volume_claim_template`| map | false | list of volume claims that pods can reference (see [k8s_persistent_volume_claim.yml](#persistent_volume_claim)) | none |


An example of `stateful_set` block in 'k8s.yml' file:
```yaml
components:
  specs:
    app_1:
      stateful_set:
        metadata:
          name: "something"
        spec:
          selector:
            match_labels:
              "k8s-app": "prometheus"
          template:
            metadata:
              namespace:
            #This section is the configured the same as pod spec block
            spec:
              ...
          #This section is configured the same as persistent_volume_claim
          volume_claim_template:
             ...
```

### persistent_volume
Persistent volumes are a piece of storage in the cluster, which have a lifecycle independent of any individual pod that uses it.
Configuration for a persistent_volume is done with k8s_persistent_volume.yml.  
Attributes configuration:

| Key | Type | Required | Description | Default |
|:----|:----:|:--------:|:------------|:-------:|
| `spec.access_modes`| list | true | All ways the volume can be mounted. Can be: `"ReadWriteOnce"`, `"ReadOnlyMany"`,`"ReadWriteMany"` | none |
| `spec.capacity`| map | true | description of persistent volumes resources and capacity | none |
| `spec.persistent_volume_source`| map | true | The specs of persistent volume, see [types](https://kubernetes.io/docs/concepts/storage/volumes/#types-of-volumes) and [terraform implmentation](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/persistent_volume#persistent_volume_source) | none |
| `spec.storage_class_name`| string | false | Name of the persistent volumes storage class | "Standard" |
| `spec.node_affinity.required.node_selector_term`| map | true if `spec.node_affinity` | node selector term with `match_expressions` and `match_fields` attributes ORed | none |
| `match_expressions` or `match_fields`| map |false | Expression or field to map with attributes: `key`, `operator` (`"In"`, `"NotIn"`, `"Exists"`, `"DoesNotExist"`) and `values`([details](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/persistent_volume_claim#values)) | none |  

An example of a `persistent_volume` block in a `k8s.yml` file:
```yaml
components:
  specs:
    app_1: 
      perisitent_volume:
        metadata:
          name: "something"
        spec:
          capacity:
            "storage": "10Gi"
          access_modes:
            - "ReadWriteMany"
          persistent_volume_source:
            vsphere_volume:
              volume_path: "/path"
```

### persistent_volume_claim
This adapter can request for persistent volume and claim it.  
`spec.volume_name` specifies the binding reference for the persistent volume backing the claim.
If also using a `persistent_volume` blcok, `volume_name` will be set to the name assigned to that resource.
Otherwise `spec.volume_name` can be specified to link to an already existing persistent volume


An example of a `persisitent_volume_claim` block in `k8s.yml` file:
```yaml
components:
  specs:
    app_1:
      peristent_volume_claim:
        metadata:
          name: "something"
        spec:
          access_modes:
            - "ReadWriteMany"
          resources:
            requests:
              storage: "5Gi"      
          volume_name: "volume"
```

### job
The resource creates pods and attempts execution until the specified number successfully terminate.
The Job will track successful completions and will complete when a the number of specified completions is complete.
Jobs can also be used to run multiple pods in parallel.

An example `job` block in `k8s.yml` file:
```yaml
components:
  specs:
    app_1:
      job:
        metadata:
          name: pi
        spec:
          backoff_limit: 4
          template:
            spec:
              container:
                - name: pi
                  image: perl
                  command:
                    - "perl"
                    - "-Mbignum=bpi"
                    - "-wle"
                    - "print bpi(2000)"
              restart_policy: Never
        wait_for_completion: true

```

### cron_job
The `cron_job` resource creates `jobs` in a repeating time based schedule.
An example of a `cron_job` block in 'k8s.yml':
```yaml
components:
  specs:
    app_1:
      cron_job:
        metadata:
          name: demo
        spec:
          concurrency_policy: Replace
          failed_jobs_history_limit: 5
          schedule: "1 0 * * *"
          starting_deadline_seconds: 10
          successful_jobs_history_limit: 10
          job_template:
            spec:
              backoff_limit: 2
              ttl_seconds_after_finished: 10
              template:
                spec:
                  container:
                    - name: hello
                      image: busybox
                      command:
                        - "/bin/sh"
                        - "-c"
                        - "date; echo Hello from Kubernetes cluster"


```

### pod_autoscaler
The `pod_autoscaler` block defines a Horizontal Pod Autoscaler, which automatically scales the number of pods in a
replication controller, deployment, replica set or stateful set based on CPU utilization.

An example of a `pod_autoscaler` block in `k8s.yml`:
```yaml
components:
  specs:
    app_1:
      pod_autoscaler:
        metadata:
          name: test
        spec:
          max_replicas: 100
          min_replicas: 50
          scale_target_ref:
            kind: Deployment
            name: MyApp
          metric:
            type: External
            external:
              metric:
                name: latency
                selector:
                  match_labels:
                    lb_name: test
              target:
                type: Value
                value: 100

```