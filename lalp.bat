@echo off
if "%OS%" == "Windows_NT" goto :winnt

:win9x
	if not "%LALP_HOME%" == "" goto vars_set_LALP

	echo Windows 9x/ME detected. Aborting because the
	echo the LALP_HOME variable is not set.
	goto :eof

:winnt
	setlocal
	if not "%LALP_HOME%" == "" goto vars_set_LALP

	call :winnt_normalize LALP_BIN "%~dp0\."
	call :winnt_normalize LALP_HOME "%~dp0\.."
	goto :vars_ready

:winnt_normalize
	set "%1=%~f2"
	goto :eof

:vars_set_LALP
	set LALP_BIN=%LALP_HOME%\bin

:vars_ready

set LALP_LIBS=%LALP_HOME%\WebContent\WEB-INF\lib

set LALP_JAR_JUNG=%LALP_LIBS%\jung-1.7.6.jar
set LALP_JAR_COLT=%LALP_LIBS%\colt.jar
set LALP_JAR_COMMONS_COLLECTIONS=%LALP_LIBS%\commons-collections-3.2.jar

set SEP=;

set LALP_CP_TOOL=%LALP_JAR_JUNG%%SEP%%LALP_JAR_COLT%%SEP%%LALP_JAR_COMMONS_COLLECTIONS%%SEP%%LALP_HOME%\bin

java -DLALP.home="%LALP_HOME%" -DCOMMAND_NAME="LALP" -Djava.library.path="%LALP_BIN%" -classpath "%LALP_CP_TOOL%" lalp.LALP  %*
:eof
