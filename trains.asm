;===============================================================================
;-------------------------------------------------------------------------------
;===============================================================================
;-------------------------------------------------------------------------------

		.65C02
		
		.include "sb-6502.inc"
		.include "ascii.inc"
		
;===============================================================================
;-------------------------------------------------------------------------------

TTY_COLS	.equ	80
TTY_ROWS	.equ	24

;-------------------------------------------------------------------------------

LOGOHEIGHT    	.equ	 6
LOGOFUNNEL  	.equ	 4
LOGOLENGTH      .equ	84
LOGOPATTERNS	.equ	 6

C51HEIGHT 	.equ	11
C51FUNNEL	.equ	 7
C51LENGTH 	.equ	87
C51PATTERNS 	.equ	 6

D51HEIGHT	.equ	10
D51FUNNEL	.equ	 7
D51LENGTH	.equ	83
D51PATTERNS	.equ	 6

;===============================================================================
;-------------------------------------------------------------------------------

		.page0
		.org	$00
		
TRAIN		.space	1			; Train type 0, 1 or 2
FLY		.space	1
ACCIDENT	.space	1
		
XBASE		.space	1
YBASE		.space	1

DY		.space	1

XPOS		.space	1
YPOS		.space	1

PTR		.space	2			; String pointer		
		
;===============================================================================
;-------------------------------------------------------------------------------
	
		.code
		.org	$300
		
		cld
		ldx	#$ff
		txs
		
		jsr	Hide
		repeat
		 jsr	Clear
		
		 lda	#TTY_COLS-1
		 sta	XBASE
		 repeat
		
		
		  jsr	DrawC51
		  break cs
		
		
		  dec 	XBASE
		 forever
		 
		forever
		
		ldx	#TTY_COLS-1
		ldy	#TTY_ROWS-1
		jsr	MoveTo
		jsr	Show
		
		brk
		
		
;-------------------------------------------------------------------------------


DrawC51:
		lda	XBASE			; Reach end of animation?
		cmp	#-C51LENGTH-1
		if eq
		 sec				; Yes
		 rts
		endif
		
		lda	#TTY_ROWS/2-5
		sta	YBASE
		stz	DY
		
		lda	FLY
		if ne
		endif
		
		ldx	XBASE
		ldy	YBASE
		
		lda	#<C51STR1
		sta	PTR+0
		lda	#>C51STR1
		sta	PTR+1
		jsr	Display
		
		phx
		clc
		txa
		adc	#55
		tax
		
		lda	#<COALDEL
		sta	PTR+0
		lda	#>COALDEL
		sta	PTR+1
		jsr	Display
		
		plx
		iny
		
		lda	#<C51STR2
		sta	PTR+0
		lda	#>C51STR2
		sta	PTR+1
		jsr	Display

		phx
		clc
		txa
		adc	#55
		tax
		
		lda	#<COAL01
		sta	PTR+0
		lda	#>COAL01
		sta	PTR+1
		jsr	Display
		
		plx
		iny
		
		lda	#<C51STR3
		sta	PTR+0
		lda	#>C51STR3
		sta	PTR+1
		jsr	Display
		
		phx
		clc
		txa
		adc	#55
		tax
		
		lda	#<COAL02
		sta	PTR+0
		lda	#>COAL02
		sta	PTR+1
		jsr	Display
		
		plx
		iny
		
		lda	#<C51STR4
		sta	PTR+0
		lda	#>C51STR4
		sta	PTR+1
		jsr	Display

		phx
		clc
		txa
		adc	#55
		tax
		
		lda	#<COAL03
		sta	PTR+0
		lda	#>COAL03
		sta	PTR+1
		jsr	Display
		
		plx
		iny
		
		lda	#<C51STR5
		sta	PTR+0
		lda	#>C51STR5
		sta	PTR+1
		jsr	Display

		phx
		clc
		txa
		adc	#55
		tax
		
		lda	#<COAL04
		sta	PTR+0
		lda	#>COAL04
		sta	PTR+1
		jsr	Display
		
		plx
		iny
		
		lda	#<C51STR6
		sta	PTR+0
		lda	#>C51STR6
		sta	PTR+1
		jsr	Display

		phx
		clc
		txa
		adc	#55
		tax
		
		lda	#<COAL05
		sta	PTR+0
		lda	#>COAL05
		sta	PTR+1
		jsr	Display
		
		plx
		iny
		
		lda	#<C51STR7
		sta	PTR+0
		lda	#>C51STR7
		sta	PTR+1
		jsr	Display

		phx
		clc
		txa
		adc	#55
		tax
		
		lda	#<COAL06
		sta	PTR+0
		lda	#>COAL06
		sta	PTR+1
		jsr	Display
		
		plx
		iny
		
		clc
		lda	XBASE
		adc	#C51LENGTH
		repeat
		 cmp	#C51PATTERNS
		 break cc
		 sbc	#C51PATTERNS
		forever

		 
		
		
		
		lda	ACCIDENT
		if ne
		endif
		
		jsr	DrawSmoke
		clc
		rts

