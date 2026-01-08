*** Settings ***
Documentation    Data-driven tests for Basic Auth using Selenium and CDP.
Resource    ../../resources/common.resource

Library    SeleniumLibrary
Library    ../../resources/libraries/AuthLib.py
Library    DataDriver    file=../../resources/testdata/BasicAuthData.csv    dialect=excel


Test Tags    web    BasicAuth
Test Setup    Test Setup Web
Test Teardown    Test Teardown Web
Test Template     Verify Basic Auth Logic

*** Variables ***
${URL}            https://the-internet.herokuapp.com/basic_auth
# Dummy defaults for IDE (DataDriver will overwrite them at runtime)
${username}    dummy
${password}    dummy
${is_ok}       False

*** Test Cases ***
Login test ${case}
    ${username}    ${password}    ${is_ok}

*** Keywords ***
Verify Basic Auth Logic
    [Arguments]    ${username}    ${password}    ${is_ok}

    # Python Lib
    Register Basic Auth    ${username}    ${password}

    Go To    ${URL}

    IF    '${is_ok}' == 'True'
        Page Should Contain    Congratulations
    ELSE
        Page Should Not Contain  Congratulations
    END