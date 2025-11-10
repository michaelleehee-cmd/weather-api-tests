*** Settings ***
Resource    ../../resources/keywords_weather.robot
Resource    ../../resources/variables.robot
Suite Setup    Set Log Level    INFO

*** Test Cases ***
Scenario: Get Weather Without API Key Should Return 401
    Given Weather API Is Available
    When I Request Weather For City Without API Key    ${DEFAULT_CITY}
    And I Log The Response Status
    Then The Response Should Be 401 Unauthorized
    And The Response Time Should Be Below 0.5 Seconds

Scenario: Get Weather With Invalid City Should Return 404
    Given Weather API Is Available
    When I Request Weather For City With API Key    qwerty123invalidcity    ${API_KEY_1}
    And I Log The Response Status
    Then The Response Should Be 404 Not Found
    And The Response Time Should Be Below 0.5 Seconds


