@echo off
setlocal EnableExtensions EnableDelayedExpansion

rem ==============================================
rem  RK - ROOT KERNEL :: Enhanced Console UI
rem  Author: DEV TEJ
rem  Version: 3.0 (Dark Red & Grey Theme)
rem ==============================================

rem --- Configuration ---
set "RK_NAME=RK - ROOT KERNEL"
set "RK_VERSION=3.0"
set "RK_AUTHOR=DEV TEJ"
set "HWID=%~dp0METHODS\Activators\HWID_Activation.cmd"
set "STATUS=%~dp0METHODS\Check_Activation_Status.cmd"
set "CONSOLE_WIDTH=82"
set "CONSOLE_HEIGHT=28"

rem --- ANSI escape sequence ---
for /F %%a in ('echo prompt $E ^| cmd') do set "ESC=%%a"
if not defined ESC set "ESC="

rem --- Color codes (ANSI) - Dark Red & Grey Theme ---
set "C_RESET=%ESC%[0m"
set "C_BLACK=%ESC%[30m"
set "C_RED=%ESC%[31m"
set "C_GREEN=%ESC%[32m"
set "C_YELLOW=%ESC%[33m"
set "C_BLUE=%ESC%[34m"
set "C_MAGENTA=%ESC%[35m"
set "C_CYAN=%ESC%[36m"
set "C_WHITE=%ESC%[37m"
set "C_BRIGHT_BLACK=%ESC%[37m"
set "C_BRIGHT_RED=%ESC%[91m"
set "C_BRIGHT_GREEN=%ESC%[92m"
set "C_BRIGHT_YELLOW=%ESC%[93m"
set "C_BRIGHT_BLUE=%ESC%[94m"
set "C_BRIGHT_MAGENTA=%ESC%[95m"
set "C_BRIGHT_CYAN=%ESC%[96m"
set "C_BRIGHT_WHITE=%ESC%[97m"
set "C_BG_BLACK=%ESC%[40m"
set "C_BG_RED=%ESC%[41m"
set "C_BG_GREEN=%ESC%[42m"
set "C_BG_YELLOW=%ESC%[43m"
set "C_BG_BLUE=%ESC%[44m"
set "C_BG_MAGENTA=%ESC%[45m"
set "C_BG_CYAN=%ESC%[46m"
set "C_BG_WHITE=%ESC%[47m"
set "C_BOLD=%ESC%[1m"
set "C_DIM=%ESC%[2m"
set "C_UNDERLINE=%ESC%[4m"
set "C_BLINK=%ESC%[5m"
set "C_REVERSE=%ESC%[7m"
set "C_HIDDEN=%ESC%[8m"

rem --- Check ANSI support (Windows 10+) ---
ver | findstr /R /C:"10\." >nul
if %errorlevel%==0 (
    set "ANSI_SUPPORT=1"
) else (
    set "ANSI_SUPPORT=0"
)

if "%ANSI_SUPPORT%"=="0" (
    rem Fallback: disable all color codes
    for /F "delims=" %%v in ('set C_ 2^>nul') do set "%%v="
)

rem --- Initialise console ---
title %RK_NAME% v%RK_VERSION%
mode con: cols=%CONSOLE_WIDTH% lines=%CONSOLE_HEIGHT%
color 08

rem ==============================================
rem  COMPONENT CHECK (improved)
rem ==============================================
set "MISSING_FILES="
if not exist "%HWID%" set "MISSING_FILES=!MISSING_FILES!  - %HWID%\n"
if not exist "%STATUS%" set "MISSING_FILES=!MISSING_FILES!  - %STATUS%\n"

if defined MISSING_FILES (
    cls
    color 4F
    echo.
    echo  %C_BRIGHT_RED%%C_BOLD%  ERROR:%C_RESET% Required components missing!
    echo.
    echo  %C_BRIGHT_WHITE%The following files could not be found:%C_RESET%
    echo.
    echo  %C_BRIGHT_YELLOW%!MISSING_FILES!%C_RESET%
    echo.
    echo  %C_BRIGHT_BLACK%Please ensure the RK toolkit is extracted with its folder structure intact.%C_RESET%
    echo.
    pause
    exit /b 1
)

rem ==============================================
rem  BOOT SEQUENCE
rem ==============================================
call :bootAnimation

rem ==============================================
rem  MAIN MENU LOOP
rem ==============================================
:home
call :drawMenu
choice /C 120 /N >nul
set "pick=%errorlevel%"
if "%pick%"=="3" call :exitSequence & exit /b 0
if "%pick%"=="2" call :runStatus & goto home
if "%pick%"=="1" call :runHWID & goto home
goto home

rem ==============================================
rem  SUBROUTINES
rem ==============================================

rem --- Boot animation with logo and loading bar ---
:bootAnimation
    cls
    setlocal EnableDelayedExpansion
    goto :safe_logo
    rem --- Logo (ASCII art) - dark red and grey ---
    echo.
    echo %C_BRIGHT_RED%   ____  _  __    ____                           __ __                   
    echo %C_BRIGHT_RED%  / __ \^| ^|/ /   / __ \____  ____  ____  __  __/ // /__  _______  ____   
    echo %C_BRIGHT_RED% / /_/ /   /   / /_/ / __ \/ __ \/ __ \/ / / / // / _ \/ ___/ _ \/ __ \  
        echo %C_BRIGHT_RED% / _, _/   ^|   / _, _/ /_/ / /_/ / /_/ / /_/ / /_/ / /_/ / // /  __/ /  /  __/ / / /  
    echo %C_BRIGHT_RED%/_/ |_/_/|_|  /_/ |_|\____/\____/\____/\__, /_//_/\___/_/   \___/_/ /_/   
    echo %C_BRIGHT_RED%                                      /____/                                
    echo.
