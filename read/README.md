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


### Azure Pipelines

This Architecture shows How Azure Pipelines are Working Together
includes :

- Workflow
- Triggers
- Approvals

![full pipeline roadmap](https://user-images.githubusercontent.com/59144753/195822485-9f2d968c-662a-4f4e-9f3f-a4d1ddc21136.png)

#### **[ML]-[Extract-Prepare]:**

##### **Functionality**

    [ML]-[Extract-Prepare] :
    - Check if AzureML Compute are created if not creates new
    - publish Azure ML Pipeline[more about Azure ML Pipeline](https://link.com)
    - once the pipeline is Published it Runs it remotely

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
    - Creates and Publish Azure ML Pipeline [More About AML Pipeline]()
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

![image](https://user-images.githubusercontent.com/59144753/196892122-11785bea-387a-4a0f-a79e-0d71d95568b4.png)
---

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

