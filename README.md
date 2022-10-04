# robot-openvpn-community

Robot Framework test suite for OpenVPN community services.

# Tests

* *community.robot*
    * Test Trac login through VPC/VPN to avoid Cloudflare
* *forums.robot*
    * Test forums login through the Internet
* *patchwork.robot*
    * Test patchwork login through the Internet
* *pwm.robot*
    * Test Pwm login through the intranet to avoid Cloudflare
    * Test changing the "sn" attribute in LDAP using Pwm's "Update profile" page