;-------------------------------------------------------------------------------

DrawSmoke:
		rts

;-------------------------------------------------------------------------------

Display:
		phx
		phy
		
		repeat				; Skip leading characters
		 txa				; .. if off screen
		 break pl
		 lda 	(PTR)
		 beq	.Quit
		 inx
		 inc	PTR+0
		 if eq
		  inc	PTR+1
		 endif
		forever
		
		jsr	MoveTo			; Position the cursor
		
		repeat
		 lda	(PTR)
		 beq	.Quit
		 cpx	#TTY_COLS
		 bcs	.Quit
		 jsr	UARTTX
		 inx
		 inc	PTR+0
		 if eq
		  inc	PTR+1
		 endif		 
		forever
		
.Quit:		ply
		plx
		rts

;===============================================================================
; VT100 Terminal API
;-------------------------------------------------------------------------------

; Clear the entire screen.

Clear:
		jsr	Home
		jsr	Command
		lda	#'2'
		jsr	UARTTX
		lda	#'J'
		jmp	UARTTX

; Move the cursor to the home position.
	
Home:
		ldx	#0
		ldy	#0

; Move the cursor to (x,y) where both are zero based.

MoveTo:
		jsr	Command
		tya
		inc	a
		jsr	Number
		lda	#';'
		jsr	UARTTX
		txa
		inc	a
		jsr	Number
		lda	#'H'
		jmp	UARTTX
		
; Hide cursor

Hide:
		rts
		
; Show cursor
		
Show:
		rts

; Send a command start sequence.

Command:
		lda	#ESC			; Send ESC
		jsr	UARTTX
		lda	#'['			; .. and [
		jmp	UARTTX
		
; Convert the number in A (0-99) decimal and send it to the UART.

Number:
		phx				; Save callers X
		ldx	#0			; .. and initialise tens
		repeat
		 cmp	#10			; Divide by 10 thru repeated
		 break	cc			; .. subtraction
		 sbc	#10
		 inx
		forever
		pha				; Save units
		txa				; Convert the tens if not zero
		if ne
		 jsr	ToDigit		
		endif
		pla				; Then recover and send units
		jsr	ToDigit
		plx
		rts
		
ToDigit:	ora	#'0'			
		jmp	UARTTX

;===============================================================================
; Train Data
;-------------------------------------------------------------------------------


D51STR1:	.byte	"      ====        ________                ___________ ",0
D51STR2:	.byte	"  _D _|  |_______/        \\__I_I_____===__|_________| ",0
D51STR3:	.byte	"   |(_)---  |   H\\________/ |   |        =|___ ___|   ",0
D51STR4:	.byte	"   /     |  |   H  |  |     |   |         ||_| |_||   ",0
D51STR5:	.byte	"  |      |  |   H  |__--------------------| [___] |   ",0
D51STR6:	.byte	"  | ________|___H__/__|_____/[][]~\\_______|       |   ",0
D51STR7:	.byte	"  |/ |   |-----------I_____I [][] []  D   |=======|__ ",0

D51WHL11:	.byte	"__/ =| o |=-~~\\  /~~\\  /~~\\  /~~\\ ____Y___________|__ ",0
D51WHL12:	.byte	" |/-=|___|=    ||    ||    ||    |_____/~\\___/        ",0
D51WHL13:	.byte	"  \\_/      \\O=====O=====O=====O_/      \\_/            ",0

