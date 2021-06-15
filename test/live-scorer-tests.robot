*** Settings ***
Resource  ../SettingsAndLibraries.robot

*** Test Cases ***
Get Started
    open browser  ${app-url}  chrome
    Clear All Catches
    Select Angler On Home Page  GARY
    Go To Home Page
    Select Angler On Home Page  JASON
    Go To Home Page
    Select Angler On Home Page  JOE
    Go To Home Page
    Select Angler On Home Page  KEVIN



*** Keywords ***
# ====================================
# Home Page Keywords
# ====================================
Select Angler On Home Page
    [Arguments]  ${anglerName}

    click element  //*/button[text() = '${SPACE}${anglerName}${SPACE}']


Clear All Catches
    click element  //*/button[@class = 'btn btn-danger btn-sm']
    Sleep  3s


Go To Home Page
    go to  ${app-url}

# ====================================
# Angler Page Keywords
# ====================================

Angler Page Heading Should Be
    [Arguments]  ${expected}


Total Fish Caught Should Be
    [Arguments]  ${expected}


Standings Data Should Contain
    [Arguments]  ${name}  ${expectedCatchCount}  ${expectedTotalWeight}

    ${foundCatchCount}=  get text  //*/table/tbody/tr/td[1][text() = '${name}']/../td[2]
    ${foundTotalWeight}=  get text  //*/table/tbody/tr/td[1][text() = '${name}']/../td[3]

    should be equal as integers  ${expectedCatchCount}  ${foundCatchCount}  Incorrect total catch for ${name}
    should be equal as numbers  ${expectedTotalWeight}  ${foundTotalWeight}  Incorrect total weight for ${name}





