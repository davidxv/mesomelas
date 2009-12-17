Feature: Searches
	In order browse around searches
	
  Scenario: Create a search
    Given I have an existing project My First Project
    When I click My First Project
    And I create a new search My First Search
    Then I should see My First Project searches
    And I should see My First Search
    
  @wip
  Scenario: Click on a search
    Given I have an existing search My First Search
    When I click My First Search
    Then it should load /projects/My+First+Project/searches/My+First+Search

  @wip
  Scenario: Delete a search
  
  @wip
  Scenario: Check you can't add a duplicate search