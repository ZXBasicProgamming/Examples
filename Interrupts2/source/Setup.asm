
;DEVICE ZXSPECTRUM128

; 128k BASIC Int routine, 48k by Adrian Brown, Updated for 128k/+2/+3 With help from BUSYSOFT
; and mangled together by David Saphier
; version 2 Now relocatable!! 
; If you use 128K mode keep below 49152, 48k mode is no problem

;
;  9999 = 39321    IMroutine  here for 34 bytes
;  39359 	   Start of Int setup for 27 bytes 
;  39387           plroutine
;  41005 - 48894   music data
;  48895 257 byes of #99

PT3PLAY 	EQU 39387
IM2TABLEADD 	EQU 39000
IM2Address	EQU 39321
START		EQU 39359


	OUTPUT START.bin

	ORG START
MAIN

; Setup the entry vector table with $99*256 / 39321

	LD HL, IM2TABLEADD
	LD DE, IM2TABLEADD+1
	LD BC, 256
	LD a, #99
	LD (hl), a
	LDIR

	CALL PT3PLAY
	
; set up IM point to IM2Table
	DI
	LD hl, IM2TABLEADD
	LD a,h
	LD i,a
	IM 2
	EI
	RET
mainend

	OUTPUT IM2Address.bin
;
	ORG IM2Address

IM2Routine:  

	PUSH af
	PUSH hl
	PUSH bc
	PUSH de
	PUSH ix
	PUSH iy
	EXX
	EX af, af'
	PUSH af
	PUSH hl
	PUSH bc
	PUSH de

	CALL PT3PLAY+5

	POP de
	POP bc
	POP hl
	POP af
	EX af, af'
	EXX
	POP iy
	POP ix
	POP de
	POP bc
	POP hl
	POP af
	JP 56
	ret
	NOP
	NOP
	NOP
; @ 33024 define 257 byte IM2table to contain pointer to $B000 / 45056
;	OUTPUT imtable.bin

;	ORG IM2TABLEADD

;IM2Table:
;	DEFS          257


    ;SAVETAP "snapshotname.TAP",MAIN
   ; SAVEBIN "ram7.bin",MAIN,MAIN+mainend