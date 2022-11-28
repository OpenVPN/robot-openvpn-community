# robot-openvpn-community

Robot Framework test suite for OpenVPN community services.

# Prerequisites

You will a few pip3 packages. The versions that are known to work are:

* robotframework (5.0.1)
* robotframework-browser (14.1.0)
* robotframework-seleniumlibrary (6.0.0)
* robotframework-imaplibrary2 (0.4.6)

# Tests

## community.robot

This tests Trac login through internal network to avoid Cloudflare.
Environment variables required:

* COMMUNITY_LDAP_USERNAME
* COMMUNITY_LDAP_PASSWORD

## forums.robot

Test forums login through the Internet. Environment variables required:

* COMMUNITY_LDAP_USERNAME
* COMMUNITY_LDAP_PASSWORD

## patchwork.robot

Test patchwork login through the Internet. Environment variables required:

* PATCHWORK_USERNAME
* PATCHWORK_PASSWORD

## pwm.robot

Test basic Pwm functionality plus the LDAP backend:

* Test Pwm login through the intranet to avoid Cloudflare
* Test changing the "sn" attribute in LDAP using Pwm's "Update profile" page
* Test password reset functionality

Environment variables required:

* COMMUNITY_LDAP_USERNAME
* COMMUNITY_LDAP_PASSWORD
* PASSWORD_RESET_INPUT_METHOD: Method to use to input passwords into Pwm password reset form. Use either "A" or "B", depending on which works in your case.
* PASSWORD_RESET_LDAP_USERNAME: LDAP user to test password resets on
* PASSWORD_RESET_LDAP_PASSWORD: LDAP user password
* PASSWORD_RESET_LDAP_USER_EMAIL: The email address used by the LDAP user. This is also used to as IMAP username.
* IMAP_HOST: IMAP server DNS name or IP address
* IMAP_PORT: IMAP port
* IMAP_PASSWORD: The IMAP password
