Feature: Authorisation
	In order to signup, login and logout

	@acceptance
	Scenario: Sign up and log in
		Given I am on /
		Then it should load /login
		And I should see Login
		And I should see Password
		When I click here
		Then it should load /signup
		And I should see Login
		And I should see Password
		When I sign up
		Then it should load /
		
	@acceptance
	Scenario: Logout
		Given I am on /
    When I log in as test user1
		When I click logout
		Then it should load /login
		