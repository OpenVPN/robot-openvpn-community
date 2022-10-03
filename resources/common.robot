*** Settings ***

Library  SeleniumLibrary

*** Variables ***

${BROWSER}                  firefox
${FORUMS_MAIN_PAGE}         https://forums.openvpn.net
${PATCHWORK_OPENVPN2_PAGE}  https://patchwork.openvpn.net/project/openvpn2/list/

*** Keywords ***

Begin Web Test
    Open Browser  about:blank  ${BROWSER}

End Web Test
    Close Browser

