.PHONY: all run clean

NASM = nasm
NASM_FLAGS = -f bin
OUTPUT = encode.bin

all: $(OUTPUT) run

# build encode.bin from encode.asm
$(OUTPUT): encode.asm
	$(NASM) $(NASM_FLAGS) -o $@ $<

run: encode.bin
	xxd -a $<

clean:
	rm -fv $(OUTPUT)

