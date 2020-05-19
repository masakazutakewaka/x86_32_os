BOOT_LOAD equ 0x07C00                  ; load address of boot program
BOOT_SIZE equ (1024 * 8)              ; size of boot code(byte)
SECT_SIZE equ (512)                   ; size of sector; 1 sector = 512bytes = 4096bits
BOOT_SECT equ (BOOT_SIZE / SECT_SIZE) ; number of sectors for boot program

E820_RECORD_SIZE equ 20               ; size of space for memory info fetched by BIOS/get_mem_info
