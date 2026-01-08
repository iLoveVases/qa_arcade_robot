*** Settings ***
Documentation   Data-driven tests for Checkboxes page
Resource    ../../resources/common.resource
Resource    ../../resources/web/App.resource

Test Setup    Test Setup Web
Test Teardown    Test Teardown Web
Test Template    Set checkbox and verify
Test Tags    web    checkboxes
# Data-driven checkbox tests using a Test Template.
# Each test row: checkbox index (0/1), expected state (TRUE/FALSE) and mode.
# Modes:
# - direct_set: force the state using Select/Unselect Checkbox
# - toggle: click only if current state differs from the expected one

*** Test Cases ***
cb1 set true direct_set
    0    ${TRUE}     direct_set
cb1 set false direct_set
    0    ${FALSE}    direct_set
cb2 set true direct_set
    1    ${TRUE}     direct_set
cb2 set false direct_set
    1    ${FALSE}    direct_set
cb1 set true toggle
    0    ${TRUE}     toggle
cb1 set false toggle
    0    ${FALSE}    toggle
cb2 set true toggle
    1    ${TRUE}     toggle
cb2 set false toggle
    1    ${FALSE}    toggle

*** Keywords ***
Set checkbox and verify
    [Arguments]    ${index}    ${target_checked}    ${mode}
    Given User opens Checkboxes page
    When Checkboxes Page Set Checkbox By Index    ${index}    ${target_checked}    ${mode}
    Then Checkbox state should be    ${index}    ${target_checked}
    And Checkboxes Page URL Should Be Correct
