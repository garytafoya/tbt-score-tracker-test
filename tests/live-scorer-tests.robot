*** Settings ***
Resource  ../SettingsAndLibraries.robot

*** Test Cases ***

go to site
    User Navigates To Live Scorer Home Page

SCENARIO - Validate Angler Links Navigate Correctly
    Given User Navigates To Live Scorer Home Page
      And User Clears All Catches
    When User Clicks Angler GARY
    Then Angler Page Heading Should Be  GARY
      And Angler Page Should Reflect No Catches Exist For  GARY
    When User Returns To Home Page
      And User Clicks Angler JASON
    Then Angler Page Heading Should Be  JASON
      And Angler Page Should Reflect No Catches Exist For  JASON
    When User Returns To Home Page
      And User Clicks Angler JOE
    Then Angler Page Heading Should Be  JOE
      And Angler Page Should Reflect No Catches Exist For  JOE
    When User Returns To Home Page
      And User Clicks Angler KEVIN
    Then Angler Page Heading Should Be  KEVIN
      And Angler Page Should Reflect No Catches Exist For  KEVIN


SCENARIO: Adding a Single Fish For Each Angler
    Given User Navigates To Live Scorer Home Page
      And User Clears All Catches
    When User Clicks Angler GARY
      And User Adds Fish Catch That Weighs 1.10
    Then Big Bass Should Be 1.10 By GARY
      And Angler Should Have Caught 1 Fish
      And Most Recent Fish Caught Should Weigh 1.10
      And Standings Data Should Contain  GARY  1  1.10  1.10

    When User Returns To Home Page
      And User Clicks Angler JASON
      And User Adds Fish Catch That Weighs 2.20
    Then Big Bass Should Be 2.20 By JASON
      And Angler Should Have Caught 1 Fish
      And Most Recent Fish Caught Should Weigh 2.20
      And Standings Data Should Contain  JASON  1  2.20  2.20

    When User Returns To Home Page
      And User Clicks Angler JOE
      And User Adds Fish Catch That Weighs 3.30
    Then Big Bass Should Be 3.30 By JOE
      And Angler Should Have Caught 1 Fish
      And Most Recent Fish Caught Should Weigh 3.30
      And Standings Data Should Contain  JOE  1  3.30  3.30

    When User Returns To Home Page
      And User Clicks Angler KEVIN
      And User Adds Fish Catch That Weighs 4.40
    Then Big Bass Should Be 4.40 By KEVIN
      And Angler Should Have Caught 1 Fish
      And Most Recent Fish Caught Should Weigh 4.40
      And Standings Data Should Contain  KEVIN  1  4.40  4.40

    Then First Place Should Be KEVIN With 1 Catches, Total Weight Of 4.40 And Best Five Of 4.40
      And Second Place Should Be JOE With 1 Catches, Total Weight Of 3.30 And Best Five Of 3.30
      And Third Place Should Be JASON With 1 Catches, Total Weight Of 2.20 And Best Five Of 2.20
      And Fourth Place Should Be GARY With 1 Catches, Total Weight Of 1.10 And Best Five Of 1.10


*** Keywords ***
# ====================================
# Home Page Keywords
# ====================================
User Navigates To Live Scorer Home Page
    open browser  ${app-url}  chrome


User Clicks Angler ${anglerName}
    click element  ${anglerName}
    Sleep  2s


User Clears All Catches
    click element  clearAll
    Sleep  3s


User Returns To Home Page
    go to  ${app-url}

# ====================================
# Angler Page Keywords
# ====================================

Angler Page Heading Should Be
    [Arguments]  ${expected}

    ${found}=  get text  header
    run keyword and continue on failure  should be equal as strings  ${expected}  ${found}  Incorrect Angler heading


Angler Page Should Reflect No Catches Exist For
    [Arguments]  ${anglerName}
    run keyword and continue on failure  page should contain  NO FISH CAUGHT IN THE FIELD
    run keyword and continue on failure  page should contain  ${anglerName}, YOU HAVEN'T CAUGHT ANYTHING YET


Big Bass Should Be ${weight} By ${anglerName}
    run keyword and continue on failure  page should contain  BIG BASS: ${weight} - ${anglerName}


