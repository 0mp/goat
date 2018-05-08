@echo off
set LINK=%1
set TARGET=%2

REM Convert POSIX paths to Windows paths
set LINK=%LINK:/=\%
set TARGET=%TARGET:/=\%

mklink /D %LINK% %TARGET% >NUL
REM mklink requires admin privileges, so it doesn't work in all cases
REM
REM Should we use directiory junctions (/J) instead of symlinks (/D)?
REM Junctions are more robust (e.g. when following symlinks over a
REM remote share), but symlinks seem to work in more cases
