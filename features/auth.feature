Feature: Authorisation
	In order to signup, login and logout

	@acceptance
	Scenario: Sign up and log in
		Given I am on /
		Then I should go to "/login"
		And I should see a login form
		When I click "here"
		Then I should go to "/signup"
		And I should see a login form
		When I sign up
		Then I should go to "/"
		
	@acceptance
	Scenario: Logout
		Given I am logged in
		When I click "logout"
		Then I should go to "/login"
		