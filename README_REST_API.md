# Tarantula API

The REST API is used in the sense of doing POST HTTP requests with XML-ed params inside

#### Authentication

[Basic http authentication](http://en.wikipedia.org/wiki/Basic_access_authentication) is used. Just provide a username and a password of existing tarantula user, who has **enough privileges** (admin user is recommended) to perform actions below. Also make sure that specified user is assigned to the project, you're going to update testcases from.
The credentials are transmitted without encription. If you need more safety please request for SSL support  


#### Create testcase
*Preconditions*  
- There is project "My project" in the system  
  
Following call will create new test case with specified parameters  

		curl -v -X POST -H 'Content-type: text/xml' -u user:password -d @create_testcase.xml http://tarantula_url/api/update_testcase_execution.xml  
   
where body is  

		<request>
			<testcase project="My project" title="testcase title" priority="high" tags="functional" objective="testcase objective" data="testcase data" preconditions="testcase preconditions">
				<step action="Step 1" result="Result 1"></step>
				<step action="Step 2" result="Result 2"></step>
			</testcase>
		</request>

This method can be invoked e.g. for inmorting testcases from a third party tool like testlink

#### Update testcase execution
*Preconditions*  
- There is project "My project" in the system  
- There is execution "My execution" in the system  
- There is testcase "My testcase" in the system inside "My execution"  
- Test step has at least 2 steps
  
Following call will update testcase execution setting run time to "1", step1 result to "Passed", step2 result to "Not implemented"

		curl -v -X POST -H 'Content-type: text/xml' -u user:password -d @update_testcase_execution.xml http://tarantula_url/api/update_testcase_execution.xml  
   
where body is  

		<request>
			<project>My project</project>
			<execution>My execution</execution>
			<testcase>My testcase</testcase>
			<duration>1</duration>
			<step position="1" result="PASSED" comment="some text"></step>
			<step position="2" result="NOT_IMPLEMENTED"></step>
		</request>
  
The other possible options for result are: "FAILED", "SKIPPED", "NOT\_RUN", 
  
This method can be invoked e.g. for integrating with a test automation tool

#### Block testcase execution
*Preconditions*  
- There is project "My project" in the system  
- There is execution "My execution" in the system  
- There is testcase "My testcase" in the system inside "My execution"  
- "My testcase" is being blocked by automation tool
  
Following call will ublock testcase execution

    curl -v -X POST -H 'Content-type: text/xml' -u user:password -d @block_testcase_execution.xml http://tarantula_url/api/block_testcase_execution.xml
   
where body is  

		<request>
			<project>My project</project>
			<execution>My execution</execution>
			<testcase>My testcase</testcase>
		</request>
  
This method can be invoked e.g. for integrating with a test automation tool


#### Unblock testcase execution
*Preconditions*  
- There is project "My project" in the system  
- There is execution "My execution" in the system  
- There is testcase "My testcase" in the system inside "My execution"  
- "My testcase" is being blocked by automation tool
  
Following call will ublock testcase execution

    curl -v -X POST -H 'Content-type: text/xml' -u user:password -d @update_testcase_execution.xml http://tarantula_url/api/unblock_testcase_execution.xml
   
where body is  

		<request>
			<project>My project</project>
			<execution>My execution</execution>
			<testcase>My testcase</testcase>
		</request>
  
This method can be invoked e.g. for integrating with a test automation tool

Working example can be found here: http://qamind.ru/?page_id=130&lang=en
