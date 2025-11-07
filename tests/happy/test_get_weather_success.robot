*** Settings ***
Resource    ../../resources/variables.robot
Resource    ../../resources/keywords_weather.robot

*** Test Cases ***
Get Weather For Utrecht Should Return Correct City Name
    Create Session To Weather API
    ${response}=    Get Weather For City    Utrecht    ${API_KEY_1}
    Log Response Status    ${response}
    Log Response Json    ${response}
    Response Should Be 200 OK    ${response}
    Response Should Contain City Name Exactly    ${response}    Provincie Utrecht
