Feature: Homepage
	In order browse around
	
	Scenario: Check multiple users don't get confused
	  Given I am on /
    When I log in as test user1
    And I create a new project Test User1 First Project
    And I click (logout)
    When I log in as test user2
    Then I should have no projects
    When I create a new project Test User2 First Project
    Then I should see Test User2 First Project
    