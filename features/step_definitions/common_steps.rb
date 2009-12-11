Before do
  announce "tearing down users prior to run"
  User.all.each{ |user| user.destroy }
  (1..2).each do |i|
    user = User.new.from_json(  
        File.open("config/user#{i}_fixture.json","r") {|f| f.readlines.to_s} )
    user.save
  end
end

Given /^I am on (.*)$/ do |url|
  visit url
end

When /^I click (.*)$/ do |link|
  click_link link
end

Then /^it should load (.*)$/ do |path|  
  current_url.should == path
end

Then /^it should flash (.*)$/ do |message|
  response_body.should contain(/#{message}/m)
end

Then /^I should see (.*)$/ do |arg1|
  response_body.should contain(/#{arg1}/)
end

Then /^I should not see (.*)$/ do |arg1|
  response_body.should_not contain(/#{arg1}/)
end

After do
  #User.all.each{ |user| user.destroy }
end
