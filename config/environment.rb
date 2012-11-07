# Load the rails application
require File.expand_path('../application', __FILE__)
ActionController::Base.default_charset=("UTF-8")
# Initialize the rails application
Tarantula::Application.initialize!
