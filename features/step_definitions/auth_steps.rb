When /^I sign up$/ do
  fill_in "login", :with => "test user3"
  fill_in "password", :with => "password"
  click_button "Sign Up"
end

When /^I log in as (.*)$/ do |username|
  fill_in "login", :with => username
  fill_in "password", :with => "password"
  click_button "Log in"
end

Given /^I am logged in$/ do
  Given "I am on /signup"
  When "I sign up"
  current_url.should == "/"
end
