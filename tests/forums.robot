*** Settings ***

Resource  ../resources/common.robot

Task Setup  Begin Web Test
Task Teardown  End Web Test

*** Test Cases ***

Login To Forums
  Go To  ${FORUMS_MAIN_PAGE}

  Click Element  xpath://a[contains(text(), 'Login')]
  Input Text  id:username  %{COMMUNITY_LDAP_USERNAME}
  Input Password  id:password  %{COMMUNITY_LDAP_PASSWORD}
  # Without a small delay clicking on "Login" consistently fails
  Sleep  1
  Click Element  name:login
  Wait Until Page Contains  Logout
