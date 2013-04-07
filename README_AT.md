# Automation tool integrattion

*Integration features are following*
- define automation tool similar to bug tracker definition
- automation tool will be executed according to your definition CMD string (the easiest way is to install automation tool 'next' to the tarantula installation)
- special symbols ${project}, ${execution}, ${testcase}, ${steps} inside CMD string are used to map tarantula test case execution to automated test. These symbols will be replaced with corresponding values
- automation TAG allows indicating automated tests among others
- each test tagged as automated has a cogwheel ENABLED, which triggers execution of the CMD, specified for this automation tool
- to get result from automation tool back to tarantula, tarantula API should be used (Update testcase execution method)

*Integration workflow is following*
1. Define Automation tool  
2. Tag tests, which are automated with automation tag, defined in step 1  
3. During test execution cogwheel is used to start test in automation mode  
4. After the test has been started in automation mode, Tarantula blocks it's manual execution, until Tarantula API call "Unblock testcase execution" is received  
5. It's expected that Automation tool makes two API calls after corresponding testcase had been executed: "Unblock testcase execution", "Update testcase execution with execution results"  

*Example with Automation tool = ruby RSPEC*

CMD = 'exec_rspec.sh "${project}" "${execution}" "${test}" "${steps}"'
Where exec_spec.sh looks like this:
<pre><code>
  #!/bin/sh -xe
	# changing dir to Automation tool home
	cd $AT_HOME
	# setting up variables
	project="$1" 
	execution="$2" 
	testcase="$3"
	steps="$4" 
	# executing rspec (only $testcase example) with custom formatter
	# custom formatter implements "Update testcase execution" callback to tarantula
  # "|| true" string ensures the execution of the next command in case if rspec fails with uncought exception
  # after test is executed, CustomTarantulaFormatter initiates Tarantula API call "Update testcase execution" with corresponding execution results
	project=$project execution=$execution test=$testcase steps=$steps bundle exec rspec -e "$testcase" -r ./lib/CustomTarantulaFormatter.rb -f CustomTarantulaFormatter || true
	# this command initiates "Unblock testcase execution" Tarantula API call
	bundle exec rake unblock_test["""$project""","""$execution""","""$testcase"""] 
</code></pre>

Working example can be found here: 
