*** Settings ***
Resource    ../common.resource
Resource    pages/AddRemovePage.resource
Resource    pages/CheckboxesPage.resource
Resource    pages/BasicAuthPage.resource

# App.resource is an extra layer for "flows" used by tests. Tests call keywords from this file to stay short
# and readable. This file should NOT contain locators. It only combines steps.
# The deeper layer with locators and simple page actions is here: resources/web/pages/*.resource
# This design will be useful when the project grows and moving around the website becomes more complex.

*** Keywords ***
User opens Add Remove Elements page
    Add Remove Page Open

User opens Checkboxes page
    Checkboxes Page Open

User opens Basic Auth page with credentials
    [Arguments]    ${username}    ${password}
    Basic Auth Page Open With Credentials    ${username}    ${password}

User adds N elements
    [Arguments]    ${n}
    Add Remove Page Add Elements    ${n}

User removes first element
    Add Remove Page Delete First Element

User removes all elements
    Add Remove Page Delete All Elements

Delete buttons count should be
    [Arguments]    ${expected}
    Add Remove Page Delete Buttons Count Should Eventually Be    ${expected}

Checkbox state should be
    [Arguments]    ${index}    ${expected_checked}
    Checkboxes Page Checkbox By Index Should Eventually Be    ${index}    ${expected_checked}
