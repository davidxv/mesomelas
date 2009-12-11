Given /^I have an existing project (.*)$/ do |name|
  Given "I am on /"
  When "I log in as test user1"
  And "I create a new project #{name}"
end

When /^I create a new project (.*)$/ do |project|
  fill_in "name", :with => project
  click_button "Create Project"
end

Then /^I can see the twitter trends$/ do
  pending
  response_body.should have_selector("ol.tweets")
  response_body.should have_selector('li.tweet', :count => 10)
end

Then /^I can see my projects list$/ do
  response_body.should contain(/Your projects/m)
end

Then /^I should see the lists of that project$/ do
  response_body.should contain(/u1_p1_list1/m)
  response_body.should contain(/u1_p1_list2/m)
end

Then /^I should see the searches of that list$/ do
  response_body.should contain(/u1_p1_l1_search1/m)
  response_body.should contain(/u1_p1_l1_search2/m)
end

Then /^it should load the "([^\"]*)" page$/ do |path|  
  current_url.should == path
end

