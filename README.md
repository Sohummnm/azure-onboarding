# PLATFORM-ENGINEERING
# azure-customer-onboarding

This repo onboards customers to the aks platform by creating their azure infra resources as well as kubernetes resources and give them their namespace level access.

Onboarding customer requires repetative mannual tasks like creating their individual Azure Infra as well as Kubernetes resources so that they can run their workloads.  

This REPO intends to use following tools:
Terraform : for provisioning azure resources 
Helm : for creating kubernetes resources for customer
Azure Devops Pipeline : for orchestrating the onboarding process.  

------------------------------------------------------------------------------------------------------
Authentication

Authentication is required on two levels:
1. Customer group should have access to the cluster as well as it should be restricted to their namespace only. 
2. Workloads should have access to the azure resources which is achieved by User Assigned managed Identity + Federated Identity Credential [OIDC] mapped to the Kubernetes Service Account which will mapped with Federated Credential in the subject section.
3. Customers can use this service account + annotate their workloads with User Assigned Managed Identity Client ID for authentication and authorization. 

------------------------------------------------------------------------------------------------------
HELM 

1. Its a modular helm chart which can be used for multiple customer onboarding.
2. It takes all values from the customer specific values.yaml which is passed in the pipeline.
3. It creates multiple kubernetes resources which a multi tenant kubernetes cluster should have for its customers, which includes:- Limit Ranges, Resource Quotas, Service account, Role, RoleBinding, Network Policy.
4. We dont create customer namespace through helm chart, becuase helm requires namespace to exist before installing chart; we do this through
azure devops pipeline using --create-namespace flag using arguments attribute in  "K8s resources" stage.

------------------------------------------------------------------------------------------------------
Terraform

1. Tfstate for each customer is stored remotely within azure blob container as a key. 
2. It uses terraform_remote_state data block to fetch the oidc issuer url "AKS cluster URL" from its own backend.
3. It creates User Assigned Managed Identity, Federated Credential [OIDC] for the customer.
4. It provides UAMI Client ID, Namespace, Kubernetes Service Account name as an output for Customer's reference. 
5. It injects all the variables from the Azure Devops Pipeline. 

------------------------------------------------------------------------------------------------------------
Azure Devops Pipeline

1. It takes input paramaters which is injected as our terraform variables.
2. It first provisions the azure infra like uami, federated creds for the customer and its workloads. 
3. It then creates kubernetes resources using Helm Chart we have. 
4. Helm requires namespace to apply the chart. So we create customer namespace in the pipeline using --create-namespace flag using arguments attribute in  "K8s resources" stage.
