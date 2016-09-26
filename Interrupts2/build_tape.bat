@echo off
REM David Saphier 2016 v1

rem SET IM2Address=39321
rem SET StartAdd=39359
rem SET PT3PLAY=39387
rem SET TUNE=41545
rem SET IM2TABLEADD=48895
rem SET TUNEF=N_STORY.pt3
rem SET M=0
rem SET OUTPUT=test1.tap
rem SET BASF=BASIC.BAS

SET BeginAddress=39321

SET IM2Address=%BeginAddress%
SET /a StartAdd=%BeginAddress%+38
SET /a PT3PLAY=%StartAdd%+28
SET /a TUNE=%PT3PLAY%+1617+541
SET IM2TABLEADD=48895
SET TUNEF=N_STORY.pt3
SET M=0
SET OUTPUT=IM2_VTMusic.tap
SET BASF=BASIC.BAS

REM SCRATCH
rem SET PT3PLAY=49152

Set ARG="%1"
IF EXIST %ARG% ( 
	SET TUNEF=%1
 )

@DEL %OUTPUT%

CLS
COLOR 06
echo Interrupt TAP creator v.1 By David Saphier 2016.
COLOR 07
echo ------------------------------------------------

REM GET High a low byte addresses of memory location to poke vtplayer.
for %%I in (%TUNEF%) do set tunefs=%%~zI
set /a length=%TUNE%+%tunefs%-%IM2Address%
set /a HB=%TUNE%/256
SET /a t1=%HB%*256
set /a LB=%TUNE%-%t1%
set /a endaddress=%IM2Address%+%length%
echo.
echo Start Address 				: %BeginAddress%
echo VT Player  				: %PT3PLAY%
echo Music file				: %TUNEF% (%tunefs% bytes)
echo Total code length			: %length% bytes (%BeginAddress% - %endaddress%)
echo LB/HB of Music in memory		: %LB%, %HB% (%TUNE%)
echo.

IF %M% == 1 (

	echo Multiload mode....
	echo creating %BASF%
	echo.
	echo 1 REM INFO>%BASF%
	echo 2 REM PT3 music loaded into %TUNE%>>%BASF%
	echo 3 REM 1. call %PT3PLAY% to init pt3 routine>>%BASF%
	echo 4 REM 2. call %StartAdd% to start the music>>%BASF%
	echo 9990 CLEAR %IM2Address%-1
	echo 9991 LOAD "" CODE %IM2Address%  : REM IM2 Routine>>%BASF%
	echo 9992 LOAD "" CODE %StartAdd% : REM Setup routine>>%BASF%
	echo 9993 LOAD "" CODE %PT3PLAY% : REM PT3 player>>%BASF%
	echo 9994 LOAD "" CODE %TUNE% : REM Tune date>>%BASF%
	echo 9995 POKE %PT3PLAY%+1,%LB%: POKE %PT3PLAY%+2,%HB%>>%BASF%
	echo 9996 REM RANDOMIZE USR %PT3PLAY% : REM init the vtplayer>>%BASF%
	echo 9997 RANDOMIZE USR %StartAdd% : STOP : REM initialise IM, start im_rout>>%BASF%
	echo 9998 SAVE "IM2" LINE 9999: SAVE "IMCODE" CODE %IM2Address%,%length% : REM initialise IM, start im_rout>>%BASF%
	echo 9999 LOAD "IMCODE" CODE %IM2Address%: GO TO 9997 : REM initialise IM, start im_rout>>%BASF%

	echo Creating TAP : %output%
	
	tools\BAS2TAP tools\%BASF% ..\%OUTPUT% >>LOG.log

	echo Adding BIN to TAPs...

	tools\bin2tap -append -o ..\%OUTPUT% IM2Address.bin -a %IM2Address% >>LOG.log
	tools\bin2tap -append -o ..\%OUTPUT% StartAdd.bin -a %START% >>LOG.log
	tools\bin2tap -append -o ..\%OUTPUT% vtplayer.bin -a %PT3PLAY% >>LOG.log
	tools\bin2tap -append -o ..\%OUTPUT% %TUNEF% -a %TUNE% >>LOG.log

	) else IF %M% == 0 (

	echo Single load mode : 
	echo Creating tools\%BASF%
	echo 1 REM INFO>tools\%BASF%
	echo 2 REM PT3 music loaded into %TUNE%>>tools\%BASF%
	echo 3 REM 1. call %StartAdd% to start routine>>tools\%BASF%
	echo 9990 CLEAR %IM2Address%-1 >>tools\%BASF%
	echo 9991 LOAD "" CODE %M2Address% >>tools\%BASF%
	echo 9995 POKE %PT3PLAY%+1,%LB%: POKE %PT3PLAY%+2,%HB% >>tools\%BASF%
	echo 9997 RANDOMIZE USR %StartAdd% : STOP >>tools\%BASF%
	echo 9998 SAVE "IM2" LINE 9999: SAVE "IMCODE" CODE %IM2Address%,%length% >>tools\%BASF%
	echo 9999 LOAD "IMCODE" CODE %IM2Address%: GO TO 9997 >>tools\%BASF%

	echo Creating TAP from %BASF%

	tools\BAS2TAP tools\%BASF% %OUTPUT% >>LOG.log

	echo Creating dummy file of 541 bytes >>LOG.log

	fsutil file createnew tools\dummy.bin 541 >>LOG.log

	echo Combining binaries... >>LOG.log

	copy /b tools\IM2Address.bin+tools\StartAdd.bin+tools\vtplayer.bin+tools\dummy.bin+%TUNEF% tools\output.bin >>LOG.log

	echo Creating TAP from binaries : %OUTPUT%

	tools\bin2tap -append -o %OUTPUT% tools\output.bin -a %IM2Address% >>LOG.log

	echo.
	echo LOAD "" CODE %IM2Address%
	echo POKE %PT3PLAY%+1,%LB%: POKE %PT3PLAY%+2,%HB%
	echo RANDOMIZE USR %StartAdd%
	echo.
	echo 9998 SAVE "IM2" LINE 9999: SAVE "IMCODE" CODE %IM2Address%,%length%
	echo 9999 LOAD "IMCODE" CODE %IM2Address%
	echo.

	REM 
	DEL tools\output.bin >>LOG.log
	DEL tools\dummy.bin >>LOG.log

	)

DEL tools\%BASF% >>LOG.log

IF NOT EXIST %OUTPUT% (
	echo No output created, check log )


Echo Finished...

call %output%

pause
echo.
exit /b