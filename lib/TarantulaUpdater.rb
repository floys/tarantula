# -*- encoding : utf-8 -*-
require 'net/http'
require 'builder'
require 'uri'
require 'logger'

class TarantulaUpdater

	def initialize(connection)
		@connection = connection
		@logger = Logger.new($project_root+'/'+@connection['log'])
		@logger.info "================Started new session=============="
	end

	def update_step(project, execution, testcase, step_position, result, comments, duration)
		body = form_step_result(project, execution, testcase, step_position, result, comments, duration)
		@logger.info body
		@logger.info send_request(TARANTULA_CONF['update_testcase_execution'], body)
	end

	def block_testcase_execution(project, execution, testcase)
		body = form_block_or_unblock_test(project, execution, testcase)
		@logger.info body
		@logger.info send_request(TARANTULA_CONF['block_testcase_execution'], body)
	end

	def unblock_testcase_execution(project, execution, testcase)
		body = form_block_or_unblock_test(project, execution, testcase)
		@logger.info body
		@logger.info send_request(TARANTULA_CONF['unblock_testcase_execution'], body)
	end

	private

	def send_request(path, data)
		Net::HTTP.start(@connection['host'],
										@connection['port'].to_i,
										@connection['proxy_host'],
										@connection['proxy_port'].to_i,
									 ) {|http|
      req = Net::HTTP::Post.new(path, initheader = {'Content-Type' =>'application/xml'})
      req.basic_auth @connection['user'], @connection['password']
			req.body = data
      http.request(req).body
	 }
	end
private
	def form_step_result(project, execution, testcase, step_position, result, comments, duration)
		# <request>
    #     <project>My project</project>
    #     <execution>My execution</execution>
    #     <testcase>My testcase</testcase>
    #     <duration>1</duration>
    #     <step position="2" result="NOT_IMPLEMENTED"></step>
    # </request>
		builder = Builder::XmlMarkup.new
		xml = builder.request { |r| 
			r.project(project)
			r.execution(execution)
			r.testcase(testcase)
			r.duration(duration)
			2.times do # this is a hack - update the same step twice to get correct XML structure
				r.step({:position => step_position, :result => result, :comment => comments})
			end
	 }
	end

	def form_block_or_unblock_test(project, execution, testcase)
		# <request>
    #     <project>My project</project>
    #     <execution>My execution</execution>
    #     <testcase>My testcase</testcase>
    # </request>
		builder = Builder::XmlMarkup.new
		xml = builder.request { |r| 
			r.project(project)
			r.execution(execution)
			r.testcase(testcase)
	 }
	end
end
