Then /^I should have no projects$/ do
  User.find_by_login("test user2").projects.length.should == 0
end

