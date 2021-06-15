*** Settings ***
Resource  ../SettingsAndLibraries.robot

*** Test Cases ***
Get Started

    Clear All Catches
    Select Angler On Home Page  GARY
    Go To Home Page
    Select Angler On Home Page  JASON
    Go To Home Page
    Select Angler On Home Page  JOE
    Go To Home Page
    Select Angler On Home Page  KEVIN


SCENARIO - Validate Angler Links Navigate Correctly
    Given User Navigates To Live Scorer Home Page
      And User Clears All Catches
    When User Clicks Angler Name  GARY
    Then Angler Page Heading Should Be  GARY
    When User Returns To Home Page
      And User Clicks Angler Name  JASON
    Then Angler Page Heading Should Be  JASON
    When User Returns To Home Page
      And User Clicks Angler Name  JOE
    Then Angler Page Heading Should Be  JOE
    When User Returns To Home Page
      And User Clicks Angler Name  KEVIN
    Then Angler Page Heading Should Be  KEVIN



*** Keywords ***
# ====================================
# Home Page Keywords
# ====================================
User Navigates To Live Scorer Home Page
    open browser  ${app-url}  chrome



User Clicks Angler Name
    [Arguments]  ${anglerName}

    click element  //*/button[text() = '${SPACE}${anglerName}${SPACE}']


User Clears All Catches
    click element  //*/button[@class = 'btn btn-danger btn-sm']
    Sleep  3s


User Returns To Home Page
    go to  ${app-url}

# ====================================
# Angler Page Keywords
# ====================================

Angler Page Heading Should Be
    [Arguments]  ${expected}

    ${found}=  get text  //*/h1
    should be equal as strings  ${expected}  ${found}  Incorrect Angler heading


Total Fish Caught Should Be
    [Arguments]  ${expected}


Standings Data Should Contain
    [Arguments]  ${name}  ${expectedCatchCount}  ${expectedTotalWeight}

    ${foundCatchCount}=  get text  //*/table/tbody/tr/td[1][text() = '${name}']/../td[2]
    ${foundTotalWeight}=  get text  //*/table/tbody/tr/td[1][text() = '${name}']/../td[3]

    should be equal as integers  ${expectedCatchCount}  ${foundCatchCount}  Incorrect total catch for ${name}
    should be equal as numbers  ${expectedTotalWeight}  ${foundTotalWeight}  Incorrect total weight for ${name}





