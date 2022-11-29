*** Settings ***

Library  ImapLibrary2
Library  String
Resource  ../resources/common.robot

Task Setup     Begin Browser Web Test
Task Teardown  End Browser Web Test

*** Variables ***

# Constants
${SENDER}                      noreply@openvpn.in
${VERIFICATION_EMAIL_SUBJECT}  Forgotten Password Verification
${NOTIFICATION_EMAIL_SUBJECT}  Password Change Notification

# Email settings for password reset tests
${IMAP_HOST}      %{IMAP_HOST}
${IMAP_PORT}      %{IMAP_PORT}
${IMAP_PASSWORD}  %{IMAP_PASSWORD}

# LDAP user to use for LDAP password reset tests
${PASSWORD_RESET_LDAP_USERNAME}  %{PASSWORD_RESET_LDAP_USERNAME}
${PASSWORD_RESET_LDAP_PASSWORD}  %{PASSWORD_RESET_LDAP_PASSWORD}
${PASSWORD_RESET_LDAP_USER_EMAIL}  %{PASSWORD_RESET_LDAP_USER_EMAIL}

# It seems not possible to have a password input method for password
# reset tests that works universally. So, allow switching between
# two different ones.
${PASSWORD_RESET_INPUT_METHOD}  %{PASSWORD_RESET_INPUT_METHOD}

*** Keywords ***

Validate Pwm Password Reset Parameters
  Builtin.Should Match Regexp  ${PASSWORD_RESET_INPUT_METHOD}  ^(A|B)$

Request Password Reset
  Browser.Set Browser Timeout  30 seconds
  Browser.New Page   ${PWM_MAIN_PAGE}
  Browser.Click      id=Title_ForgottenPassword
  Browser.Fill Text  id=cn  ${PASSWORD_RESET_LDAP_USERNAME}
  Browser.Click      id=submitBtn
  Browser.Fill Text  id=mail  ${PASSWORD_RESET_LDAP_USER_EMAIL}
  Browser.Click      id=submitBtn
  Browser.Click      id=button-continue

Get Password Reset Email
  ImapLibrary2.Open Mailbox    host=${IMAP_HOST}  port=${IMAP_PORT}  user=${PASSWORD_RESET_LDAP_USER_EMAIL}  password=${IMAP_PASSWORD}
  ${confirmation_email} =  ImapLibrary2.Wait For Email  sender=${SENDER}  recipient=${PASSWORD_RESET_LDAP_USER_EMAIL}  subject=${VERIFICATION_EMAIL_SUBJECT}   timeout=120
  Builtin.Return From Keyword  ${confirmation_email}

Get Password Reset URL
  [Arguments]  ${confirmation_email}

  ${parts} =  Walk Multipart Email  ${confirmation_email}
  FOR  ${i}  IN RANGE  ${parts}
    Walk Multipart Email  ${confirmation_email}
    ${content-type} =     Get Multipart Content Type
    Continue For Loop If  '${content-type}' != 'text/html'
    ${payload} =          Get Multipart Payload  decode=True

    # ImapLibrary chokes on the password reset URL which is split into multiple
    # lines. So get rid of linefeeds altogether.
    ${body} =  String.Replace String  ${payload}  \r\n  ${EMPTY}

    # Dig the password reset URL from the string with a regexp
    ${url} =  String.Get Regexp Matches  ${body}  https://(\\w|[.]|/|-|_|=)*

    # Validate that we have just one match
    ${matches} =                        Builtin.Get Length  ${url}
    Builtin.Should Be Equal As Numbers  ${matches}  1
    Builtin.Set Suite Variable          ${password_reset_url}  ${url}[0]
    Builtin.Exit For Loop
  END

  Return From Keyword  ${password_reset_url}

Sanitize Password Reset URL
  [Arguments]  ${password_reset_url}

  ${sanitized_password_reset_url} =  String.Replace String Using Regexp  ${password_reset_url}  https://(\\w|[.])*  ${PWM_BASE_URL}
  Builtin.Return From Keyword                ${sanitized_password_reset_url}

# Pwm a nasty tendency of wiping out one or two of the password fields
# unexpectedly with Javascript. On some systems this list of steps seems to be
# completely reliable and on others completely broken.
Enter New Password Method A
  Browser.Fill Secret  id=password1  $PASSWORD_RESET_LDAP_PASSWORD
  Browser.Fill Secret  id=password2  $PASSWORD_RESET_LDAP_PASSWORD
  Browser.Click        id=password_button

# This works on some systems.
Enter New Password Method B
  Browser.Fill Secret   id=password1  $PASSWORD_RESET_LDAP_PASSWORD
  Browser.Click         id=password1
  Browser.Keyboard Key  press  Enter
  Browser.Fill Secret   id=password2  $PASSWORD_RESET_LDAP_PASSWORD
  Browser.Keyboard Key  press  Enter

Reset Password
  [Arguments]  ${password_reset_url}
  Browser.New Page  ${password_reset_url}
  Browser.Click     id=button-continue
  Builtin.Run Keyword If  '${PASSWORD_RESET_INPUT_METHOD}' == 'A'  Enter New Password Method A
  Builtin.Run Keyword If  '${PASSWORD_RESET_INPUT_METHOD}' == 'B'  Enter New Password Method B

Wait For Password Change Notification
  ${notification_email} =  Wait For Email    sender=${SENDER}  recipient=${PASSWORD_RESET_LDAP_USER_EMAIL}  subject=${NOTIFICATION_EMAIL_SUBJECT}  timeout=120
  Builtin.Return From Keyword  ${notification_email}

Delete Password Reset Emails
  [Arguments]  ${confirmation_email}  ${notification_email}
  Delete Email  ${confirmation_email}
  Delete Email  ${notification_email}
  Close Mailbox

*** Test Cases ***

Test Pwm Password Reset
  Validate Pwm Password Reset Parameters
  Request Password Reset

  ${confirmation_email} =            Get Password Reset Email
  ${password_reset_url} =            Get Password Reset URL       ${confirmation_email}
  ${sanitized_password_reset_url} =  Sanitize Password Reset URL  ${password_reset_url}
  Reset Password  ${sanitized_password_reset_url}
  ${notification_email} =            Wait For Password Change Notification

  # ImapLibrary2 does not reliably open the latest password reset email, no
  # matter which email status you use. To avoid wrong links getting clicked
  # delete all emails related to the current password reset process. The next
  # time the INBOX will be empty of junk.
  Delete Password Reset Emails  ${confirmation_email}  ${notification_email}
