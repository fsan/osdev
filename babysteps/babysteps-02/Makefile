.PHONY: all run clean

NASM = nasm
NASM_FLAGS = -f bin
OUTPUT = boot.bin

all: $(OUTPUT) run

# build boot.bin from boot.asm
$(OUTPUT): boot.asm
	$(NASM) $(NASM_FLAGS) -o $@ $<

run: boot.bin
	qemu-system-i386 -drive file=$<,format=raw

clean:
	rm -fv $(OUTPUT)

