; Tell NASM that this code will be loaded at address 0x7C00 in RAM.
; The BIOS copies the first 512 bytes from disk into RAM at this address,
; then jumps here. Without this, NASM would calculate all label addresses
; starting from 0x0000, and any jumps/references would point to wrong places.
ORG 0x7C00

; The CPU starts in 16-bit real mode after power-on.
; This tells NASM to generate 16-bit machine code to match.
; This is purely an assembler directive — the CPU never sees it.
BITS 16

main:
    ; Stop the CPU until an interrupt arrives (timer tick, keyboard, etc.)
    HLT

halt:
    ; HLT only sleeps until the next interrupt, then execution continues.
    ; This infinite loop catches the CPU after it wakes up and keeps it stuck.
    JMP halt

; Pad the rest of the boot sector with zeroes up to byte 510.
; A boot sector must be exactly 512 bytes. $ = current position, $$ = start,
; so ($-$$) = bytes written so far. This fills the gap with zeroes.
TIMES 510-($-$$) DB 0

; Boot signature. The BIOS checks bytes 511-512 for 0x55 0xAA.
; If found, it treats this sector as bootable. DW 0AA55h writes 55 AA
; in memory (little-endian: least significant byte first).
DW 0AA55h
