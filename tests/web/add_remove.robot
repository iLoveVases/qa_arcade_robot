*** Settings ***
Documentation    Tests for Add/Remove Elements page
Resource    ../../resources/common.resource
Resource    ../../resources/web/App.resource

Test Setup    Test Setup Web
Test Teardown    Test Teardown Web

*** Test Cases ***
Add remove single element
    [Tags]    web    add_remove
    Given User opens Add Remove Elements page
    Then Delete buttons count should be    0
    When User adds N elements    1
    Then Delete buttons count should be    1
    When User removes first element
    Then Delete buttons count should be    0

URL and header consistency
    [Tags]    web    add_remove
    Given User opens Add Remove Elements page
    Add Remove Page URL Should Be Correct
    Add Remove Page Add Button Should Be Visible
    Then Delete buttons count should be    0
    When User adds N elements    1
    Then Delete buttons count should be    1

Add three remove two
    [Tags]    web    add_remove
    Given User opens Add Remove Elements page
    When User adds N elements    3
    Then Delete buttons count should be    3
    When User removes first element
    Then Delete buttons count should be    2
    When User removes first element
    Then Delete buttons count should be    1

Add many then remove all
    [Tags]    web    add_remove
    Given User opens Add Remove Elements page
    When User adds N elements    50
    Then Delete buttons count should be    50
    When User removes all elements
    Then Delete buttons count should be    0
