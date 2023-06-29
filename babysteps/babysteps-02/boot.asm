; boot.asm

jmp main
%include "utils.asm"   ; where the BiosPrint macro is defined

msg   db 'Hello World', 13, 10, 0    

main:
[ORG 0x7c00]
   xor ax, ax           ; makes ax 0
   mov ds, ax           ; puts 0 in ds
   cld                  ; clear direction flag for reading the string

   BiosPrint msg
hang:
   jmp hang

; fill up bios memory and set last bytes as executable
times 510-($-$$) db 0
db 0x55
db 0xAA
