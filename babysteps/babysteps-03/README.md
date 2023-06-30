# Babysteps - 03

https://wiki.osdev.org/Babystep3

## A look at machine code (opcodes, prefix, etc) 

```assembly
; encode.asm
mov cx, 0xFF
times 510-($-$$) db 0
db 0x55
db 0xAA
```

compile this with
```bash
nasm encode.asm -f bin -o encode.bin
```

and open it with any hex viewer. For linux, there is `xxd`

```bash
$ xxd -a encode.bin

00000000: b9ff 0000 0000 0000 0000 0000 0000 0000  ................
00000010: 0000 0000 0000 0000 0000 0000 0000 0000  ................
*
000001f0: 0000 0000 0000 0000 0000 0000 0000 55aa  ..............U.
```

The opcode (operation code) for mov can be 0xB9 (or 0xB8)
It is possible to check it in the manual of opcodes for [80386 instruction set](http://www.baldwin.cx/386htm/MOV.htm).
A more complete reference table can be found [here](http://ref.x86asm.net/coder32.html#xB8).

According to [this lecture](https://www.cs.uaf.edu/2016/fall/cs301/lecture/09_28_machinecode.html) in machine code, the MOV can assume differnet opcodes depending which register is being accessed.

```
   0:	b8 05 00 00 00       	mov    eax,0x5
   5:	b9 05 00 00 00       	mov    ecx,0x5
   a:	ba 05 00 00 00       	mov    edx,0x5
```

The  ordering of register is a bit bizarre in 386 arch.

|             | Number | 0    | 1    | 2    | 3    | 4    | 5    | 6    | 7    |
|-------------|--------|------|------|------|------|------|------|------|------|
| Int Register|        | eax  | ecx  | edx  | ebx  | esp  | ebp  | esi  | edi  |

Using ECX instead:

```assembly
mov ecx, 0xFF
```

```
00000000: 66b9 ff00 0000 0000 0000 0000 0000 0000  f...............
00000010: 0000 0000 0000 0000 0000 0000 0000 0000  ................
*
000001f0: 0000 0000 0000 0000 0000 0000 0000 55aa  ..............U.
```

The prefix [0x66](http://ref.x86asm.net/coder32.html#x66) indicates `Operand-size override prefix` when there is a discrepancy with the default mode, which when NASM assembles binary files. 

If  the `BITS 32` directive is set the opcode 66 is unecessary.

```assembly
[BITS 32]
mov ecx, 0x12345678
```

```
00000000: b978 5634 1200 0000 0000 0000 0000 0000  .xV4............
00000010: 0000 0000 0000 0000 0000 0000 0000 0000  ................
*
000001f0: 0000 0000 0000 0000 0000 0000 0000 55aa  ..............U.
```

Note that using the `BITS 16` (or no directive at all) will result (with the code above) in the addition of the opcode 66.

```assembly
[BITS 16]
mov ecx, 0x12345678
```

```
00000000: b978 5600 0000 0000 0000 0000 0000 0000  .xV.............
00000010: 0000 0000 0000 0000 0000 0000 0000 0000  ................
*
000001f0: 0000 0000 0000 0000 0000 0000 0000 55aa  ..............U.
```

And, of course, trying to use CX (instead of ECX) will result in a number-overflow warning as CX can have only half of the capacity of the ECX. (CX is 16-bit and ECX is 32-bit)


### CL/CH x CX x ECX (and others)
In the 386 architecture, ECX and CX refer to different registers with different sizes:

- ECX: It is a 32-bit register and stands for "Extended Counter Register." ECX is one of the general-purpose registers available in the x86 architecture. It is commonly used for loop control and counting operations.

- CX: It is a 16-bit register and stands for "Counter Register." CX is the lower 16 bits of the ECX register. It can be used for operations that require a smaller data size, such as storing 16-bit values or performing calculations on 16-bit operands.

- CL: It is a 8-bit register lower part of CX.
- CH: It is a 8-bit register upper part of CX.

There are counterparts for AX and DX using the same logic.

The registers available in the x86 architecture are generally prefixed with specific letters indicating their purpose or function, such as E (Extended), R (General Purpose), or S (Segment). However, there is no standard prefix of Z or EZ used to designate registers.


## Other references
(In references folder)
- https://nju-projectn.github.io/i386-manual/s17_02.htm
- https://zsmith.co/intel.php
- https://pdos.csail.mit.edu/6.828/2014/readings/i386.pdf

## Building

```bash
make
```
Note: will intentionally produce a `-w+number-overflow` message

## Some questions I have
Is OPCODE 66H equivalent to a NOOP (like 90H)?
