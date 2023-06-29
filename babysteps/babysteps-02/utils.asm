; utils.asm

%macro BiosPrint 1
   mov si, word %1
ch_loop:
  lodsb
  or al, al
  jz done
  mov ah, 0x0e
  mov bh, 0x0
  int 0x10
  jmp ch_loop

done:
  ret
%endmacro
