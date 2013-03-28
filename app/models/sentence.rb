class Sentence < ActiveRecord::Base
	attr_accessible :project, :value
 	belongs_to :project
 	validates_presence_of :value
 	validates_uniqueness_of :value, :scope => :project_id
end
