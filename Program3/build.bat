@echo off
cls

set EXE_NAME=interpolate
del %EXE_NAME%.exe
del %EXE_NAME%.obj
del %EXE_NAME%.lst
del %EXE_NAME%.ilk
del %EXE_NAME%.pdb

set DRIVE_LETTER=%1:
set PATH=%DRIVE_LETTER%\Assembly\bin;c:\Windows;c:\Windows\system32
set INCLUDE=%DRIVE_LETTER%\Assembly\include
set LIB_DIRS=%DRIVE_LETTER%\Assembly\lib
set LIBS=sqrt.obj interpolate_sort.obj atofproc.obj ftoaproc.obj compare_floats.obj

ml -Zi -c -coff -Fl %EXE_NAME%_driver.asm
ml -Zi -c -coff -Fl compute_b.asm
ml -Zi -c -coff -Fl interpolate.asm
link /libpath:%LIB_DIRS% %EXE_NAME%_driver.obj compute_b.obj interpolate.obj %LIBS% io.obj kernel32.lib /debug /out:%EXE_NAME%.exe /subsystem:console /entry:start
%EXE_NAME% <points_2.txt

