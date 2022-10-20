## Deploy AKS Using Helm Chart

- [About Helm Chart](#about)
- [Helm Chart Structure](#HelmChartStructure)
- [AutoScaling](#AutoScaling)
- [Usage](#usage)

## About Helm Chart

Helm Charts are a collection of files that describe a related set of Kubernetes resources. A chart can be used to describe a simple pod of a complex application. This chart deploys the DigitRE API Image on AKS.

## Helm Chart Structure

Directory structure for helm chart files :

```bash
├── .helmignore                   <- Files to be ignored by helm package.
├── Chart.yaml                    <- The Chart.yaml file describes the package.
├── values.yaml                   <- The default configuration values for this chart.
├── templates                     <- A directory of templates that, when combined with values, will generate valid Kubernetes manifest files.
    ├── deployment.yaml           <- The deployment definition.
    ├── service.yaml              <- The service definition.
    ├── hpa.yaml                  <- The horizontal pod autoscaler definition.
    ├── _helpers.tpl              <- Template helpers that provide functions for use in other templates.
```

## Auto Scaling

- Horizontal Pod Autoscaler (HPA) is used to scale the number of pods in a replication controller, deployment, replica set, or stateful set based on observed CPU utilization (or, with custom metrics support, on some other application-provided metrics).
- Horizontal Pod Autoscaler is configured to scale the number of pods based on the CPU utilization of the pods.

  ![1666271133497](image/README/1666271133497.png)

**File values.yml**

```bash
replicaCount: 1
image:
  repository: `<repository-name>`
  tag: `<image-tag>`
  pullPolicy: IfNotPresent
node selector: {}
resources: {}
```

## To deploy the chart with the release name :

```bash
$ helm install engine  -n engine 
```

* The command deploys DigitRE API on the Kubernetes cluster in the default configuration. The [configuration](#configuration) section lists the parameters that can be configured during installation.
* **Tip**: List all releases using `helm list`

## Uninstalling the Chart

* To uninstall/delete the `my-release` deployment:

```bash
$ helm delete my-release -n engine
```

* The command removes all the Kubernetes components associated with the chart and deletes the release.
* **Tip**: Use `helm list` to verify the deployment was deleted

---



## Configuration

The following table lists the configurable parameters of the DigitRE API chart and their default values.

| Parameter                                      | Description                          | Default          |
| ---------------------------------------------- | ------------------------------------ | ---------------- |
| `replicaCount`                               | Number of replicas to run            | `1`            |
| `image.repository`                           | Name of the image                    | `engine`       |
| `image.tag`                                  | Tag of the image                     | `latest`       |
| `image.pullPolicy`                           | Pull policy for the image            | `ifNotPresent` |
| `service.type`                               | Type of the service                  | `LoadBalancer` |
| `service.port`                               | Port of the service                  | `80`           |
| `resources`                                  | Resources to be allocated to the pod | `{}`           |
| `autoscaling.enabled`                        | Enable autoscaling                   | `false`        |
| `autoscaling.minReplicas`                    | Minimum replicas to scale            | 3                |
| `autoscaling.maxReplicas`                    | Maximum replicas to scale            | `100`          |
| `autoscaling.targetCPUUtilizationPercentage` | CPU utilization to scale             | `50`           |
| `nodeSelector`                               | Node selector                        | `{}`           |
| `tolerations`                                | Tolerations                          | `[]`           |
| `affinity`                                   | Affinity                             | `{}`           |

---



## Usage

> **Tip**: helm and kubectl commands

```bash
# To deploy a specifig version
helm install engine helm-prod-aks --namespace engine  --set image.tag=<TAG>

# update if deployment already exist
helm upgrade engine helm-prod-aks --namespace engine --set image.tag=<TAG>

# Install the chart with the release name <release-name>:
helm install engine -n engine .

# To list the releases:
$ helm list -n engine

# Get the URL of the API
kubectl get ingress -n engine

# Get the API Key
kubectl get secret -n engine -o jsonpath="{.data.api-key}" | base64 --decode

# Get the API URL
kubectl get ingress -n engine -o jsonpath="{.spec.rules[0].host}"

# watch autoscaling
watch kubectl get hpa -A

# view all pod  
kubectl get pods -n engine

# view nodes  
kubectl get nodes

# view services of the API 
kubectl get svc -n engine

```

> ## `Note`

If you wanna change the CPU utilization to scale Go to File hpa.yaml and change the value of targetCPUUtilizationPercentage

```bash
apiVersion: autoscaling/v2beta1
kind: HorizontalPodAutoscaler
metadata:
  name: engine-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: engine
  minReplicas: 3
  maxReplicas: 100
  metrics:
  - type: Resource
    resource:
      name: cpu
      targetAverageUtilization: 50

```
