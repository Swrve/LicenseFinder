require 'license_finder'
require 'fileutils'
require 'pathname'
require 'bundler'
require 'capybara'
require 'pry'
require 'pry-debugger'

Given /^I have a project that depends on mime\-types$/ do
  @user = ::DSL::User.new
  @user.create_rails_app
  @user.add_gem_dependency('mime-types')
  @user.bundle_app
  @user.execute_command "license_finder"
end

Given /^I manually set the license type to Ruby$/ do
  @output = @user.execute_command "license_finder -l Ruby mime-types"
end

When /^I run license_finder again$/ do
  @output = @user.execute_command "license_finder"
end

Then /^the mime\-types license is set to Ruby$/ do
  all_settings = YAML.load(File.read(@user.dependencies_file_path))
  actual_settings = all_settings.detect { |gem| gem['name'] == 'mime-types' }
  actual_settings['license'].should == "Ruby"
end