#Jira integration

Suppose you have test case execution with following results.  
1. Step1 - PASSED  
2. Step2 - PASSED  
3. Step3 - FAILED  
  
After choosing "Add defect to bug tracker" inside the "Associate defect" dialog tarantula redirects you to appropriate "create new issue" form with following fields filled in:
**title** test case title  
**description**  
Preconditions => test case preconditions  
Step1 action  
Step2 action  
Result  
Expected result  

Working example can be found here: 
