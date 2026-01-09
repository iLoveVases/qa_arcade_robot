*** Settings ***
Resource         ../../resources/api/books.resource
Suite Setup      Setup API Session

*** Test Cases ***
# Log To Console is not performed if assertion fails

[001] Verify Status 200 - Get All Books
    [Documentation]    Verify that the /books endpoint is accessible.
    # GIVEN API session is created (Suite Setup)
    # WHEN I request the list of books
    # THEN the API should respond with 200
    ${response}=       GET On Session    api_session    /books
    Status Should Be   200    ${response}
    Log To Console     \nSuccessfully retrieved books list.


[002] Verify Status 404 - Non Existing Resource
    [Documentation]    Verify 404 error for invalid book ID.
    ${response}=       GET On Session    api_session    /books/99999    expected_status=404
    Status Should Be   404    ${response}
    Log To Console     \nCorrect 404 response for invalid ID.

[003] Verify Status 201 and 200 and 204 - Create, Read Single, Delete Order
    [Documentation]    Flow: registration -> create order -> get single order -> delete order.
    ${token}=          Create Client And Get Token

    ${order_resp}=     Create Order    book_id=1    token=${token}
    Status Should Be   201    ${order_resp}
    Dictionary Should Contain Key    ${order_resp.json()}    orderId
    ${order_id}=       Set Variable    ${order_resp.json()}[orderId]
    Log To Console     \nOrder placed successfully with ID: ${order_id}

    ${single_resp}=    Get Order    ${order_id}    ${token}
    Status Should Be   200    ${single_resp}
    Should Be Equal    ${single_resp.json()}[id]    ${order_id}
    Should Be Equal As Integers    ${single_resp.json()}[bookId]    1
    Should Be Equal    ${single_resp.json()}[customerName]    ${CLIENT_NAME}

    ${del_resp}=       Delete Order    ${order_id}    ${token}
    Status Should Be   204    ${del_resp}
    Log To Console     \nOrder ${order_id} deleted successfully.

[004] Verify Status 409 - Fail Due To Duplicate Email
    [Documentation]    Verify that the API returns 409 Conflict when the email is already taken.
    ${random_str}=     Generate Random String    8    [LETTERS]
    ${email}=          Set Variable    duplicate_${random_str}@example.com

    ${first}=          Register Client With Fixed Email    ${email}
    Status Should Be   201    ${first}

    ${second}=         Register Client With Fixed Email    ${email}
    Verify Error Response    ${second}    409    API client already registered. Try a different email.
    Log To Console     \nCorrectly blocked duplicate email.

[005] Verify Status 401 - Unauthorized Order (Invalid Token)
    [Documentation]    Verify that the API returns 401 Unauthorized for a fake token.
    ${response}=       Create Order    book_id=1    token=WRONG_TOKEN_997
    Verify Error Response    ${response}    401    Invalid bearer token.
    Log To Console     \nCorrectly rejected invalid token.

[006] Data Integrity Check - Validate First 5 Books
    [Documentation]    Validates structure and types for the first 5 books (or fewer if list is shorter).
    ${response}=       GET On Session    api_session    /books
    Status Should Be   200    ${response}

    ${books}=          Set Variable    ${response.json()}
    Should Not Be Empty    ${books}

    ${count}=          Get Length    ${books}
    FOR    ${i}    IN RANGE    ${count}
        Validate Book Structure And Types    ${books[${i}]}
    END

    Log To Console     \nValidated ${count} book entries.

[007] Verify Status 200 - Get All Orders Contains Created Order
    [Documentation]    Creates an order, confirms it appears in GET /orders, then deletes it.
    ${token}=          Create Client And Get Token

    ${order_resp}=     Create Order    book_id=1    token=${token}
    Status Should Be   201    ${order_resp}
    ${order_id}=       Set Variable    ${order_resp.json()}[orderId]

    ${orders_resp}=    Get All Orders    ${token}
    Status Should Be   200    ${orders_resp}
    ${orders}=         Set Variable    ${orders_resp.json()}

    ${order_id}=       Convert To String    ${order_id}
    ${ids}=            Evaluate    [str(o.get("id")) for o in $orders]
    List Should Contain Value    ${ids}    ${order_id}


    ${del_resp}=       Delete Order    ${order_id}    ${token}
    Status Should Be   204    ${del_resp}
    Log To Console     \nOrder ${order_id} found in list and deleted.

[008] Verify Status 400 - Negative Validation (Invalid Data Type)
    [Documentation]    Verify 400 Bad Request when sending invalid data types (bookId as string instead of int).
    ${token}=          Create Client And Get Token
    &{headers}=        Get Auth Headers    ${token}
    &{bad_body}=       Create Dictionary    bookId=abc    customerName=${CLIENT_NAME}

    ${response}=       POST On Session    api_session    /orders/    json=${bad_body}
    ...                headers=${headers}    expected_status=400

    Status Should Be   400    ${response}
    ${error}=          Set Variable    ${response.json()}[error]
    Should Contain     ${error}    bookId
    Log To Console     \nCorrectly handled invalid data type with 400 Bad Request.
