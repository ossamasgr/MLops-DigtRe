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
-
-
#### Devops-MLops
![image](https://user-images.githubusercontent.com/59144753/195838820-a3a8895b-7a53-4c60-ba64-17d0b777571e.png)


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
    - publish Azure ML Pipeline [more about Azure ML Pipeline](https://link.com)
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
    - 
    - 
    - 


  ##### **Triggers**
     
  ##### **Approvals**
         
       [ML]-Train-Evaluate-Register Has no Approvals
 
#### **[DEV]-Build_and_Deploy:**

  ##### **Functionality**
  
    [DEV]-Build_and_Deploy : 



  ##### **Triggers**
     
      [DEV]-Build_and_Deploy  Pipeline Can be triggered : 
     
  ##### **Approvals**
         
        [DEV]-Build_and_Deploy Has no Approvals
     
#### **[Dev]-Delete-After-24Hours:**  

  ##### **Functionality**
  
    [Dev]-Delete-After-24Hours: : 



  ##### **Triggers**
     
     [Dev]-Delete-After-24Hours: Pipeline Can be triggered : 
     
  ##### **Approvals**
         
        [Dev]-Delete-After-24Hours Has no Approvals

#### **[QA]-Deploy:** 
  
  ##### **Functionality**
  
    [QA]-Deploy : 



  ##### **Triggers**
     
     [QA]-Deploy Pipeline Can be triggered : 

  ##### **Approvals**
         
        [QA]-Deploy Has no Approvals
        
#### **[Manual]-[Custom-QA]-Deploy:** 

  ##### **Functionality**
  
    [Manual]-[Custom-QA]-Deploy : 
    


  ##### **Triggers**
     
     [Manual]-[Custom-QA]-Deploy Pipeline Can be triggered : 
     - Manually From Azure Devops
     - Automatically By a commit to the branch develop in Digitre-estimation-engine Repo

  ##### **Approvals**
         
        [Manual]-[Custom-QA]-Deploy Has no Approvals

#### **[Manual]-[Prod]-deployment:** 
     
  ##### **Functionality**
  
    [Manual]-[Prod]-deployment : 

  ##### **Triggers**
     
     [Manual]-[Prod]-deployment Pipeline Can be triggered : 
     
  ##### **Approvals**
         
        [Manual]-[Prod]-deployment Has no Approvals
        
### Azure Dashboard



