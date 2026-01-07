*** Settings ***
Resource    ../../common.resource

*** Variables ***
${CHECKBOXES_PATH}     /checkboxes
${HEADING}             css=h3
${CB_ALL}              css=#checkboxes input[type="checkbox"]
${CB1}                 xpath=//form[@id="checkboxes"]/input[1]
${CB2}                 xpath=//form[@id="checkboxes"]/input[2]

*** Keywords ***
Checkboxes Page Open
    Go To    ${WEB_BASE_URL}${CHECKBOXES_PATH}
    Wait Until Element Is Visible    ${HEADING}
    Element Should Contain           ${HEADING}    Checkboxes
    ${count}=    Get Element Count   ${CB_ALL}
    Should Be Equal As Integers      ${count}    2


Checkboxes Page Set Checkbox By Index
# Sets checkbox state: direct_set = Select/Unselect, toggle = click only if needed.
    [Arguments]    ${index}    ${target_checked}    ${mode}
    ${locator}=    Set Variable If    ${index} == 0    ${CB1}    ${CB2}

    IF    '${mode}' == 'direct_set'
        IF    ${target_checked}
            Select Checkbox    ${locator}
        ELSE
            Unselect Checkbox  ${locator}
        END
    ELSE IF    '${mode}' == 'toggle'
        ${is_selected}=    Run Keyword And Return Status    Checkbox Should Be Selected    ${locator}
        IF    ${target_checked} and not ${is_selected}
            Click Element    ${locator}
        ELSE IF    (not ${target_checked}) and ${is_selected}
            Click Element    ${locator}
        END
    ELSE
        Fail    Unknown mode: ${mode}
    END

Checkboxes Page Checkbox By Index Should Be
    [Arguments]    ${index}    ${expected_checked}
    ${locator}=    Set Variable If    ${index} == 0    ${CB1}    ${CB2}
    IF    ${expected_checked}
        Checkbox Should Be Selected        ${locator}
    ELSE
        Checkbox Should Not Be Selected    ${locator}
    END

Checkboxes Page Checkbox By Index Should Eventually Be
    [Arguments]    ${index}    ${expected_checked}
    Wait Until Keyword Succeeds    5x    200ms    Checkboxes Page Checkbox By Index Should Be    ${index}    ${expected_checked}

Checkboxes Page URL Should Be Correct
    Location Should Be    ${WEB_BASE_URL}${CHECKBOXES_PATH}
