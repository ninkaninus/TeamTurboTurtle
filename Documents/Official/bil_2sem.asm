	  ; Atmel Win32 AVR Disassembler v1.01
	  ;
         .cseg
         .org	0

          rjmp   avr002A      ; 0000 C029
          sbrs   ZH, 7        ; 0001 FFFF
          sbrs   ZH, 7        ; 0002 FFFF
          sbrs   ZH, 7        ; 0003 FFFF
          sbrs   ZH, 7        ; 0004 FFFF
          sbrs   ZH, 7        ; 0005 FFFF
          sbrs   ZH, 7        ; 0006 FFFF
          sbrs   ZH, 7        ; 0007 FFFF
          sbrs   ZH, 7        ; 0008 FFFF
          sbrs   ZH, 7        ; 0009 FFFF
          sbrs   ZH, 7        ; 000A FFFF
          sbrs   ZH, 7        ; 000B FFFF
          sbrs   ZH, 7        ; 000C FFFF
          sbrs   ZH, 7        ; 000D FFFF
          sbrs   ZH, 7        ; 000E FFFF
          sbrs   ZH, 7        ; 000F FFFF
          sbrs   ZH, 7        ; 0010 FFFF
          sbrs   ZH, 7        ; 0011 FFFF
          sbrs   ZH, 7        ; 0012 FFFF
          sbrs   ZH, 7        ; 0013 FFFF
          sbrs   ZH, 7        ; 0014 FFFF
          sbrs   ZH, 7        ; 0015 FFFF
          sbrs   ZH, 7        ; 0016 FFFF
          sbrs   ZH, 7        ; 0017 FFFF
          sbrs   ZH, 7        ; 0018 FFFF
          sbrs   ZH, 7        ; 0019 FFFF
          sbrs   ZH, 7        ; 001A FFFF
          sbrs   ZH, 7        ; 001B FFFF
          sbrs   ZH, 7        ; 001C FFFF
          sbrs   ZH, 7        ; 001D FFFF
          sbrs   ZH, 7        ; 001E FFFF
          sbrs   ZH, 7        ; 001F FFFF
          sbrs   ZH, 7        ; 0020 FFFF
          sbrs   ZH, 7        ; 0021 FFFF
          sbrs   ZH, 7        ; 0022 FFFF
          sbrs   ZH, 7        ; 0023 FFFF
          sbrs   ZH, 7        ; 0024 FFFF
          sbrs   ZH, 7        ; 0025 FFFF
          sbrs   ZH, 7        ; 0026 FFFF
          sbrs   ZH, 7        ; 0027 FFFF
          sbrs   ZH, 7        ; 0028 FFFF
          sbrs   ZH, 7        ; 0029 FFFF
		  
avr002A:  ldi    r16, 0x08    ; 002A E008
          out    SPH, r16     ; 002B BF0E
          ldi    r16, 0x5F    ; 002C E50F
          out    SPL, r16     ; 002D BF0D
          ldi    r16, 0x80    ; 002E E800
          sbi    DDRD, 7      ; 002F 9A8F
          cbi    PORTD, 7     ; 0030 9897
          ldi    r16, 0x50    ; 0031 E500
          out    ?0x23?, r16  ; 0032 BD03
          ldi    r16, 0x6A    ; 0033 E60A
          out    ICR1H, r16   ; 0034 BD05
          ldi    r17, 0x00    ; 0035 E010
          ldi    r16, 0xCF    ; 0036 EC0F
          out    UBRRH, r17   ; 0037 BD10
          out    UBRR, r16    ; 0038 B909
          sbi    USR, 1       ; 0039 9A59
          ldi    r16, 0x86    ; 003A E806
          out    UBRRH, r16   ; 003B BD00
          ldi    r16, 0x18    ; 003C E108
          out    UCR, r16     ; 003D B90A
          ldi    r16, 0x32    ; 003E E302
          out    UDR, r16     ; 003F B90C
		  
avr0040:  sbis   USR, 7       ; 0040 9B5F
          rjmp   avr0040      ; 0041 CFFE
          in     r16, UDR     ; 0042 B10C
          out    UDR, r16     ; 0043 B90C
          cpi    r16, 0x30    ; 0044 3300
           breq  avr004B      ; 0045 F029
          cpi    r16, 0x35    ; 0046 3305
           breq  avr004D      ; 0047 F029
          cpi    r16, 0x39    ; 0048 3309
           breq  avr004F      ; 0049 F029
          rjmp   avr0040      ; 004A CFF5
		  
avr004B:  ldi    r16, 0x00    ; 004B E000
          rjmp   avr0050      ; 004C C003
		  
avr004D:  ldi    r16, 0x7F    ; 004D E70F
          rjmp   avr0050      ; 004E C001
avr004F:  ldi    r16, 0xE5    ; 004F EE05

avr0050:  out    ?0x23?, r16  ; 0050 BD03
          rjmp   avr0040      ; 0051 CFEE
          rjmp   avr0040      ; 0052 CFED

         .exit