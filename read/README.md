# DigitRE DEV-ML-OPS Getting Started

## Sommaire

- [Azure Devops ]()
  - [Azure Repos]()
    - [Digitre-estimation-engine]()
    - [Devops-MLops]()
  - [Azure Pipelines]()
    - [[ML]-[Extract-Prepare]]()
      - [Functionality]()
      - [Triggers]()
      - [Approvals]()
    - [[ML]-Train-Evaluate-Register]()
      - [Functionality]()
      - [Triggers]()
      - [Approvals]()
    - [[DEV]-Build_and_Deploy]()
      - [Functionality]()
      - [Triggers]()
      - [Approvals]()
    - [[Dev]-Delete-After-24Hours]()
      - [Functionality]()
      - [Triggers]()
      - [Approvals]()
    - [[QA]-Deploy]()
      - [Functionality]()
      - [Triggers]()
      - [Approvals]()
    - [[Manual]-[Custom-QA]-Deploy]()
      - [Functionality]()
      - [Triggers]()
      - [Approvals]()
    - [[Manual]-[Prod]-deployment]()
      - [Functionality]()
      - [Triggers]()
      - [Approvals]()
  - [Azure Dashboard]()

## 1. Azure Devops

### Azure Repos

#### Digitre-estimation-engine

#### Devops-MLops

