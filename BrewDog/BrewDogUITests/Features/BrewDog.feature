Feature: Testing

Scenario: View beers list
    Given I am on beer list screen
    Then I should see the list of beers


Scenario: View beer details
    Given I am on beer list screen
    When I select a beer
    Then I should see the beer details
    When I tap back
    Then I should see the list of beers


Scenario: Refresh beers list
    Given I am on beer list screen
    When I pull to refresh
    Then I should see the list of beers
