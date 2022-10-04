*** Settings ***

Resource  ../resources/common.robot

Task Setup     Begin Browser Web Test
Task Teardown  End Browser Web Test

*** Keywords ***

Login To Pwm
  Browser.New Page     ${PWM_MAIN_PAGE}
  Browser.Fill Text    id=username  ${COMMUNITY_LDAP_USERNAME}
  # Browser library handles secrets more security if variable is defined as
  # $var instead of ${var}
  Browser.Fill Secret  id=password  $COMMUNITY_LDAP_PASSWORD
  Browser.Click        id=submitBtn

Open Update Profile Page
  Browser.Click  id=button_UpdateProfile

Submit Pwm Attribute Change
  # Submit changes
  Browser.Click  id=submitBtn
  # Confirm changes
  Browser.Click  id=confirmBtn
  # Return to user's home page
  Browser.Click  id=submitBtn

Change Value Of Sn
  [Arguments]  ${new_value}
  Browser.Fill Text  id=sn  ${new_value}
  Submit Pwm Attribute Change

Validate Value Of Sn
  [Arguments]  ${expected_value}
  ${sn}  Get Property  id=sn  property=value
  BuiltIn.Should Be Equal  ${sn}  ${expected_value}


*** Test Cases ***

Test Login To Pwm
  Login To Pwm
  Get Element          id=HomeButton

Test Pwm Attribute Change
  Login To Pwm
  Open Update Profile Page
  Validate Value Of Sn  original-before-robot
  Change Value Of Sn  changed-by-robot

  Open Update Profile Page
  Validate Value Of Sn  changed-by-robot
  Change Value Of Sn  original-before-robot
