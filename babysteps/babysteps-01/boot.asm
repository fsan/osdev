;boot.asm
;    cli	; clear interrupt flags
 hang:
     jmp hang
 
     times 510-($-$$) db 0
     db 0x55
     db 0xAA
