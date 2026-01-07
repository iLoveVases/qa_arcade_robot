*** Settings ***
Resource    ../../common.resource

*** Variables ***
${ADD_REMOVE_PATH}     /add_remove_elements/
${HEADING}             css=h3
${BTN_ADD}             css=button[onclick="addElement()"]
${BTN_DELETE}          css=button.added-manually

*** Keywords ***
Add Remove Page Open
    Go To    ${WEB_BASE_URL}${ADD_REMOVE_PATH}
    Wait Until Element Is Visible    ${HEADING}
    Element Should Contain           ${HEADING}    Add/Remove Elements

Add Remove Page Add Elements
    [Arguments]    ${count}
    FOR    ${i}    IN RANGE    ${count}
        Click Button    ${BTN_ADD}
    END

Add Remove Page Delete First Element
    Click Button    ${BTN_DELETE}

Add Remove Page Delete All Elements
    ${count}=    Get Element Count    ${BTN_DELETE}
    WHILE    ${count} > 0
        Add Remove Page Delete First Element
        ${count}=    Get Element Count    ${BTN_DELETE}
    END

Add Remove Page Delete Buttons Count Should Be
    [Arguments]    ${expected}
    ${actual}=    Get Element Count    ${BTN_DELETE}
    Should Be Equal As Integers    ${actual}    ${expected}

Add Remove Page Delete Buttons Count Should Eventually Be
    [Arguments]    ${expected}
    Wait Until Keyword Succeeds    5x    200ms    Add Remove Page Delete Buttons Count Should Be    ${expected}

Add Remove Page URL Should Be Correct
    Location Should Be    ${WEB_BASE_URL}${ADD_REMOVE_PATH}

Add Remove Page Add Button Should Be Visible
    Element Should Be Visible    ${BTN_ADD}
