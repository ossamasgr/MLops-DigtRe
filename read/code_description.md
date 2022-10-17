## Repo Details

### Directory Structure

High level directory structure for this repository:

```bash
├── .pipelines              <- Azure DevOps YAML pipelines for  model training and deployment.
    ├── .pipeline/Dev       <- pipelines for Build and Deploy ACI to Dev environment
         ├── templates      <- 
    ├── .pipeline/mlops     <- pipelines for model training, evaluation and registration 
    ├── .pipeline/Prod	    <- pipelines for Deploying the model to Production environment (AKS)
    ├── .pipeline/QA	    <- pipelines for Deploying the model to QA environment 
         ├── templates      <- 
    ├── .pipeline/variables <- pipelines for Deploying the model to QA environment 
├── Build_model	            <- python script that 
├── estimation_engine       <- 
├── helm-prod-aks           <- Helm charts to deploy resources on Azure Kubernetes Service(AKS).
├── ml_service              <- The top-level folder for all Azure Machine Learning resources.
│   ├── pipelines           <- Python script that builds Azure Machine Learning pipelines.
│   ├── util                <- Python script for various utility operations specific to Azure Machine Learning.
├── scripts	            <- Python script that cancel pipeline delete ACI.
├── README.md               <- The top-level README for developers using this project.  
```

### Pipelines

* .pipelines/Dev/Build_and_Deploy.yml : pipeline triggered when the code is merged into **master** . Deploys the model to ACI
* .pipelines/Dev/delete-dev.yml :pipeline triggered when .pipelines/Dev/Build_and_Deploy.yml started and delete the ACI-DEV after 24 hours
* .pipelines/mlops/extract_Prepare.yml :
* .pipelines/mlops/generate_artifacts.yml : pipeline .
* .pipeline/Prod/prod-deploy-to-aks.yml :
* .pipelines/QA/Deploy-to-QA.yml :
* .pipelines/QA/Manual-qa-aci.yml :

### ML Services

* `ml_service/pipelines/` : builds and publishes an ML training pipeline. It uses Python on ML Compute.
* `ml_service/util` : contains common utility functions used to build and publish an ML training pipeline.

### Environment Definitions

* `ml_service/util/conda_dependencies.yml` : Conda environment definition for the environment used for both training and scoring .

### Training , Evaluation , Registering 

* .pipeline/mlops/Train-Evaluate-Register.yml :
  * training step of an ML training pipeline.
  * evaluating step which cancels the pipeline in case of non-improvement.
  * registers a new trained model if evaluation shows the new model is more performant than the previous one.
