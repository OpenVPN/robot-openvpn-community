*** Settings ***

Resource  ../resources/common.robot

Task Setup     Begin Browser Web Test
Task Teardown  End Browser Web Test

*** Test Cases ***

Login To Pwm
  Browser.New Page     ${PWM_MAIN_PAGE}
  Browser.Fill Text    id=username  ${COMMUNITY_LDAP_USERNAME}
  # Browser library handles secrets more security if variable is defined as
  # $var instead of ${var}
  Browser.Fill Secret  id=password  $COMMUNITY_LDAP_PASSWORD
  Browser.Click        id=submitBtn
  Get Element          id=HomeButton
