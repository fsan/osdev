; boot.asm
   ; sets the segment address of the boot sector by settings the ds register
   ; 0x07c0 is the value where the bios expects the data segment to be located
   ; the data segment contains, well, data (arrays, variables and data elements)
   ; for the data to be printed, it is necessary that the ds register points to the correct
   ; data segment address

   ; the reason for not writing 0x07c0 directly to ds is because it generates an invalid opcode
   ; mov to ds is only allowed in register mode. the immediate mode (directly value) is not accepted
   ; so the value has to be loaded to ax before loaded to ds register
   ; mov ax, 0x07c0      ; initial address for the data segment

   ; from babysteps-02:
   ; In real mode, addresses are calculated as segment * 16 + offset.
   ; Since offset can be much larger than 16, there are many pairs of segment and offset that point to the same address.
   ; For instance, some say that the bootloader is is loaded at 0000:7C00, while others say 07C0:0000. This is in fact the same address: 16 * 0x0000 + 0x7C00 = 16 * 0x07C0 + 0x0000 = 0x7C00. 

   ; the difference here for the directive ORG
   ; is that this approach considers the start of the segment with 0000 and the offset is 0x07c0
   ; with ORG, it is considered that the start ix 0x7c00 and the offset is zero
   ; ultimately, both ways end up pointing to the same address as explained above

   mov ax, 0x07c0      ; initial address for the data segment
   mov ds, ax          ; set the data segment
 
   mov si, msg         ; set source index with msg
   cld                 ; clear direction flag for reading the string

ch_loop:lodsb
   or al, al                   ; will goto hang if end of str ; zero=end of str (0x0 = 0x0)
   jz hang

   ; call interrupt x0x10h with 0x0e argument for printing
   ; ah register hold the instruction
   ; the ds register holds the address of the data segment
   ; si holds the msg
   mov ah, 0x0E
   mov bh, 0
   int 0x10

   ; go to the next iteration.
   ; as the direction flag (df) is clear, it will read the next character
   jmp ch_loop     
 
hang:
   jmp hang

; declare the msg label for the message
; "Hello world\r\n\0"
msg   db 'Hello World', 13, 10, 0    

; ($-$$) is the current address of in the binary - the start
; 510-($-$$) will repeat the byte 0x00 (declared by db 0) 510-size of code
; 0x55aa will help the bios identify this is bootable partition
times 510-($-$$) db 0
db 0x55
db 0xAA
