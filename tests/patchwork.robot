*** Settings ***

Resource  ../resources/common.robot

Task Setup  Begin Selenium Web Test
Task Teardown  End Selenium Web Test

*** Test Cases ***

Login To Patchwork
  SeleniumLibrary.Go To  ${PATCHWORK_OPENVPN2_PAGE}

  SeleniumLibrary.Click Link  Login
  SeleniumLibrary.Input Text  id:id_username  %{PATCHWORK_USERNAME}
  SeleniumLibrary.Input Password  id:id_password  %{PATCHWORK_PASSWORD}
  # This submits the first form found on the Patchwork login page. This works because
  # there are no other forms. Being more e
  SeleniumLibrary.Submit Form
  SeleniumLibrary.Wait Until Location Is  https://patchwork.openvpn.net/user/
