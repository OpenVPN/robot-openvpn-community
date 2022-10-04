*** Settings ***

Resource  ../resources/common.robot

Task Setup     Begin Browser Web Test
Task Teardown  End Browser Web Test

*** Test Cases ***

Login To Trac
  Browser.New Context  httpCredentials=${COMMUNITY_LDAP_CREDENTIALS}
  Browser.New Page     ${TRAC_LOGIN_PAGE}
  Browser.Get Element  "Logout"
