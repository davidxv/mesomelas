Given /^I have an existing search (.*)$/ do |name|
  Given "I am on /"
  When "I log in as test user1"
  And "I create a new project My First Project"
  When "I click My First Project"
  And "I create a new search #{name}"
end

When /^I create a new search (.*)$/ do |search|
  @search = search
  fill_in "query", :with => search
  click_button "Create Search"
end

Then /^there should be a list of links$/ do
  response_body.should have_selector("li.link")
end

Then /^there should be a summary$/ do
  response_body.should have_selector("div.summary")
end
