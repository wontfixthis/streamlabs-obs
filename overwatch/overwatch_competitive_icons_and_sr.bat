@echo off

REM API Documentation: https://ow-api.com/docs/#introduction
REM Change Variables!
REM You need to install an additional tool called "jq" : https://stedolan.github.io/jq/download/
REM jq has to be available in path variables!
REM -
REM Have fun! Wontfixthis

REM Variables ##################################################################

REM Timeout in seconds
set TIMEOUT=300
REM Example: https://ow-api.com/v1/stats/:platform/:region/:battletag/profile
set PROFILE_STRING="https://ow-api.com/v1/stats/pc/eu/mybattletag-12345/profile"

REM ############################################################################

REM Loopoint
:loop

REM GET DATA
curl %PROFILE_STRING%|jq > output.json

REM Write ratings to txt
type output.json|jq .ratings[0].level > tank_stat.txt
type output.json|jq .ratings[1].level > dps_stat.txt
type output.json|jq .ratings[2].level > support_stat.txt

REM Generate Image URL Strings and write to txt
type output.json|jq .ratings[0].roleIcon > tank_roleicon_url.txt
type output.json|jq .ratings[0].rankIcon > tank_rankicon_url.txt
type output.json|jq .ratings[1].roleIcon > dps_roleicon_url.txt
type output.json|jq .ratings[1].rankIcon > dps_rankicon_url.txt
type output.json|jq .ratings[2].roleIcon > support_roleicon_url.txt
type output.json|jq .ratings[2].rankIcon > support_rankicon_url.txt

REM Load Download Rank and Roleicon URLs to VAR
set /p TANK_ROLEICON_URL=<tank_roleicon_url.txt
set /p TANK_RANKICON_URL=<tank_rankicon_url.txt
set /p DPS_ROLEICON_URL=<dps_roleicon_url.txt
set /p DPS_RANKICON_URL=<dps_rankicon_url.txt
set /p SUPPORT_ROLEICON_URL=<support_roleicon_url.txt
set /p SUPPORT_RANKICON_URL=<support_rankicon_url.txt

REM Download Rank and Roleicons
curl -o tank_roleicon.png %TANK_ROLEICON_URL%
curl -o tank_rankicon.png %TANK_RANKICON_URL%
curl -o dps_roleicon.png %DPS_ROLEICON_URL%
curl -o dps_rankicon.png %DPS_RANKICON_URL%
curl -o support_roleicon.png %SUPPORT_ROLEICON_URL%
curl -o support_rankicon.png %SUPPORT_RANKICON_URL%

REM Load txt to VAR
set /p TANK_STAT=<tank_stat.txt
set /p DPS_STAT=<dps_stat.txt
set /p SUPPORT_STAT=<support_stat.txt

REM Output SLOBS String
echo TANK: %TANK_STAT% DPS: %DPS_STAT% SUPPORT: %SUPPORT_STAT% > overwatch_rs_slobs.txt

REM Remove useless files
del /f output.json

REM del /f tank_stat.txt
REM del /f dps_stat.txt
REM del /f support_stat.txt

del /f tank_roleicon_url.txt
del /f tank_rankicon_url.txt
del /f dps_roleicon_url.txt
del /f dps_rankicon_url.txt
del /f support_roleicon_url.txt
del /f support_rankicon_url.txt

REM Timeout
echo Last refresh: %DATE% %TIME%
echo Wating %TIMEOUT% Seconds...
timeout /T %TIMEOUT%  > nul

goto loop
