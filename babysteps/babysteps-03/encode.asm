; encode.asm
[BITS 16]              ; when using nasm -f bin will default to BITS 16 
mov cx, 0x1111         ; b9 0x1111
db 0xff                ; 0xff
mov ecx, 0x2222        ; 66b9 0x22220000
db 0xff                ; 0xff
mov cx, 0x12345678     ; 0xb97856 (-w+number-overflow)
db 0xff                ; 0xff
