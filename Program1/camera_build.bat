@echo off
cls

set DRIVE_LETTER=%1:
set ASSEMBLER_DIR=%DRIVE_LETTER%\Assembly
set PATH=%ASSEMBLER_DIR%\bin;c:\Windows;c:\Windows\system32

set INCLUDE=%ASSEMBLER_DIR%\include
set LIB_DIRS=%ASSEMBLER_DIR%\lib
set LIBS=io.obj kernel32.lib sqrt.obj

ml -Zi -c -coff -Fl camera.asm
link /libpath:%LIB_DIRS% camera.obj %LIBS% /debug /out:camera.exe /subsystem:console /entry:start
camera <camera_input.txt

