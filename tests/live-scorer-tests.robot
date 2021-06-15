*** Settings ***
Resource  ../SettingsAndLibraries.robot

*** Test Cases ***

go to site
    User Navigates To Live Scorer Home Page

SCENARIO - Validate Angler Links Navigate Correctly
    Given User Navigates To Live Scorer Home Page
      And User Clears All Catches
    When User Clicks Angler Name  GARY
    Then Angler Page Heading Should Be  GARY
      And Angler Page Should Reflect No Catches Exist For  GARY
    When User Returns To Home Page
      And User Clicks Angler Name  JASON
    Then Angler Page Heading Should Be  JASON
      And Angler Page Should Reflect No Catches Exist For  JASON
    When User Returns To Home Page
      And User Clicks Angler Name  JOE
    Then Angler Page Heading Should Be  JOE
      And Angler Page Should Reflect No Catches Exist For  JOE
    When User Returns To Home Page
      And User Clicks Angler Name  KEVIN
    Then Angler Page Heading Should Be  KEVIN
      And Angler Page Should Reflect No Catches Exist For  KEVIN


SCENARIO: Start Adding Fish
    Given User Navigates To Live Scorer Home Page
      And User Clears All Catches
    When User Clicks Angler Name  GARY

    User Clicks Add Fish
    User Adds New Fish  2.20

    Big Bass Of The Day Should Be  GARY  2.20
    Individual Angler Catch Count Should Be  1






*** Keywords ***
# ====================================
# Home Page Keywords
# ====================================
User Navigates To Live Scorer Home Page
    open browser  ${app-url}  chrome



User Clicks Angler Name
    [Arguments]  ${anglerName}
    click element  //*/button[text() = '${SPACE}${anglerName}${SPACE}']
    Sleep  2s


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
    run keyword and continue on failure  should be equal as strings  ${expected}  ${found}  Incorrect Angler heading


Angler Page Should Reflect No Catches Exist For
    [Arguments]  ${anglerName}
    run keyword and continue on failure  page should contain  NO FISH CAUGHT IN THE FIELD
    run keyword and continue on failure  page should contain  YOU HAVEN'T CAUGHT ANYTHING ${anglerName}



Big Bass Of The Day Should Be
    [Arguments]  ${anglerName}  ${weight}
    run keyword and continue on failure  page should contain  BIG BASS: ${weight} - ${anglerName}


Individual Angler Catch Count Should Be
    [Arguments]  ${expectedCount}
    run keyword and continue on failure  page should contain  Your Catch Count: ${expectedCount}

    ${foundRowCount}=  get element count  //*/h5/strong[contains (text(), 'Your Catch Count')]/../../table/tbody/tr
    run keyword and continue on failure  should be equal as integers  ${expectedCount}  ${foundRowCount}  Wrong number of individual fish catch rows


Standings Data Should Contain
    [Arguments]  ${name}  ${expectedCatchCount}  ${expectedTotalWeight}

    ${foundCatchCount}=  get text  //*/table/tbody/tr/td[1][text() = '${name}']/../td[2]
    ${foundTotalWeight}=  get text  //*/table/tbody/tr/td[1][text() = '${name}']/../td[3]

    run keyword and continue on failure  should be equal as integers  ${expectedCatchCount}  ${foundCatchCount}  Incorrect total catch for ${name}
    run keyword and continue on failure  should be equal as numbers  ${expectedTotalWeight}  ${foundTotalWeight}  Incorrect total weight for ${name}

User Clicks Add Fish
    click element  //*/button[text() = '${SPACE}Add Fish${SPACE}']
    wait until element is visible  //*/div[@id = 'add-fish']


User Adds New Fish
    [Arguments]  ${weight}
    input text  //*/input  ${weight}
    click element  //*/button[text() = 'OK']
    wait until element is not visible  //*/div[@id = 'add-fish']
