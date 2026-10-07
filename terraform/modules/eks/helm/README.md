# Helm — NexPay

The Helm configuration in this directory is used to deploy and configure the AWS Load Balancer Controller in the NexPay EKS cluster.

The `aws-load-balancer-controller-values.yaml` file contains the configuration values passed to the AWS Load Balancer Controller Helm Chart.

Helm uses these values together with the Chart templates to render the Kubernetes resources required by the controller and deploy them to the EKS cluster.

The controller then runs inside Kubernetes and communicates with AWS APIs using the IAM role associated with its Kubernetes ServiceAccount through EKS Pod Identity.

```text
AWS Load Balancer Controller Chart
                |
                +-- values.yaml
                |
                v
              Helm
                |
                v
         Kubernetes Resources
                |
                v
 AWS Load Balancer Controller
                |
                v
            AWS APIs
                |
                v
             ALB / NLB
```

Terraform manages the EKS infrastructure and IAM configuration, while Helm manages the deployment and configuration of the AWS Load Balancer Controller inside Kubernetes.
