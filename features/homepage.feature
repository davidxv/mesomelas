Feature: Homepage
	In order browse around

	@acceptance
	Scenario: Log in and view my projects
    Given I am on /
    When I log in as test user1
    Then I can see my projects list
    And I can see the twitter trends
    
  @acceptance
  Scenario: Create a new project
    Given I am on /
    When I log in as test user1
    And I create a new project My First (test) Project
    Then I should see My First
    
  @acceptance
  Scenario: Click on a project
    Given I have an existing project My First (test) Project
    When I click My First (test) Project
    Then it should load /projects/My+First+%28test%29+Project
    
  @acceptance
  Scenario: Delete a project
    Given I have an existing project My First (test) Project
    When I click My First (test) Project
    And I click (delete)
    Then I should see Your projects
    And I should not see My First (test) Project
    
  @acceptance 
  Scenario: Check you can't add a duplicate project
    Given I have an existing project My First (test) Project
    When I create a new project My First (test) Project
    Then I should see My First
    And it should flash You already have a project with that name