Angler Should Have Caught ${expectedCount} Fish
    run keyword and continue on failure  page should contain  Your Catch Count: ${expectedCount}

    ${foundRowCount}=  get element count  //*/table[@id = 'individualCatchList']/tbody/tr
    run keyword and continue on failure  should be equal as integers  ${expectedCount}  ${foundRowCount}  Wrong number of individual fish catch rows


Standings Data Should Contain
    [Arguments]  ${name}  ${expectedCatchCount}  ${expectedTotalWeight}  ${expectedBestFive}

    ${foundCatchCount}=  get text  //*/table[@id='leaderboard']/tbody/tr/td[1][text() = '${name}']/../td[2]
    ${foundTotalWeight}=  get text  //*/table[@id='leaderboard']/tbody/tr/td[1][text() = '${name}']/../td[3]
    ${foundBestFive}=  get text  //*/table[@id='leaderboard']/tbody/tr/td[1][text() = '${name}']/../td[4]

    run keyword and continue on failure  should be equal as integers  ${expectedCatchCount}  ${foundCatchCount}  Incorrect total catch for ${name}
    run keyword and continue on failure  should be equal as numbers  ${expectedTotalWeight}  ${foundTotalWeight}  Incorrect total weight for ${name}
    run keyword and continue on failure  should be equal as numbers  ${expectedBestFive}  ${foundBestFive}  Incorrect best 5 weight for ${name}

User Clicks Add Fish
    click element  addFish
    wait until element is visible  add-fish


User Adds Fish Catch That Weighs ${weight}
    click element  addFish
    wait until element is visible  add-fish
    input text  add-fish-input  ${weight}
    click element  //*/button[text() = 'OK']
    wait until element is not visible  add-fish


Most Recent Fish Caught Should Weigh ${expectedWeight}
    ${foundWeight}=  get text  //*/table[@id = 'individualCatchList']/tbody/tr[1]/td[2]
    run keyword and continue on failure  should be equal as numbers  ${expectedWeight}  ${foundWeight}  Weight of most recent fish is incorrect


First Place Should Be ${anglerName} With ${expectedCatchCount} Catches, Total Weight Of ${expectedTotalWeight} And Best Five Of ${expectedBestFive}
    Check Placement  1  ${anglerName}  ${expectedCatchCount}  ${expectedTotalWeight}  ${expectedBestFive}


Second Place Should Be ${anglerName} With ${expectedCatchCount} Catches, Total Weight Of ${expectedTotalWeight} And Best Five Of ${expectedBestFive}
    Check Placement  2  ${anglerName}  ${expectedCatchCount}  ${expectedTotalWeight}  ${expectedBestFive}


Third Place Should Be ${anglerName} With ${expectedCatchCount} Catches, Total Weight Of ${expectedTotalWeight} And Best Five Of ${expectedBestFive}
    Check Placement  3  ${anglerName}  ${expectedCatchCount}  ${expectedTotalWeight}  ${expectedBestFive}


Fourth Place Should Be ${anglerName} With ${expectedCatchCount} Catches, Total Weight Of ${expectedTotalWeight} And Best Five Of ${expectedBestFive}
    Check Placement  4  ${anglerName}  ${expectedCatchCount}  ${expectedTotalWeight}  ${expectedBestFive}


Check Placement
    [Arguments]  ${place}  ${expectedAnglerName}  ${expectedCatchCount}  ${expectedTotalWeight}  ${expectedBestFive}

    ${foundAngerName}=  get text  //*/table[@id='leaderboard']/tbody/tr[${place}]/td[1]
    ${foundCatchCount}=  get text  //*/table[@id='leaderboard']/tbody/tr[${place}]/td[2]
    ${foundTotalWeight}=  get text  //*/table[@id='leaderboard']/tbody/tr[${place}]/td[3]
    ${foundBestFive}=  get text  //*/table[@id='leaderboard']/tbody/tr[${place}]/td[4]

    run keyword and continue on failure  should be equal as strings  ${expectedAnglerName}  ${foundAngerName}  Incorrect place for ${expectedAnglerName}
    run keyword and continue on failure  should be equal as numbers  ${expectedCatchCount}  ${foundCatchCount}  Incorrect total catch for ${expectedAnglerName}
    run keyword and continue on failure  should be equal as numbers  ${expectedTotalWeight}  ${foundTotalWeight}  Incorrect total weight for ${expectedAnglerName}
    run keyword and continue on failure  should be equal as numbers  ${expectedBestFive}  ${foundBestFive}  Incorrect best 5 weight for ${expectedAnglerName}