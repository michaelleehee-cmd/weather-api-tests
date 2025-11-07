*** Settings ***
Resource    ../../resources/keywords_weather.robot
Resource    ../../resources/variables.robot

*** Test Cases ***
Get Weather Without APPID Should Return 401 And Error Message
    Create Session To Weather API
    ${params}=     Create Dictionary    q=${DEFAULT_CITY}
    ${response}=   GET On Session    weather    /    params=${params}    expected_status=any
    Log Response Status  ${response}
    Response Should Be 401 Unauthorized    ${response}

Get Weather With Invalid City Should Return 404
    Create Session To Weather API
    ${response}=    Get Weather For City    qwerty123invalidcity    ${API_KEY_1}
    Log Response Status  ${response}
    Response Should Be 404 Not Found    ${response}

Get Weather Without API Key Should Return 401
    Create Session To Weather API
    ${params}=     Create Dictionary    q=${DEFAULT_CITY}
    ${response}=   GET On Session    weather    /    params=${params}    expected_status=any
    Log Response Status    ${response}
    Should Be Equal As Integers    ${response.status_code}    401

