Feature: Searches
	In order browse around searches
	
  @wip
  Scenario: Create a search
    Given I have an existing project My First (test) Project
    When I click My First (test) Project
    And I create a new search My First (test) Search
    Then I should see that search in the list
    
  @wip
  Scenario: Click on a search
    Given I have an existing search test search
    When I click test search
    Then I should see the "search" page

  @wip
  Scenario: Delete a search
  
  @wip
  Scenario: Check you can't add a duplicate search