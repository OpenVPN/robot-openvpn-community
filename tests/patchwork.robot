*** Settings ***

Resource  ../resources/common.robot

Task Setup  Begin Selenium Web Test
Task Teardown  End Selenium Web Test

*** Test Cases ***

Login To Patchwork
  Go To  ${PATCHWORK_OPENVPN2_PAGE}

  Click Link  Login
  Input Text  id:id_username  %{PATCHWORK_USERNAME}
  Input Password  id:id_password  %{PATCHWORK_PASSWORD}
  # This submits the first form found on the Patchwork login page. This works because
  # there are no other forms. Being more e
  Submit Form
  Wait Until Location Is  https://patchwork.openvpn.net/user/
