*** Settings ***

Library  SeleniumLibrary

*** Variables ***

${BROWSER}           firefox
${FORUMS_MAIN_PAGE}  https://forums.openvpn.net

*** Keywords ***

Begin Web Test
    Open Browser  about:blank  ${BROWSER}

End Web Test
    Close Browser