![image](https://user-images.githubusercontent.com/59144753/195838820-a3a8895b-7a53-4c60-ba64-17d0b777571e.png)

### Directory Structure

High level directory structure for this repository:

```bash
├── .pipelines              <- Azure DevOps YAML pipelines and templates for  Dev deployments.
    ├── .pipeline/Dev       <- pipelines for Build and Deploy ACI to Dev environment
         ├── templates      <- templates for dev pipelines 
    ├── .pipeline/mlops     <- pipelines for data extraction, preparation, model training, evaluation and registration 
    ├── .pipeline/Prod	    <- pipelines for Deploying the model to Production environment (AKS)
    ├── .pipeline/QA	    <- pipelines for Deploying the model to QA environment 
         ├── templates      <- templates for QA pipelines
    ├── .pipeline/variables <- Contains Project Config Variables  
├── Build_model	            <- Docker file to Build DigitRE Api Docker Image 
├── helm-prod-aks           <- Helm charts to deploy the API Image on Azure Kubernetes Service(AKS).
├── ml_service              <- The top-level folder for all Azure Machine Learning resources.
│   ├── pipelines           <- Python script that builds Azure Machine Learning pipelines.
│   ├── util                <- Python script for various utility operations specific to Azure Machine Learning.
├── scripts	            <- Python script that cancel pipeline delete ACI.
├── README.md               <- The top-level README for developers using this project.  
```

### Pipelines

#### Dev

* `.pipelines/Dev/Build_and_Deploy.yml` : Build the model and push it to Azure container registry(ACR) and then deploy it to ACI
* `.pipelines/Dev/delete-dev.yml` : pipeline triggered when .pipelines/Dev/Build_and_Deploy.yml started and delete the ACI-DEV after 24 hours

#### QA

* `.pipelines/QA/Deploy-to-QA.yml` : deploys the trained model to Azure Container Instance
* `.pipelines/QA/Manual-qa-aci.yml` : Deploys a specific version of a model to Azure Container Instance

#### PROD

* `.pipelines/Prod/prod-deploy-to-aks.yml` : deploys the trained model to Azure Kubernetes Services

### ML Services

* `ml_service/pipelines/` : builds and publishes an ML training pipeline. It uses Python on ML Compute.
* `ml_service/util` : contains common utility functions used to build and publish an ML training pipeline.

### Environment Definitions

* `ml_service/util/conda_dependencies.yml` : Conda environment definition for the environment used for both training and scoring .

### Extraction, Preparing, Training , Evaluation , Registering
* `.pipelines/mlops/Extract-Prepare.yml`
  * Extract Tremplin Data
  * Prepares Data
* `.pipelines/mlops/Train-Evaluate-Register.yml` :
  * training step of an ML training pipeline.
  * evaluating step which cancels the pipeline in case of non-improvement.
  * registers a new trained model

## Changing Config

for all the config parameters we created a file placed in `.pipelines/variables/vars.yml` Containing : 
### Directory Paths

| Parameter                                      | Description                                | value                                   |
| ---------------------------------------------- | ------------------------------------------ | ----------------------------------------|
| `SOURCES_DIR_TRAIN`                            | ML repo name                               | `Digitre-estimation-engine`             |
| `EXTRACT_SCRIPT_PATH`                          | the path of extraction script              | `src/extract/extract_tremplin.py`       |
| `PREPARE_SCRIPT_PATH`                          | the path of preparation script             | `src/preparation/preparation_runner.py` |
| `TRAIN_SCRIPT_PATH`                            | the path of Training script                | `src/trainer/training_runner.py`        |
| `EVALUATE_SCRIPT_PATH`                         | the path of evaluation script              | `src/validation/evaluation_runner.py`   |
| `NOTIFICATION_SCRIPT_PATH`                     | the path of metric notification script     | `ml_service/scripts/pass_model.py`      |

### Notification Variables  

| Parameter                                      | Description                                | value                                   | 
| ---------------------------------------------- | ------------------------------------------ | ----------------------------------------|
| `PASSING_POINT`                                | validation model percentage                | `50`                                    |
| `DESTINATION_EMAIL`                            | Email to recieve model metrics notifcation | `mlops@digitregroup.com`                |
| `Deletion_Notification_email`                  | Email to recieve aci deletion notifcation  | `mlops@digitregroup.com`                |

### Azure ML Variables

| Parameter                                      | Description                                | value                                   | 
| ---------------------------------------------- | ------------------------------------------ | ----------------------------------------|
| `EXPERIMENT_NAME`                              | Azure ML Training experiment name          | `training`                              |
| `PREPARE_EXPERIMENT_NAME`                      | Azure ML Preparation experiment name       | `prepare`                               |
| `DATASTORE_NAME`                               | Azure ML DataStore  name                   | `drimki_data`                           |
| `DATASET_VERSION`                              | Azure ML DataSet Version                   | `latest`                                |
| `TRAINING_PIPELINE_NAME`                       | Azure ML training pipeline name            | `engine-Training-Pipeline`              |
| `PREPARATION_PIPELINE_NAME`                    | Azure ML Preparation pipeline name         | `engine-Preparation-Pipeline`           |

### AML Compute Cluster Configs

| Parameter                                      | Description                                | value                                                 | 
| ---------------------------------------------- | ------------------------------------------ | ------------------------------------------------------|
| `AML_ENV_NAME`                                 | Environment name                           | `azure_ml_train_environment`                          |
| `AML_ENV_TRAIN_CONDA_DEP_FILE`                 | the name of conda dependencies file        | `conda_dependencies.yml`                              |
| `AML_COMPUTE_CLUSTER_CPU_SKU`                  | the size of the compute cluster            | `Standard_F8s_v2`                                     |
| `AML_COMPUTE_CLUSTER_NAME`                     | the name of the compute cluster            | `training-computes`                                   |
| `AML_CLUSTER_MIN_NODES`                        | the minimum nodes number                   | `0` : because when it's 0 the cluster can scale down  |
| `AML_CLUSTER_MAX_NODES`                        | the maximum nodes number                   | `2`                                                   |
| `AML_REBUILD_ENVIRONMENT`                      | when `true` the environment will rebuild when `false` azure ml will not re-build the environment   | `2`                                                   |

### scoring image (API image) Configs

| Parameter                                      | Description                                 | value                                                 | 
| ---------------------------------------------- | ------------------------------------------  | ------------------------------------------------------|
| `IMAGE_NAME`                                   |  Docker image Name                          | `engine`                                              |
| `MODEL_NAME`                                   |  the name of the pkl model                  | `engine_model.pkl`                                    |

### Dns Congis

| Parameter                                      | Description                                 | value                                                 | 
| ---------------------------------------------- | ------------------------------------------  | ------------------------------------------------------|
| `dns_zone`                                     |  the name of the private dns zone           | `drimki-engine.com`                                   |
| `record_dev`                                   |  the dev env dns record                     | `dev`                                                 |
| `record_qa`                                    |  the qa env dns record                      | `qa`                                                  |
| `record_costum_qa`                             |  the custom qa env dns record               | `costum-qa`                                           |
| `record_prod`                                  |  the production env dns record              | `prod`                                                |

### Virtual Network Congis

| Parameter                                      | Description                                 | value                                                 | 
| ---------------------------------------------- | ------------------------------------------  | ------------------------------------------------------|
| `vnet_name`                                    |  the name of the virtual network            | `VNetDigi`                                            |
| `subnet_aci_name`                              |  ACI subnet name                            | `Subnet-aci`                                          |
| `subnet_aks_name`                              |  AKS Subnet name                            | `Subnet-Aks`                                          |



### Azure Pipelines

This Architecture shows How Azure Pipelines are Working Together
includes :

- Workflow
- Functionality
- Triggers
- Approvals

![full pipeline roadmap](https://user-images.githubusercontent.com/59144753/195822485-9f2d968c-662a-4f4e-9f3f-a4d1ddc21136.png)

#### **[ML]-[Extract-Prepare]:**

##### **Functionality**

    [ML]-[Extract-Prepare] :
    - Check if AzureML Compute are created if not creates new
    - publish Azure ML Pipeline
    - once the pipeline is Published it Runs it remotely
    
[More About AML Pipeline]()


![image](https://user-images.githubusercontent.com/59144753/195831013-3c4c10de-4f7b-47af-b1b3-dfdf5f397f4f.png)
![image](https://user-images.githubusercontent.com/59144753/195831075-86a8e9d3-05f4-4916-991d-56e60ba0cd9d.png)

##### **Triggers**

    [ML]-[Extract-Prepare] Pipeline Can be triggered :
     - Manually From Azure Devops
     - Automatically By a commit to the branch develop in Digitre-estimation-engine Repo

##### **Approvals**

    [ML]-[Extract-Prepare] Has no Approvals

#### **[ML]-Train-Evaluate-Register :**

##### **Functionality**

[ML]-Train-Evaluate-Register :

    [ML]-Train-Evaluate-Register :
    - Creates and Publish Azure ML Pipeline
    - Triggers the Pipeline and waits for it to finish
    - Generates Artifacts if new model was registered
    - Ask for approval
    - Delete AML compute

![image](https://user-images.githubusercontent.com/59144753/196893429-e63adb49-6fb4-4244-9bda-3200bccb1396.png)
![image](https://user-images.githubusercontent.com/59144753/196893156-ef8d2e75-ddab-4ffb-9a66-93547ce336fb.png)

##### **Triggers**

[ML]-Train-Evaluate-Register Pipeline Can be triggered :

- Manually
- Automatically after [ML]-[Extract-Prepare] completion

---

**Approvals**

    once the model is registered an approval is asked to delete the ML resources and pass to the next pipeline

#### **[DEV]-Build_and_Deploy:**

##### **Functionality**

[DEV]-Build_and_Deploy :

this pipeline :

- Downloads the PKL model
- Build the Engine api Docker image
- pushes the image to ACR (Azure Container Registry)
- check if a dev aci is already deployed
- if aci exist the pipeline deletes it and re-deploy it with the new model version
- if aci does not exist the pipeline creates a new aci with the new model version

**Triggers**

   [DEV]-Build_and_Deploy  Pipeline Can be triggered

- Manually
- Automatically after [ML]-Train-Evaluate-Register completion

##### **Approvals**

    [DEV]-Build_and_Deploy Has no Approvals

#### **[Dev]-Delete-After-24Hours:**

##### **Functionality**

 [Dev]-Delete-After-24Hours :

* send notification for dev aci deletion - sendgrid
* Waits for  24 Hours
* Delete Dev ACI

![image](https://user-images.githubusercontent.com/59144753/196892356-4e285294-7d51-4e61-aa62-c4fe89c6da23.png)

##### **Triggers**

    [Dev]-Delete-After-24Hours: Pipeline Can be triggered :
    - Manually
    - Automatically after [DEV]-Build_and_Deploy completion

##### **Approvals**

    [Dev]-Delete-After-24Hours Has no Approvals

#### **[QA]-Deploy:**

##### **Functionality**

 [QA]-Deploy :

* Check If Build Is a QA aci is already  Deployed
* Delete Existing And Re-Deploy  if the Aci already exist
* Deploy new QA Aci if it does not exist
  ![image](https://user-images.githubusercontent.com/59144753/196892569-eeb20b85-279d-467b-bdac-771714238d5c.png)

##### **Triggers**

    [QA]-Deploy Pipeline Can be triggered :
    - Manually
    - Automatically after [DEV]-Build_and_Deploy completion

##### **Approvals**

    [QA]-Deploy Has no Approvals

#### **[Manual]-[Custom-QA]-Deploy:**

##### **Functionality**

  [Manual]-[Custom-QA]-Deploy :

* Check If Build Is a QA Custom aci is already  Deployed
* Delete Existing And Re-Deploy  if the Aci already exist
* Deploy new QA Custom Aci if it does not exist

![image](https://user-images.githubusercontent.com/59144753/196892684-c8ac4784-2d18-45d8-bb2d-0e034cba300d.png)

##### **Triggers**

    [Manual]-[Custom-QA]-Deploy Pipeline Can be triggered :
     - Manually

##### **Approvals**

    [Manual]-[Custom-QA]-Deploy Has no Approvals

#### **[Manual]-[Prod]-deployment:**

##### **Functionality**

 [Manual]-[Prod]-deployment :

- this pipeline uses Helm Chart to Deploy the New Version of Api image

[More About Production Helm Chart deployment](here)

![image](https://user-images.githubusercontent.com/59144753/196892955-7f7c09a1-2749-487a-8388-54b1e4911a1c.png)

##### **Triggers**

    [Manual]-[Prod]-deployment Pipeline Can be triggered :

    - Manually

##### **Approvals**

    [Manual]-[Prod]-deployment Has no Approvals

### Azure Dashboard
Azure Devops Dashboard is a customizable interactive dashboard that provides real-time information.
To have a better visibility on the project, we added a custom Azure Devops Dashboard. containing the Builds history of all the pipelines


DigitRE Custom Azure Devops Dashboard:

![image](https://user-images.githubusercontent.com/59144753/196965095-b64aac9f-18fe-430d-8d1f-be95e7626cfe.png)

## Azure Machine Learning Pipelines
Azure ML pipeline is an independently executable workflow of a complete machine learning task

### Preparation Pipeline

The Preparation pipeline consist of 2 steps
  - 1st step
    - Extract Tremplin data and store it in Azure blob (Datastore)
  - 2nd step
    - Prepares data and generates datasets

![image](https://user-images.githubusercontent.com/59144753/196974393-1f92ff33-adf7-45ad-a228-0f52b3704810.png)


### Training Pipeline

The Training Pipeline consist of 3 steps 
  - 1st step  
    - Train Model
    - produce pkl model and send it in a pipeline data to the next step
  - 2nd step
    - Consume PKL model from first step
    - evaluate model 
    - send evaluation json file to next step    
  - 3rd step 
      - Consume PKL model from 1st step and evaluation json from 2nd step a
      - Send Metrics Notification
      - determin if model is valid or not 
        - if model is valid : register model
        - if model is not valid : discard


![image](https://user-images.githubusercontent.com/59144753/196972959-8cf75e53-866b-4aa6-931e-1a1a523c9baf.png)
