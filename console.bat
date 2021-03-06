@echo off

rem /**
rem  * Console.bat v0.1.3
rem  * ------------------
rem  * Powered by Francesco Bianco <bianco@javanile.org>
rem  * Licensed with The GNU General Public License v3.0
rem  */

rem set current version
set CONSOLE_VER=0.1.3
set CONSOLE_BAT=%~dpf0
set CONSOLE_DIR=%~dp0
set CONSOLE_SRC=https://raw.githubusercontent.com/Javanile/Console.bat/master/console.bat
set CONSOLE_VAR=%~dp0\console.var

rem cmd.exe preloaded settings
if "%1" == "__init__" goto :__init__

rem update 
if "%1" == "update" goto :update

rem install 
if "%1" == "install" goto :install

rem include 
if "%1" == "include" goto :include

rem path 
if "%1" == "path" goto :path

rem clear 
if "%1" == "clear" goto :clear

rem home 
if "%1" == "home" goto :home

rem open 
if "%1" == "open" goto :cmdopen

rem cron
if "%1" == "cron" goto :cron

rem ls
if "%1" == "ls" goto :ls

rem rm
if "%1" == "rm" goto :rm

rem sync
if "%1" == "sync" goto :sync

rem wget
if "%1" == "wget" goto :wget

rem edit 
if "%1" == "edit" goto :edit

rem edit command
if "%1" == "--help" (
	echo.
	echo   Console.bat subcommands
	echo   -----------------------
	echo   console install ^<path^>    Install console.bat to ^<path^> and create shortcut
	echo   console update            Update console.bat to latest version
	echo   open ^<name^> ^[subname^]     Open project folder with name and subname
	echo   home                      Open root projects folder
	echo   cron list                 List console.bat user created cron
	echo.
	echo   Linux inspired commands
	echo   -----------------------
	echo   ls        List file on directory
	goto :eof
)

rem edit command
if "%1" == "--version" (
	echo.
	echo   Console.bat v%CONSOLE_VER%
	echo   ------------------
	echo   Powered by Francesco Bianco ^<bianco@javanile.org^>
	echo   Licensed with The GNU General Public License v3.0
	goto :eof
)

rem unknown subcommand 
if not [%1] == [] (
	echo.
	echo   Unknown subcommand: '%1'
	echo   Type 'console --help' for usage.
	goto :eof	
)

rem detect edit command
set CONSOLE_EDT=%ProgramFiles(x86)%\Notepad++\notepad++.exe

rem load environtment vars
if exist "%CONSOLE_VAR%" for /f "tokens=*" %%s in (%CONSOLE_VAR:)=^)%) do call :loadvar %%s

rem save old dos prompt
if [%PROMP0%] == [] set PROMP0=%PROMPT%

rem set new prompt
set PROMPT=#$S

rem enter in working dir
cd %CONSOLE_DIR%

rem launch indipend cmd.exe process
cmd.exe /k call "%CONSOLE_BAT%" __init__

rem restore dos prompt
set PROMPT=%PROMP0%

rem exit
goto :eof 

rem loadvar
:loadvar
echo %* | findstr = > nul 2> nul
if errorlevel 1 (
   set "PATH=%PATH%;%*"
) else (
   set "%*"
)
goto :eof

rem __init__
:__init__
cls
doskey console="%CONSOLE_BAT%" $*
doskey clear="%CONSOLE_BAT%" clear
doskey edit="%CONSOLE_BAT%" edit $1
doskey wget="%CONSOLE_BAT%" wget $1 $2
doskey open="%CONSOLE_BAT%" open $1 $2
doskey home="%CONSOLE_BAT%" home
doskey cron="%CONSOLE_BAT%" cron $1 $2 $3 $4
doskey sync="%CONSOLE_BAT%" sync $1 $2
doskey ls="%CONSOLE_BAT%" ls $1
doskey rm="%CONSOLE_BAT%" rm $1 $2 $3
color
goto :eof

