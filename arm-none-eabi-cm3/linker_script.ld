
ENTRY(Reset_Handler)		/* Информация для ELF-файла (отладчик/ОС) */

MEMORY {
    FLASH   (rx)    :   ORIGIN = 0x08000000, LENGTH = 64K
    RAM     (rwx)   :   ORIGIN = 0x20000000, LENGTH = 20K
}

_estack = ORIGIN(RAM) + LENGTH(RAM);

_sidata = LOADADDR(.data);

SECTIONS {
    .isr_vector : {
        . = ALIGN(4);
        KEEP(*(.isr_vector))
        . = ALIGN(4);
    } > FLASH

    .text : {
        . = ALIGN(4);
        _stext = .;
        *(.text)
        *(.text*)
        . = ALIGN(4);
        _etext = .;
    } > FLASH

	.my_special_section 0x08000300 : {
        . = ALIGN(4);
		*(.my_special_section)
        . = ALIGN(4);
	} > FLASH

    .rodata : {
        . = ALIGN(4);
        _srodata = .;
        *(.rodata)
        *(.rodata*)
        . = ALIGN(4);
        _erodata = .;
    } > FLASH

    .data : {
        . = ALIGN(4);
        _sdata = .;
        *(.data)
        *(.data*)
        . = ALIGN(4);
        _edata = .;
    } > RAM AT > FLASH
    
    .bss : {
        . = ALIGN(4);
        _sbss = .;
        *(.bss)
        *(.bss*)
        *(COMMON)
        . = ALIGN(4);
        _ebss = .;
    } > RAM
}
