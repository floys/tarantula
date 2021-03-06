  class JiraIssue < ActiveRecord::Base
  UDMargin = 5.minutes # update margin
  if ImportSource.find_by_name("Jira connection").adapter=~/oracle/
    UPPER = false
  else
    UPPER = true
  end
  UPDATED =(UPPER)? 'UPDATED' : 'updated'
  ID = (UPPER)? 'ID' : 'id'
  SUMMARY = (UPPER)? 'SUMMARY' : 'summary'
  DESC = (UPPER)? 'DESCRIPTION' : 'description'
  PROJECT = (UPPER)? 'PROJECT' : 'project'
  PRIORITY = (UPPER)? 'PRIORITY' : 'priority'

  self.table_name = 'jiraissue'
  self.primary_key = ID

  belongs_to :project, :class_name => 'JiraProject', :foreign_key => PROJECT
  belongs_to :priority, :class_name => 'JiraPriority', :foreign_key => PRIORITY
  belongs_to :status, :class_name => 'JiraStatus', :foreign_key => 'issuestatus'

  scope :recent_from_projects, lambda {|prids, last_fetched, force_update|
    conds = "PROJECT IN (#{prids.join(',')})"
    c = CustomerConfig.jira_defect_types
    if c
      types = c
    else
      types = BT_CONFIG[:jira][:defect_types]
    end
    conds += " AND (select pname from issuetype where #{ID} = jiraissue.issuetype) " +
        "IN (#{types.map{|t|"'%s'"%t}.join(',')})"
    unless force_update
      conds += " AND ((UPDATED IS null) OR "+
        "(UPDATED >= '#{(last_fetched-UDMargin).to_s(:db)}'))"
    end
    where(conds)
  }

  scope :from_projects, lambda {|prids|
    where(PROJECT => prids)
  }

  def self.db_type=val
    @@db_type = val
  end

  def to_data
    {
      :lastdiffed => self[UPDATED],
      :external_id => self[ID],
      :name => self[SUMMARY],
      :status => self.status.value,
      :desc => self[DESC]
    }
  end

  def updated
    self[UPDATED]
  end

  def summary
    self[SUMMARY]
  end

  def desc
    self[DESC]
  end

  def url_part
    self['pkey']
  end

end
