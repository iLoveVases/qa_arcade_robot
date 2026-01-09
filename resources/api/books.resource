*** Settings ***
Library          RequestsLibrary
Library          Collections
Library          String

*** Variables ***
${BASE_URL}      https://simple-books-api.click
${CLIENT_NAME}   Wojciech

*** Keywords ***
Setup API Session
    [Documentation]    Creates a persistent session for the API.
    Create Session    api_session    ${BASE_URL}    verify=True


Create Client And Get Token
    [Documentation]    Registers a new client with a random email and returns the access token.
    ${random_str}=     Generate Random String    8    [LETTERS]
    ${email}=          Set Variable    test_${random_str}@example.com
    &{auth_body}=      Create Dictionary    clientName=${CLIENT_NAME}    clientEmail=${email}

    ${response}=       POST On Session    api_session    /api-clients/    json=${auth_body}    expected_status=any
    Status Should Be   201    ${response}
    RETURN             ${response.json()}[accessToken]


Register New Client And Get Token
    [Documentation]    Alias for Create Client And Get Token.
    ${token}=          Create Client And Get Token
    RETURN             ${token}

Register And Get Token
    [Documentation]    Alias for Create Client And Get Token.
    ${token}=          Create Client And Get Token
    RETURN             ${token}


Register Client With Fixed Email
    [Arguments]        ${email}
    [Documentation]    Attempts to register a client with a specific email.
    &{auth_body}=      Create Dictionary    clientName=${CLIENT_NAME}    clientEmail=${email}
    ${response}=       POST On Session      api_session    /api-clients/    json=${auth_body}    expected_status=any
    RETURN             ${response}


Get Auth Headers
    [Arguments]    ${token}
    &{headers}=    Create Dictionary    Authorization=Bearer ${token}
    RETURN         ${headers}


Create Order
    [Arguments]        ${book_id}    ${token}
    [Documentation]    Places an order using the provided token.
    &{order_body}=     Create Dictionary    bookId=${book_id}    customerName=${CLIENT_NAME}
    &{headers}=        Get Auth Headers    ${token}

    ${response}=       POST On Session    api_session    /orders/
    ...                json=${order_body}    headers=${headers}    expected_status=any
    RETURN             ${response}



Place Order For Book
    [Arguments]        ${book_id}    ${token}
    [Documentation]    Alias for Create Order.
    ${response}=       Create Order    ${book_id}    ${token}
    RETURN             ${response}


Get All Orders
    [Arguments]        ${token}
    [Documentation]    Returns all orders created by the API client.
    &{headers}=        Get Auth Headers    ${token}
    ${response}=       GET On Session    api_session    /orders
    ...                headers=${headers}    expected_status=any
    RETURN             ${response}

Get Order
    [Arguments]        ${order_id}    ${token}
    [Documentation]    Returns details of a single order.
    &{headers}=        Get Auth Headers    ${token}
    ${response}=       GET On Session    api_session    /orders/${order_id}
    ...                headers=${headers}    expected_status=any
    RETURN             ${response}


Delete Order
    [Arguments]        ${order_id}    ${token}
    [Documentation]    Deletes an order.
    &{headers}=        Get Auth Headers    ${token}
    ${response}=       DELETE On Session    api_session    /orders/${order_id}
    ...                headers=${headers}    expected_status=any
    RETURN             ${response}


Verify Error Response
    [Arguments]    ${response}    ${expected_status}    ${expected_message}
    Status Should Be    ${expected_status}    ${response}
    Should Be Equal     ${response.json()}[error]    ${expected_message}


Validate Book Structure And Types
    [Arguments]    ${book}
    [Documentation]    Validates that the book object contains all required keys and correct data types.
    Dictionary Should Contain Key    ${book}    id
    Dictionary Should Contain Key    ${book}    name
    Dictionary Should Contain Key    ${book}    type
    Dictionary Should Contain Key    ${book}    available

    ${is_int}=        Evaluate    isinstance($book['id'], int)
    Should Be True    ${is_int}
    ${is_str_name}=   Evaluate    isinstance($book['name'], str)
    Should Be True    ${is_str_name}
    ${is_str_type}=   Evaluate    isinstance($book['type'], str)
    Should Be True    ${is_str_type}
    ${is_bool}=       Evaluate    isinstance($book['available'], bool)
    Should Be True    ${is_bool}
