# K8S adapter
## Contents
[deployment](#deployment)  
[service](#service)     
[pod](#pod)     

## deployment
The K8S_deployment converter module is designed to create a DEPLOYMENT in an existing Kubrenetes cluster.
The parameters of the created DEPLOYMENT are described in the yml file, which includes such required parameters as metadata and spec.
The structure of the DEPLOYMENT description for the K8S_deployment converter
is the closest to the structure of the DEPLOYMENT description when working with the KUBECTL utility.
This allows the existing descriptions of the DEPLOYMENT structure to be used
when working with the Multi-Cloud Platform Module with minimal adaptation.
An example of a yml file describing DEPLOYMENT for the K8S_deployment converter:
```yamlex
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

## service
A Service is an abstraction which defines a logical set of pods and a policy by which to access them - sometimes called a micro-service.

The K8S_service converter module is designed to create a SERVICE for a specified DEPLOYMENT or POD in an existing Kubrenetes cluster.
The parameters of the created SERVICE are described in the yml file, which includes such required parameters as metadata and spec.
The structure of the SERVICE description for the K8S_service converter is most closely approximated
to the structure of the SERVICE description when working with the KUBECTL utility. This allows existing descriptions
of the SERVICE structure to be used when working with the Multi-Cloud Platform Module with minimal adaptation.
An example of a yml file describing SERVICE for the K8S_service converter:
```yamlex
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

## pod
A pod is a group of one or more containers, the shared storage for those containers, and options about how to run the containers.
Pods are always co-located and co-scheduled, and run in a shared context.

The K8S_pod converter module is designed to create a POD in an existing Kubrenetes cluster.
The parameters of the generated POD are described in the yml file, which includes such required parameters as metadata and spec.
The structure of the POD description for the K8S_pod converter is the closest to the structure of the
POD description when working with the KUBECTL utility. This allows existing POD structure descriptions to be used
when working with the Multi-Cloud Platform Module with minimal adaptation.
An example of a yml file describing a POD for the K8S_pod converter:
```yamlex
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
