@echo off
@cls
@set path=c:\xampp\htdocs\master\harbour
@set include=c:\xampp\htdocs\master\harbour\include;c:\harbour\include

del ..\lib\mercury.hrb


@echo ========================
@echo Building Lib MVC Mercury
@echo ========================

harbour mercury.prg /n /w /gh

if errorlevel 1 goto error

copy mercury.hrb ..\lib\mercury.hrb
copy mercury.ch  ..\lib\mercury.ch

@echo .
@echo Copy mercury to soulbour project 
copy mercury.hrb c:\xampp\htdocs\master\soulbour\lib\mercury\mercury.hrb
copy mercury.ch c:\xampp\htdocs\master\soulbour\lib\mercury\mercury.ch




@echo .
@echo =========================
@echo Lib Mercury has builded !
@echo =========================

goto exit

:error 

@echo .
@echo *--- Error ---*
@echo .


:exit


pause