rem install script
:install
if [%2] == [] goto :syntaxerror
if not exist %2 goto :nodirerror
set NOQUOTE0=%2
set NOQUOTE1=%NOQUOTE0:"=%
bitsadmin.exe /transfer "install" %CONSOLE_SRC% %2\console.bat > nul 2> nul 
echo set o = WScript.CreateObject("WScript.Shell"^).CreateShortcut("%HOMEDRIVE%%HOMEPATH%\Desktop\%~n2.lnk"^): o.TargetPath = "%NOQUOTE1%\console.bat": o.IconLocation = "cmd.exe": o.Save > %2\_.vbs
cscript %2\_.vbs > nul 2> nul 
del %2\_.vbs
attrib -a +h +s %2\console.bat
echo.
echo   Console.bat successfull installed!
echo   Double-click on desktop icon to open.
goto :eof

rem update
:update
bitsadmin.exe /transfer "update" %CONSOLE_SRC% %CONSOLE_BAT% > nul 2> nul
attrib -a +h +s %CONSOLE_BAT%
echo.
echo   Console.bat successfull updated!
echo   Type 'exit' or close and reopen.
goto :eof

rem include
:include
set sync=call %CONSOLE_BAT% sync
set console=call %CONSOLE_BAT%
goto :eof

rem clear
:clear
cls
goto :eof

rem home
:home
cd %CONSOLE_DIR%
echo.
echo   Opening root projects directory
echo   -------------------------------
echo   %CD%
goto :eof

rem open
:cmdopen
if [%2] == [] goto :syntaxerror
cd %CONSOLE_DIR%
for /d %%a in (%2*) do (
	cd %%a 
	goto :subopen
)
for /d %%a in (*) do (
	cd %%a
	for /d %%b in (%2*) do (
		cd %%b 
		goto :subopen
	)		
	cd ..
)
for /d %%a in (*) do (
	cd %%a
	for /d %%b in (*) do (
		cd %%b 
		for /d %%c in (%2*) do (
			cd %%c 
			goto :subopen
		)
		cd ..
	)		
	cd ..
)
for /d %%a in (*) do (
	cd %%a
	for /d %%b in (*) do (
		cd %%b 
		for /d %%c in (*) do (
			cd %%c 
			for /d %%d in (%2*) do (
				cd %%d 
				goto :subopen
			)
			cd ..
		)
		cd ..
	)		
	cd ..
)
echo.
echo   Project directory not found: '%2*\%3*'
goto :eof
:subopen
if not [%3] == [] (
	for /d %%a in (%3*) do (
		cd %%a 
		goto :open
	)	
	for /d %%a in (*) do (
		cd %%a 
		for /d %%b in (%3*) do (
			cd %%b 
			goto :open
		)	
		cd ..
	)	
	for /d %%a in (*) do (
		cd %%a 
		for /d %%b in (*) do (
			cd %%b 
			for /d %%c in (%3*) do (
				cd %%c 
				goto :open
			)
			cd ..
		)	
		cd ..
	)			
)	
:open
echo.
echo   Opening project directory
echo   -------------------------
echo   %CD%
goto :eof 

rem path
:path
set PATH=%PATH%;%2
echo.%2 >> %CONSOLE_VAR%	
attrib -a +h +s %CONSOLE_VAR%
goto :eof

rem ls
:ls
echo.
dir /w /o:gn %2 | findstr /c:"^[^ ]" /r
goto :eof

rem rm
:rm
if "%2" == "-fr" (
	erase /s /q /f %3 
	rmdir /s /q %3
	goto :eof
)
goto :syntaxerror

rem cron
:cron
if "%2" == "list" (
	echo.
	schtasks /query | findstr console.bat
	goto :eof
)
if "%2" == "every" (				
	schtasks /create /sc %3 /tr %~dpf4 /tn "console.bat %2 %3 %~n4"
	goto :eof
)
if "%2" == "weekly" (				
	schtasks /create /sc weekly /tr %~dpf3 /tn "console.bat %2 %~n3"
	goto :eof
)
if "%2" == "delete" (						
	schtasks /delete /tn "console.bat %3 %4 %5" /f 
	goto :eof
)	
goto :syntaxerror

rem sync
:sync
echo.
xcopy /c /d /e /h /i /r /y %2 %3
goto :eof

rem wget
:wget
bitsadmin.exe /transfer "wget" %2
goto :eof

rem edit
:edit
start /b "" "%CONSOLE_EDT%" %2
goto :eof

rem syntaxerror
:syntaxerror
echo.
echo   Syntax error: missing argument 
echo   Type 'console --help' for usage.
goto :eof 

rem nodirerror
:nodirerror
echo.
echo   Error "%2" not is a directory.
goto :eof
