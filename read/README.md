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

* Publish_AML_Pipeline
  * Adding Repo
  * Publish Training Pipeline
* Trigger_AML_Pipeline
  * Get Pipeline ID for execution
  * Trigger ML Training Pipeline
  * Publish artifact if new model was registered
* Delete AML Compute
  * Delete Compute

    ![1666002984923](image/README/1666002984923.png)

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

* Build and push Model to ACR
  * Download Pipeline Artifacts
  * Parse Json for Model Name and Version
  * Install AML CLI
  * Download model
  * Build and Push model
  * Deploy to Dev ACI
    * Check If ACI Exist
    * Cancel pipeline delete
    * Delete + Re-Deploy **OR** Deploy The New Dev-ACI

      ![1666003045253](image/README/1666003045253.png)

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

* Send deletion notification and Delete ACI After 24 hours
  * send notification for dev aci deletion - sendgrid
  * Waiting 24 Hours
  * Delete ACI

    ![1666003093162](image/README/1666003093162.png)

##### **Triggers**

    [Dev]-Delete-After-24Hours: Pipeline Can be triggered :
    - Manually 
    - Automatically after [DEV]-Build_and_Deploy completion

##### **Approvals**

    [Dev]-Delete-After-24Hours Has no Approvals

#### **[QA]-Deploy:**

##### **Functionality**

 [QA]-Deploy :

* Check If Build Is Already Deployed
* Delete Existing And Re-Deploy  ***OR*  **Deploy to QA

##### **Triggers**

    [QA]-Deploy Pipeline Can be triggered :
    - Manually 
    - Automatically after [DEV]-Build_and_Deploy completion

##### **Approvals**

    [QA]-Deploy Has no Approvals

#### **[Manual]-[Custom-QA]-Deploy:**

##### **Functionality**

  [Manual]-[Custom-QA]-Deploy :

* Check If Build Is Already Deployed
* Delete QA-ACI + Deploy New Version *OR* Deploy QA-ACI

  ![1666003179281](image/README/1666003179281.png)

##### **Triggers**

    [Manual]-[Custom-QA]-Deploy Pipeline Can be triggered :
     - Manually

##### **Approvals**

    [Manual]-[Custom-QA]-Deploy Has no Approvals

#### **[Manual]-[Prod]-deployment:**

##### **Functionality**

 [Manual]-[Prod]-deployment :

* Deploy Engine Helm application
* Create if Deployment not exist
* Update if Deployment already exist

  ![1666003221662](image/README/1666003221662.png)

##### **Triggers**

    [Manual]-[Prod]-deployment Pipeline Can be triggered :

    - Manually 

##### **Approvals**

    [Manual]-[Prod]-deployment Has no Approvals

### Azure Dashboard

### **Repo Details**

You can find the details of the code and scripts in the repository [here ](code_description.md)
