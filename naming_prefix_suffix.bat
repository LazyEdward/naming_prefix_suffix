@ECHO OFF
REM CHCP 65001

TITLE Rename with prefix or suffix

ECHO This program add prefix or suffix to all files of the folder.
ECHO Renamed content is saved in new sub directory 'Renamed'

ECHO -------------------------------------------------------------
ECHO:

SET prefix=""
SET suffix=""
SET dir="%~1"

:START
if %dir%=="" SET /p "dir=Press "Y" to exit, Enter directory to start replacing: "
IF %dir%==Y GOTO :END

CD /D %dir%

SET total=0

REM dir /a:-d-h-s - includes files which are non-directory, not hidden or system files
FOR /F %%f IN ('dir /a:-d-h-s ^| FIND "File(s)"') DO (
	IF %ERRORLEVEL% EQU 0 (
		SET /a total=%%f
	) ELSE (
		SET /a total=0
	)
)

IF %total% LEQ 0 (
	SET dir=""
	GOTO :START
)

ECHO %total% files found

SET /p "prefix=Enter prefix: "
SET /p "suffix=Enter suffix: "

if %prefix%=="" if %suffix%=="" (
	ECHO No action executed
	PAUSE
	GOTO :END
)

ECHO:
ECHO making %dir:"=%\Renamed
ECHO:
MD Renamed

SET renamed_dir=%dir:"=%
SET renamed_dir=%renamed_dir%\Renamed

:EXTRACTION
FOR /F "delims=" %%f IN ('dir /a:-d-h-s /b') DO CALL :RENAME_SUBROUTINE "%%f"
GOTO :RENAME_FINISHED

:RENAME_SUBROUTINE
SET name=%~n1
SET ext=%~x1

SET new_name=%name%

if NOT %prefix%=="" SET new_name=%prefix%%new_name%
if NOT %suffix%=="" SET new_name=%new_name%%suffix%

ECHO renaming %name%%ext% to %new_name%%ext%

SET "fromPath=%dir:"=%\%name%%ext%"
SET "toPath=%renamed_dir%\%new_name%%ext%"

REM hide output with NUL
COPY /y "%fromPath%" "%toPath%" 1>NUL
EXIT /B

:RENAME_FINISHED
ECHO:
ECHO rename all %total% files
ECHO:

SET dir=""
GOTO :START

:END