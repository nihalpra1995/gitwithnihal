@echo OFF
echo Enter the Username
set /p i=
for /f "tokens=3 skip=1" %%s in ('query session %i% /server:clus1') do set "sess=%%s"
if NOT [%sess%]==[] echo Username:%i%; SessionId:%sess%;Servername:Clus1 (logoff %sess% /server:clus1 echo Session Logoff Successfully)
pause