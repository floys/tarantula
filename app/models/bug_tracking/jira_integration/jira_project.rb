class JiraProject < ActiveRecord::Base
  if ImportSource.find_by_name("Jira connection").adapter=~/oracle/
    UPPER = false
  else
    UPPER = true
  end
  ID = (UPPER)? 'ID' : 'id'
  
  self.table_name = 'project'
  self.primary_key = ID

  has_many :issues, :class_name => 'JiraIssue', :foreign_key => 'project'

  def name
    self['pname']
  end

  def external_id
    self[ID]
  end

end
