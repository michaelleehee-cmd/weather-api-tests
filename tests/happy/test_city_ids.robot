*** Settings ***
Resource    ../../resources/variables.robot
Resource    ../../resources/keywords_weather.robot
Test Template    Scenario: City Weather Should Match Expected ID
Suite Setup    Set Log Level    INFO

*** Test Cases ***
Amsterdam Weather    Amsterdam    2759794
Rotterdam Weather    Rotterdam    2747891
Den Haag Weather     Den Haag     2747373
Groningen Weather    Groningen    2755249

*** Keywords ***
Scenario: City Weather Should Match Expected ID
    [Arguments]    ${city}    ${expected_id}
    Given Weather API Is Available
    When I Request Weather For City With API Key    ${city}    ${API_KEY_1}
    Then The Response Should Be 200 OK
    And I Log The Response Json
    And The Response Time Should Be Below 0.5 Seconds
    And The Response Should Contain City Id    ${expected_id}

