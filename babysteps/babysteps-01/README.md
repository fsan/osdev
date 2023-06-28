# Babysteps - 01
https://wiki.osdev.org/Babystep1

* It required the version which has

```asm
hang:
    jmp hang
	times 510-($-$$) db 0
	db 0x55
	db 0xAA
```
 
checking with `xxd` it is possible to see that these commands add the  `0x55aa` to the end of the binary.


As far as I understood, the `db` directive will inject the bytes in the current position of the binary.

Consider the code:

```asm
;test.asm

db 0x46
db 0x41
db 0x42
```

assembled with
```bash
nasm test.asm -f bin -o test.bin
```

Then checked with
```bash
> xxd test.bin
# 00000000: 4641 42                                  FAB  
```

The `boot.bin` image will be
```
xxd boot.bin
# 00000000: ebfe 0000 <...> 0000 55aa
```

Where `eb` is the `jmp` instruction machine code.[reference](https://c9x.me/x86/html/file_module_x86_id_147.html)

Running bootloader on qemu
```bash
qemu-system-i386 -hda boot.bin
```

The command above is likely to return the warning saying that automatically assuming raw format is not safe, but if you want to do so you need to be explicity to get rid of the warning.
The way of doing that then is:

```bash
qemu-system-i386 -drive file=boot.bin,format=raw
```

Other references that seems useful but unused in the reference link for this tutorial:
- http://www.baldwin.cx/386htm/toc.htm
- https://www.plantation-productions.com/Webster/

