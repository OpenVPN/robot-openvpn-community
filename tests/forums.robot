*** Settings ***

Resource  ../resources/common.robot

Task Setup  Begin Selenium Web Test
Task Teardown  End Selenium Web Test

*** Test Cases ***

Login To Forums
  SeleniumLibrary.Go To  ${FORUMS_MAIN_PAGE}

  SeleniumLibrary.Click Element  xpath://a[contains(text(), 'Login') and not(@class='lastsubject')]
  SeleniumLibrary.Input Text  id:username  %{COMMUNITY_LDAP_USERNAME}
  SeleniumLibrary.Input Password  id:password  %{COMMUNITY_LDAP_PASSWORD}
  # Without a small delay clicking on "Login" consistently fails
  Sleep  1
  SeleniumLibrary.Click Element  name:login
  SeleniumLibrary.Wait Until Page Contains  Logout
