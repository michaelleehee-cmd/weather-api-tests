*** Settings ***
Library    RequestsLibrary
Resource   variables.robot

*** Keywords ***
Create Session To Weather API
    Create Session    weather    ${BASE_URL}

Get Weather For City
    [Arguments]    ${city}    ${apikey}
    ${params}=     Create Dictionary    q=${city}    appid=${apikey}
    ${response}=   GET On Session    weather    /    params=${params}    expected_status=any
    RETURN      ${response}

Response Should Be 401 Unauthorized
    [Arguments]    ${response}
    Should Be Equal As Integers    ${response.status_code}    401
    ${json}=    Call Method    ${response}    json
    Should Contain    ${json['message']}    Invalid API key

Response Should Be 200 OK
    [Arguments]    ${response}
    Should Be Equal As Integers    ${response.status_code}    200

Response Should Be 404 Not Found
    [Arguments]    ${response}
    Should Be Equal As Integers    ${response.status_code}    404

Response Should Contain City Name Exactly
    [Arguments]    ${response}    ${expected_name}
    ${json}=    Call Method    ${response}    json
    Should Be Equal    ${json['name']}    ${expected_name}

Response Should Contain City Id
    [Arguments]    ${response}    ${expected_id}
    ${json}=    Call Method    ${response}    json
    Should Be Equal As Integers    ${json['id']}    ${expected_id}

#Logging Keywords
Log Response Json
    [Arguments]    ${response}
    ${json}=    Call Method    ${response}    json

    ${id}=        Set Variable    ${json['id']}
    ${name}=      Set Variable    ${json['name']}
    ${temp}=      Set Variable    ${json['main']['temp']}

    Log To Console    \n=== Weather Info ===
    Log To Console    City: ${name}
    Log To Console    ID: ${id}
    Log To Console    Temperature: ${temp} K
    Log To Console    =====================\n
Log Response Status
    [Arguments]    ${response}
    ${status}=     Set Variable    ${response.status_code}
    Log To Console    \n=== API Response Info ===
    Log To Console    Status Code: ${status}
    Log To Console    URL: ${response.url}

    # Try to parse JSON (works for both success and error responses)
    ${json}=    Call Method    ${response}    json

    # Log error message only if present
    Run Keyword And Ignore Error    Log To Console    Message: ${json['message']}

    Log To Console    ==========================\n



