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
