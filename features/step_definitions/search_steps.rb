Given /^I have an existing search (.*)$/ do |arg1|
  Given "I am on /"
  When "I log in as test user1"
  And "I create a new project test project"
  And "I click test project"
  When "I create a new search test search"
  And "I click test search"
end

When /^I create a new search (.*)$/ do |search|
  @search = search
  fill_in "query", :with => search
  click_button "Create Search"
end

Then /^I should see that search in the list$/ do
  puts response_body
  pending
end
