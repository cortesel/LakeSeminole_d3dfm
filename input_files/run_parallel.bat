@ echo off
rem Usage instructions for partitioned model (parallel computation)
rem  - Update the path to your Delft3D FM installation
rem  - Update the name of your mdu
rem  - Change the number of partitions
rem  - This script updates the settings in dimr_config.xml:
rem     - Name of mdu file (e.g. <inputFile>Vietnam.mdu</inputFile>)
rem     - One process per partitions counting upward from 0 (e.g. <process>0 1</process> for 2 partitions)

rem When using intelMPI for the first time on a machine:
rem Execute "hydra_service.exe -install" as administrator:
rem     Preparation: Check that your Delft3D installation contains "...\x64\bin\hydra_service.exe". Optionally copy it to a local directory (it will run as a service).
rem     "Windows Start button" -> type "cmd", right-click "Command Prompt" App, "Run as Administrator"
rem     In this command box:
rem         cd ...\x64\bin (or your local copy)
rem         hydra_service.exe -install
rem         mpiexec.exe -register -username <user> -password <password> -noprompt
rem     When there is an hydra_service/smpd already running on the machine, it must be ended first, using the Microsoft Task Manager,
rem     or in the command  box: hydra_service.exe -uninstall (smpd -uninstall)

rem User input
set D3D_folder="C:\Program Files\Deltares\Delft3D FM Suite 2025.01 HMWQ"
set WORK_dir=dflowfm
set MDU_file=FlowFM.mdu
set partitions=14
set dimr_config_file=dimr_config.xml

rem Generate the process string using a for loop, similar to seq in Linux
setlocal enabledelayedexpansion
set /A upperLimit=%partitions%-1
set PROCESSSTR=
for /L %%i in (0,1,%upperLimit%) do (
    set PROCESSSTR=!PROCESSSTR! %%i
)
rem Remove the leading space from PROCESSSTR
set PROCESSSTR=%PROCESSSTR:~1%

rem Use PowerShell to update the dimr_config.xml file with the MDU file and processes
rem powershell -Command "(Get-Content '%dimr_config_file%') -replace '<inputFile>.*<\/inputFile>', '<inputFile>%MDU_file%</inputFile>' | Set-Content '%dimr_config_file%'"
rem powershell -Command "(Get-Content '%dimr_config_file%') -replace '<workingDir>.*<\/workingDir>', '<workingDir>%WORK_dir%</workingDir>' | Set-Content '%dimr_config_file%'"
powershell -Command "(Get-Content '%dimr_config_file%') -replace '<process>.*<\/process>', '<process>%PROCESSSTR%</process>' | Set-Content '%dimr_config_file%'"

rem Partition the network and mdu
if not "%WORK_dir%" == "." (
    cd %WORK_dir%
)
call %D3D_folder%\plugins\DeltaShell.Dimr\kernels\x64\bin\run_dflowfm.bat "--partition:ndomains=%partitions%:icgsolver=6" %MDU_file%
if not "%WORK_dir%" == "." (
    cd ..
)

rem Execute the simulation
call %D3D_folder%\plugins\DeltaShell.Dimr\kernels\x64\bin\run_dimr_parallel.bat %partitions% %dimr_config_file%

rem To prevent the DOS box from disappearing immediately: enable pause on the following line
pause
