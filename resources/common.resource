*** Settings ***
Library    SeleniumLibrary
Library    Collections
Library    RequestsLibrary

*** Variables ***
${BROWSER}                 chrome
${SELENIUM_TIMEOUT}        14s

${WEB_BASE_URL}            https://the-internet.herokuapp.com

*** Keywords ***
# Browser lifecycle helpers.
# For this project a fresh browser per test is set (Test Setup Web + Test Teardown Web).
# Suite Setup/Teardown are kept as an alternative for bigger suites in future.

Suite Setup Web
    Set Selenium Timeout    ${SELENIUM_TIMEOUT}
    Open Browser    ${WEB_BASE_URL}    ${BROWSER}
    Maximize Browser Window

Suite Teardown Web
    Close Browser

Test Setup Web
    Set Selenium Timeout    ${SELENIUM_TIMEOUT}
    Open Browser    ${WEB_BASE_URL}    ${BROWSER}
    Maximize Browser Window

Test Teardown Web
    Run Keyword If Test Failed    Capture Page Screenshot
    Close Browser
