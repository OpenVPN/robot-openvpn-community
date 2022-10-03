*** Settings ***

Library  SeleniumLibrary

*** Variables ***

${BROWSER}                  firefox
${FORUMS_MAIN_PAGE}         https://forums.openvpn.net
${PATCHWORK_OPENVPN2_PAGE}  https://patchwork.openvpn.net/project/openvpn2/list/

*** Keywords ***

Begin Selenium Web Test
    SeleniumLibrary.Open Browser  about:blank  ${BROWSER}

End Selenium Web Test
    SeleniumLibrary.Close Browser
