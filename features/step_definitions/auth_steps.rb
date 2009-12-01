Before do
  announce "tearing down users prior to run"
  User.all.each{ |user| user.destroy }
end

Given /^I am on (.*)$/ do |url|
  visit url
end

When /^I click "([^\"]*)"$/ do |link|
  click_link link
end

Then /^I should go to "([^\"]*)"$/ do |path|
  current_url.should == path
end

Then /^I should see a login form$/ do
  response_body.should contain(/Login/m)
  response_body.should contain(/Password/m)
end

When /^I sign up$/ do
  fill_in "login", :with => "test user1"
  fill_in "password", :with => "password"
  click_button "Sign Up"
end

When /^I log in$/ do
  fill_in "login", :with => "test user1"
  fill_in "password", :with => "password"
  click_button "Submit"
end

Given /^I am logged in$/ do
  Given "I am on /signup"
  When "I sign up"
  current_url.should == "/"
end
