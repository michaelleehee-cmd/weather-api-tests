*** Settings ***
Library    RequestsLibrary
Resource   variables.robot

*** Keywords ***

# BDD-style keywords

Given Weather API Is Available
    Create Session To Weather API

When I Request Weather For City With API Key
    [Arguments]    ${city}    ${apikey}
    ${response}=    Get Weather For City    ${city}    ${apikey}
    Set Test Variable    ${response}

When I Request Weather For City Without API Key
    [Arguments]    ${city}
    ${params}=     Create Dictionary    q=${city}
    ${response}=   GET On Session    weather    /    params=${params}    expected_status=any
    Set Test Variable    ${response}

Then The Response Should Be 200 OK
    Response Should Be 200 OK    ${response}

Then The Response Should Be 401 Unauthorized
    Response Should Be 401 Unauthorized    ${response}

Then The Response Should Be 404 Not Found
    Response Should Be 404 Not Found    ${response}

And The Response Time Should Be Below 0.5 Seconds
    Response Time Should Be Below    ${response}    0.5

And The Response Should Contain Exact City Name
    [Arguments]    ${expected}
    Response Should Contain City Name Exactly    ${response}    ${expected}

And The Response Should Contain City Id
    [Arguments]    ${expected_id}
    Response Should Contain City Id    ${response}    ${expected_id}

And I Log The Response Status
    Log Response Status    ${response}

And I Log The Response Json
    Log Response Json    ${response}

#Technical keywords
Response Time Should Be Below
    [Arguments]    ${response}    ${max_time}=0.5
    ${elapsed}=    Set Variable    ${response.elapsed.total_seconds()}
    Log To Console    --- PERFORMANCE ---\nResponse Time: ${elapsed}s\nLimit: ${max_time}s\n----------------------
    Should Be True    ${elapsed} < ${max_time}    Response took too long!

Create Session To Weather API
    Create Session    weather    ${BASE_URL}     verify=False  disable_warnings=True

Get Weather For City
    [Arguments]    ${city}    ${apikey}
    ${params}=     Create Dictionary    q=${city}    appid=${apikey}     units=metric
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
    Log To Console    Temperature: ${temp} °C
    Log To Console    ==========================\n
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

    Log To Console    ==========================

