# Обязательно указываем целевую систему
set(CMAKE_SYSTEM_NAME		Generic)
set(CMAKE_SYSTEM_PROCESSOR	arm)

# Путь к тулчейну (если он в PATH, можно оставить просто имя)
set(TOOLCHAIN_PREFIX	"arm-none-eabi-")
set(TOOLCHAIN_PATH		"PATH/TO/gcc-arm-none-eabi-10.3-2021.10/bin/")

# Указываем компиляторы
set(CMAKE_C_COMPILER	"${TOOLCHAIN_PATH}${TOOLCHAIN_PREFIX}gcc.exe")
set(CMAKE_CXX_COMPILER	"${TOOLCHAIN_PATH}${TOOLCHAIN_PREFIX}g++.exe")
set(CMAKE_ASM_COMPILER	"${TOOLCHAIN_PATH}${TOOLCHAIN_PREFIX}gcc.exe")
set(CMAKE_OBJCOPY		"${TOOLCHAIN_PATH}${TOOLCHAIN_PREFIX}objcopy.exe")
set(CMAKE_OBJDUMP		"${TOOLCHAIN_PATH}${TOOLCHAIN_PREFIX}objdump.exe")
set(CMAKE_SIZE			"${TOOLCHAIN_PATH}${TOOLCHAIN_PREFIX}size.exe")

# До строки project() прочитает MCPU_FLAGS из конкретного CCMakeLIsts.txt
set(CMAKE_C_FLAGS_INIT			"${MCPU_FLAGS} -ffunction-sections -fdata-sections -Wall")
set(CMAKE_CXX_FLAGS_INIT		"${MCPU_FLAGS} -ffunction-sections -fdata-sections -fno-exceptions -fno-rtti -Wall")
set(CMAKE_ASM_FLAGS_INIT		"${MCPU_FLAGS} -fverbose-asm -x assembler-with-cpp")
set(CMAKE_EXE_LINKER_FLAGS_INIT	"${MCPU_FLAGS} -Wl,--gc-sections -nostartfiles -nostdlib")

## -ffunction-sections
# Помещать каждую функцию в собственную секцию .text.functionName
## -fdata-sections
# Помещать каждый (глобальный/статический) объект данных в собственную секцию .data.var1 или .bss.var2

set(CMAKE_EXPORT_COMPILE_COMMANDS	ON)

# Настройки поиска библиотек (не искать в хост-системе)
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM	NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY	ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE	ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE	ONLY)

function(OBJDUMP_GENERATE_LIST TARGET_NAME TARGET_PATH)
    add_custom_command(TARGET ${TARGET_NAME} POST_BUILD
    	COMMAND ${CMAKE_COMMAND} -E echo "Generating binary and list files for ${TARGET_NAME}"
        COMMAND ${CMAKE_OBJDUMP} -DSshtz -M force-thumb ${TARGET_PATH} > ${TARGET_PATH}.list
    )
endfunction()

function(OBJCOPY_GENERATE_BINHEX TARGET_NAME TARGET_PATH)
	add_custom_command(TARGET ${TARGET_NAME} POST_BUILD
		COMMAND ${CMAKE_COMMAND} -E echo "Generating .bin and .hex files"
		COMMAND ${CMAKE_OBJCOPY} -O binary
			${TARGET_PATH}
			${TARGET_PATH}.bin
		COMMAND ${CMAKE_OBJCOPY} -O ihex
			${TARGET_PATH}
			${TARGET_PATH}.hex
	)
	add_custom_command(TARGET ${TARGET_NAME} POST_BUILD
		COMMAND ${CMAKE_COMMAND} -E echo "---------------- Memory Usage Analysis ----------------"
		COMMAND ${CMAKE_SIZE} ${TARGET_PATH}
	)
endfunction()
