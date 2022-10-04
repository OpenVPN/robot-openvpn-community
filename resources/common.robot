*** Settings ***

Library  SeleniumLibrary
Library  Browser

*** Variables ***

${BROWSER}                  firefox
${FORUMS_MAIN_PAGE}         https://forums.openvpn.net
${PWM_MAIN_PAGE}            https://pwm.openvpn.in/pwm
${TRAC_LOGIN_PAGE}          https://community.openvpn.in/openvpn/login
${PATCHWORK_OPENVPN2_PAGE}  https://patchwork.openvpn.net/project/openvpn2/list/

# This is required for connections from VPN or VPC because of certificate mismatch (.in instead of .net)
@{CHROMIUM_ARGS}            --ignore-certificate-errors

# Required for basic auth (Trac)
${COMMUNITY_LDAP_USERNAME}     %{COMMUNITY_LDAP_USERNAME}
${COMMUNITY_LDAP_PASSWORD}     %{COMMUNITY_LDAP_PASSWORD}

# The Browser library handles secrets more securely if variable is defined as
# $var instead of ${var}
&{COMMUNITY_LDAP_CREDENTIALS}  username=$COMMUNITY_LDAP_USERNAME  password=$COMMUNITY_LDAP_PASSWORD

*** Keywords ***

Begin Selenium Web Test
    SeleniumLibrary.Open Browser  about:blank  ${BROWSER}

End Selenium Web Test
    SeleniumLibrary.Close Browser

Begin Browser Web Test
    Browser.New Browser  chromium  false  args=${CHROMIUM_ARGS}

End Browser Web Test
    Browser.Close Browser
