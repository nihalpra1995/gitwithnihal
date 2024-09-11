@echo OFF
echo Enter the Username 
set /p i=
echo Checking on CLUS1...
for /f "tokens=3 skip=1" %%s in ('query session %i% /server:clus1') do set "sess=%%s"
if NOT [%sess%]==[] (
 echo Username:%i%; SessionId:%sess%;Servername:Clus1 
 logoff %sess% /server:clus1
 if [%sess%]==[] ( 
 echo Session Logoff Successfully
 )
 echo Press any key to exit
 pause>nul
 exit
)
echo Checking on CLUS2...
for /f "tokens=3 skip=1" %%a in ('query session %i% /server:clus2') do set "ses=%%a"
if NOT [%ses%]==[] (
 echo Username:%i%; SessionId:%ses%;Servername:Clus2 
 logoff %ses% /server:clus2 
 echo Session Logoff Successfully
 echo Press any key to exit
 pause>nul
)
