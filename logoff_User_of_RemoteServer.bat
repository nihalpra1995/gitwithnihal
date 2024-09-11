@echo OFF
echo Enter the Username 
set /p i=
echo Enter the Servername
set /p s=
echo Checking on %s%...
for /f "tokens=3 skip=1" %%i in ('query session %i% /server:%s%') do set "sess=%%i"
if NOT [%sess%]==[] (
 echo Username:%i%; SessionId:%sess%;Servername:%s% 
 logoff %sess% /server:%s%
 echo Session Logoff Successfully
 echo Press any key to exit
 pause>nul
) else (
echo Press any key to exit
pause>nul
)