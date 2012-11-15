# -*- encoding : utf-8 -*-
# 
# Copyright (c) 2012, Evgeniy Khatko
# All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
# 
#   * Redistributions of source code must retain the above copyright notice,
#     this list of conditions and the following disclaimer.
#   * Redistributions in binary form must reproduce the above copyright notice,
#     this list of conditions and the following disclaimer in the documentation
#     and/or other materials provided with the distribution.
#   * Neither the name of the <ORGANIZATION> nor the names of its contributors
#     may be used to endorse or promote products derived from this software
#     without specific prior written permission.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#
# cd $AT_NOME/project && git pull && project=${project} execution=${execution} steps=${steps} bundle exec rspec -e #{test} -r ./lib/CustomTarantulaFormatter.rb -f CustomTarantulaFormatter
#  
$project_root=File.expand_path(File.dirname(__FILE__)+'/..')
require "rspec/core/formatters/documentation_formatter"
require 'TarantulaUpdater'
require "#{$project_root}/config/conf.rb"
#require ENV["GEM_HOME"]+'/gems/rspec-core-2.7.1/lib/rspec/core/formatters/html_formatter.rb'

class CustomTarantulaFormatter < RSpec::Core::Formatters::DocumentationFormatter

  attr_reader :total
	@@tarantula_updater = TarantulaUpdater.new(TARANTULA_CONF)
  def initialize(output)
    super(output)      
    @total = 0
  end

  def example_passed(example)
    super(example)
    @total += 1
		process_example(example, "PASSED")
  end

  def example_pending(example)
    super(example)
    @total += 1
		process_example(example, "NOT_IMPLEMENTED")
  end

  def example_failed(example)
    super(example)
    @total += 1
		process_example(example, "FAILED")
  end
  def dump_summary(duration, example_count, failure_count, pending_count)
		super(duration,example_count,failure_count,pending_count)
  end

	private
	def process_example(example, type)
		case type
			when 'PASSED'
				result = type
				message = example.description
			when 'FAILED'
				result = type
				message = "#{File.basename(example.location)}: #{example.execution_result[:exception].inspect}"
			when 'NOT_IMPLEMENTED'
				result = type
				message = example.metadata[:execution_result][:pending_message]
			end
		begin
		example.metadata[:steps].each{|step|
			@@tarantula_updater.update_step(ENV['project'],ENV['execution'],example_group.description,step.to_i,result,message,example.metadata[:execution_result][:run_time].ceil)
		}
		rescue Exception => e
			raise "Make sure you've set steps array for \"example #{example.description}\" in #{File.basename(example.location)}. Original error: #{e.message}"
		end
	end
end

