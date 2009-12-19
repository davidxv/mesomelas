Feature: Searches
	In order browse around searches
	
  Scenario: Create a search
    Given I have an existing project My First Project
    When I click My First Project
    And I create a new search My First Search
    Then I should see My First Project searches
    And I should see My First Search
    
  Scenario: Click on a search
    Given I have an existing search My First Search
    When I click My First Search
    Then it should load /projects/My+First+Project/searches/My+First+Search

  Scenario: Delete a search
    Given I have an existing search My First Search
    When I click My First Search
    And I click (delete)
    Then I should see My First Project searches:
    And I should not see My First Search
  
  @wip
  Scenario: Check you can't add a duplicate search
  
  Scenario: View links on a search page
    Given I have an existing search golf
    When I click golf
    Then it should load /projects/My+First+Project/searches/golf
    And there should be a list of links
    And there should be a summary