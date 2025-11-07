*** Settings ***
Resource    ../../resources/variables.robot
Resource    ../../resources/keywords_weather.robot
Test Template    Validate City Weather

*** Test Cases ***
Amsterdam Weather    Amsterdam    2759794
Rotterdam Weather    Rotterdam    2747891
Den Haag Weather     Den Haag     2747373
Groningen Weather    Groningen    2755249

*** Keywords ***
Validate City Weather
    [Arguments]    ${city}    ${expected_id}
    Create Session To Weather API
    ${response}=    Get Weather For City    ${city}    ${API_KEY_1}
    Response Should Be 200 OK    ${response}
    Log Response Json    ${response}
    Response Should Contain City Id    ${response}    ${expected_id}