D51WHL21:	.byte	"__/ =| o |=-~~\\  /~~\\  /~~\\  /~~\\ ____Y___________|__ ",0
D51WHL22:	.byte	" |/-=|___|=O=====O=====O=====O   |_____/~\\___/        ",0
D51WHL23:	.byte	"  \\_/      \\__/  \\__/  \\__/  \\__/      \\_/            ",0

D51WHL31:	.byte	"__/ =| o |=-O=====O=====O=====O \\ ____Y___________|__ ",0
D51WHL32:	.byte	" |/-=|___|=    ||    ||    ||    |_____/~\\___/        ",0
D51WHL33:	.byte	"  \\_/      \\__/  \\__/  \\__/  \\__/      \\_/            ",0

D51WHL41:	.byte	"__/ =| o |=-~O=====O=====O=====O\\ ____Y___________|__ ",0
D51WHL42:	.byte	" |/-=|___|=    ||    ||    ||    |_____/~\\___/        ",0
D51WHL43:	.byte	"  \\_/      \\__/  \\__/  \\__/  \\__/      \\_/            ",0

D51WHL51:	.byte	"__/ =| o |=-~~\\  /~~\\  /~~\\  /~~\\ ____Y___________|__ ",0
D51WHL52:	.byte	" |/-=|___|=   O=====O=====O=====O|_____/~\\___/        ",0
D51WHL53:	.byte	"  \\_/      \\__/  \\__/  \\__/  \\__/      \\_/            ",0

D51WHL61:	.byte	"__/ =| o |=-~~\\  /~~\\  /~~\\  /~~\\ ____Y___________|__ ",0
D51WHL62:	.byte	" |/-=|___|=    ||    ||    ||    |_____/~\\___/        ",0
D51WHL63:	.byte	"  \\_/      \\_O=====O=====O=====O/      \\_/            ",0

D51DEL:		.byte	"                                                      ",0

COAL01:		.byte	"                              ",0
COAL02:		.byte	"                              ",0
COAL03:		.byte	"    _________________         ",0
COAL04:		.byte	"   _|                \\_____A  ",0
COAL05:		.byte	" =|                        |  ",0
COAL06:		.byte	" -|                        |  ",0
COAL07:		.byte	"__|________________________|_ ",0
COAL08:		.byte	"|__________________________|_ ",0
COAL09:		.byte	"   |_D__D__D_|  |_D__D__D_|   ",0
COAL10:		.byte	"    \\_/   \\_/    \\_/   \\_/    ",0

COALDEL:	.byte	"                              ",0

LOGO1:		.byte	"     ++      +------ ",0
LOGO2:		.byte	"     ||      |+-+ |  ",0
LOGO3:		.byte	"   /---------|| | |  ",0
LOGO4:		.byte	"  + ========  +-+ |  ",0

LWHL11:		.byte	" _|--O========O~\\-+  ",0
LWHL12:		.byte	"//// \\_/      \\_/    ",0

LWHL21:		.byte	" _|--/O========O\\-+  ",0
LWHL22:		.byte	"//// \\_/      \\_/    ",0

LWHL31:		.byte	" _|--/~O========O-+  ",0
LWHL32:		.byte	"//// \\_/      \\_/    ",0

LWHL41:		.byte	" _|--/~\\------/~\\-+  ",0
LWHL42:		.byte	"//// \\_O========O    ",0

LWHL51:		.byte	" _|--/~\\------/~\\-+  ",0
LWHL52:		.byte	"//// \\O========O/    ",0

LWHL61:		.byte	" _|--/~\\------/~\\-+  ",0
LWHL62:		.byte	"//// O========O_/    ",0

LCOAL1:		.byte	"____                 ",0
LCOAL2:		.byte	"|   \\@@@@@@@@@@@     ",0
LCOAL3:		.byte	"|    \\@@@@@@@@@@@@@_ ",0
LCOAL4:		.byte	"|                  | ",0
LCOAL5:		.byte	"|__________________| ",0
LCOAL6:		.byte	"   (O)       (O)     ",0

