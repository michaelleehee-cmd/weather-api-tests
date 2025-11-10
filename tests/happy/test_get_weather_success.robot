*** Settings ***
Resource    ../../resources/variables.robot
Resource    ../../resources/keywords_weather.robot
Suite Setup    Set Log Level    INFO

*** Test Cases ***
Scenario: Get Weather For Utrecht Should Return Correct City Name
    Given Weather API Is Available
    When I Request Weather For City With API Key    Utrecht    ${API_KEY_1}
    And I Log The Response Status
    And I Log The Response Json
    Then The Response Should Be 200 OK
    And The Response Time Should Be Below 0.5 Seconds
    And The Response Should Contain Exact City Name    Provincie Utrecht