## Repo Details

### Directory Structure

High level directory structure for this repository:

```bash
├── .pipelines            <- Azure DevOps YAML pipelines for  model training and deployment.
    ├── .pipeline/Dev     <- pipelines for Build and Deploy ACI to Dev environment
         ├── templates    <- 
    ├── .pipeline/mlops   <- pipelines for model training, evaluation and registration 
    ├── .pipeline/Prod	  <- pipelines for Deploying the model to Production environment (AKS)
    ├── .pipeline/QA	  <- pipelines for Deploying the model to QA environment 
         ├── templates    <- 
├── Build_model	          <- python script that 
├── helm-prod-aks         <- Helm charts to deploy resources on Azure Kubernetes Service(AKS).
├── ml_service            <- The top-level folder for all Azure Machine Learning resources.
│   ├── pipelines         <- Python script that builds Azure Machine Learning pipelines.
│   ├── util              <- Python script for various utility operations specific to Azure Machine Learning.
├── scripts	          <- Python script that cancel pipeline delete ACI.
├── README.md             <- The top-level README for developers using this project.  
```

### Environment Setup


### Pipelines

### ML Services

### Environment Definitions

### Training Step

### Evaluation Step

### Registering Step
