@echo off
IF [%1]==[] GOTO usage
IF [%2]==[] GOTO usage
node build.js %1 %2
IF ERRORLEVEL 1 GOTO :EOF
cd /D %2
vagrant up
GOTO :EOF
:usage
node build.js