:safe_logo
    echo %C_BRIGHT_RED%   R K   -   R O O T   K E R N E L
    echo %C_BRIGHT_WHITE%   R O O T   K E R N E L   ::   C O N S O L E
    echo %C_BRIGHT_WHITE%   Windows Activation Toolkit   %C_BRIGHT_BLACK%^|%C_RESET%   v%RK_VERSION%
    echo %C_BRIGHT_BLACK%   Developed by %RK_AUTHOR%
    echo.
    echo %C_BRIGHT_BLACK%   Ready.%C_RESET%
    endlocal
    goto :EOF

rem --- Draw the main menu with fancy borders ---
:drawMenu
    cls
    setlocal EnableDelayedExpansion
    rem --- RK command dashboard ---
    echo %C_BRIGHT_RED%================================================================================%C_RESET%
    echo %C_BRIGHT_RED%                         R K   -   R O O T   K E R N E L%C_RESET%
    echo %C_BRIGHT_WHITE%                    WINDOWS ACTIVATION COMMAND CENTER%C_RESET%
    echo %C_BRIGHT_BLACK%                              DEV TEJ  /  v%RK_VERSION%%C_RESET%
    echo %C_BRIGHT_RED%================================================================================%C_RESET%
    echo.
    echo %C_BRIGHT_RED%  AVAILABLE COMMANDS%C_RESET%                         %C_BRIGHT_BLACK%READY%C_RESET%
    echo %C_BRIGHT_BLACK%  --------------------------------------------------------------------------------%C_RESET%
    echo %C_BRIGHT_RED%  [1]%C_RESET%  %C_BRIGHT_WHITE%%C_BOLD%HWID ACTIVATION%C_RESET%       %C_BRIGHT_BLACK%Permanent Windows activation%C_RESET%
    echo %C_BRIGHT_RED%  [2]%C_RESET%  %C_BRIGHT_WHITE%%C_BOLD%ACTIVATION STATUS%C_RESET%     %C_BRIGHT_BLACK%Check the current Windows license%C_RESET%
    echo.
    echo %C_BRIGHT_RED%  SESSION%C_RESET%
    echo %C_BRIGHT_BLACK%  --------------------------------------------------------------------------------%C_RESET%
    echo %C_BRIGHT_RED%  [0]%C_RESET%  %C_BRIGHT_WHITE%%C_BOLD%EXIT CONSOLE%C_RESET%          %C_BRIGHT_BLACK%Close RK safely%C_RESET%
    echo.
    echo %C_BRIGHT_RED%================================================================================%C_RESET%
    echo.
    rem --- Prompt line ---
    <nul set /p "=%C_BRIGHT_RED%     RK : %C_RESET%%C_BRIGHT_WHITE%Select an option [1,2,0] : %C_RESET%%C_BRIGHT_RED%"
    endlocal
    goto :EOF

rem --- Run external HWID activation with loading animation ---
:runHWID
    cls
    echo %C_BRIGHT_RED%+------------------------------------------------------------------------------+%C_RESET%
    echo %C_BRIGHT_RED%^|%C_RESET%  %C_BRIGHT_WHITE%Launching HWID Activation...%C_RESET%                                             %C_BRIGHT_RED%^|%C_RESET%
    echo %C_BRIGHT_RED%+------------------------------------------------------------------------------+%C_RESET%
    echo.
    rem --- Spinner while preparing ---
    call :spinner 1.5
    cls
    rem --- Actual external script ---
    call "%HWID%"
    echo.
    echo %C_BRIGHT_GREEN%Activation process completed.%C_RESET%
    pause
    goto :EOF

rem --- Run external Status check with loading animation ---
:runStatus
    cls
    echo %C_BRIGHT_RED%+------------------------------------------------------------------------------+%C_RESET%
    echo %C_BRIGHT_RED%^|%C_RESET%  %C_BRIGHT_WHITE%Checking Activation Status...%C_RESET%                                         %C_BRIGHT_RED%^|%C_RESET%
    echo %C_BRIGHT_RED%+------------------------------------------------------------------------------+%C_RESET%
    echo.
    call :spinner 1.5
    cls
    call "%STATUS%"
    echo.
    echo %C_BRIGHT_GREEN%Status check completed.%C_RESET%
    pause
    goto :EOF

rem --- Exit sequence with animation ---
:exitSequence
    cls
    echo %C_BRIGHT_RED%Exiting RK Console...
    call :spinner 0.8
    echo %C_BRIGHT_GREEN%Goodbye!%C_RESET%
    timeout /t 1 /nobreak >nul
    goto :EOF

rem --- Simple spinner animation ---
:spinner
    setlocal EnableDelayedExpansion
    set "spinner_chars=|/-\"
    set "delay=%1"
    if not defined delay set "delay=1"
    set "end_time="
    for /L %%i in (1,1,20) do (
        for %%c in (^| ^/ ^- ^\) do (
            <nul set /p "=%C_BRIGHT_RED%[%%c]%C_RESET%"
            ping -n 1 -w 50 >nul
            <nul set /p "=%ESC%[3D"
        )
    )
    <nul set /p "=   "
    echo.
    endlocal
    goto :EOF

rem ==============================================
rem  END OF SCRIPT
rem ==============================================