LCAR1:		.byte	"____________________ ",0
LCAR2:		.byte	"|  ___ ___ ___ ___ | ",0
LCAR3:		.byte	"|  |_| |_| |_| |_| | ",0
LCAR4:		.byte	"|__________________| ",0
LCAR5:		.byte	"|__________________| ",0
LCAR6:		.byte	"   (O)        (O)    ",0

DELLN:		.byte	"                     ",0

C51DEL:		.byte	"                                                       ",0

C51STR1:	.byte	"        ___                                            ",0
C51STR2:	.byte	"       _|_|_  _     __       __             ___________",0
C51STR3:	.byte	"    D__/   \\_(_)___|  |__H__|  |_____I_Ii_()|_________|",0
C51STR4:	.byte	"     | `---'   |:: `--'  H  `--'         |  |___ ___|  ",0
C51STR5:	.byte	"    +|~~~~~~~~++::~~~~~~~H~~+=====+~~~~~~|~~||_| |_||  ",0
C51STR6:	.byte	"    ||        | ::       H  +=====+      |  |::  ...|  ",0
C51STR7:	.byte	"|    | _______|_::-----------------[][]-----|       |  ",0

C51WH61:	.byte	"| /~~ ||   |-----/~~~~\\  /[I_____I][][] --|||_______|__",0
C51WH62:	.byte	"------'|oOo|==[]=-     ||      ||      |  ||=======_|__",0
C51WH63:	.byte	"/~\\____|___|/~\\_|   O=======O=======O  |__|+-/~\\_|     ",0
C51WH64:	.byte	"\\_/         \\_/  \\____/  \\____/  \\____/      \\_/       ",0

C51WH51:	.byte	"| /~~ ||   |-----/~~~~\\  /[I_____I][][] --|||_______|__",0
C51WH52:	.byte	"------'|oOo|===[]=-    ||      ||      |  ||=======_|__",0
C51WH53:	.byte	"/~\\____|___|/~\\_|    O=======O=======O |__|+-/~\\_|     ",0
C51WH54:	.byte	"\\_/         \\_/  \\____/  \\____/  \\____/      \\_/       ",0

C51WH41:	.byte	"| /~~ ||   |-----/~~~~\\  /[I_____I][][] --|||_______|__",0
C51WH42:	.byte	"------'|oOo|===[]=- O=======O=======O  |  ||=======_|__",0
C51WH43:	.byte	"/~\\____|___|/~\\_|      ||      ||      |__|+-/~\\_|     ",0
C51WH44:	.byte	"\\_/         \\_/  \\____/  \\____/  \\____/      \\_/       ",0

C51WH31:	.byte	"| /~~ ||   |-----/~~~~\\  /[I_____I][][] --|||_______|__",0
C51WH32:	.byte	"------'|oOo|==[]=- O=======O=======O   |  ||=======_|__",0
C51WH33:	.byte	"/~\\____|___|/~\\_|      ||      ||      |__|+-/~\\_|     ",0
C51WH34:	.byte	"\\_/         \\_/  \\____/  \\____/  \\____/      \\_/       ",0

C51WH21:	.byte	"| /~~ ||   |-----/~~~~\\  /[I_____I][][] --|||_______|__",0
C51WH22:	.byte	"------'|oOo|=[]=- O=======O=======O    |  ||=======_|__",0
C51WH23:	.byte	"/~\\____|___|/~\\_|      ||      ||      |__|+-/~\\_|     ",0
C51WH24:	.byte	"\\_/         \\_/  \\____/  \\____/  \\____/      \\_/       ",0

C51WH11:	.byte	"| /~~ ||   |-----/~~~~\\  /[I_____I][][] --|||_______|__",0
C51WH12:	.byte	"------'|oOo|=[]=-      ||      ||      |  ||=======_|__",0
C51WH13:	.byte	"/~\\____|___|/~\\_|  O=======O=======O   |__|+-/~\\_|     ",0
C51WH14:	.byte	"\\_/         \\_/  \\____/  \\____/  \\____/      \\_/       ",0

		.end
