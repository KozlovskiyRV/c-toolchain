cmake_minimum_required(VERSION 3.15)

file(READ "${CMAKE_CURRENT_SOURCE_DIR}/config_cmake.json" JSON_CONTENT)

string(JSON OUT_PATH_FROM_CONFIG GET "${JSON_CONTENT}" "output_dir")

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY	"${CMAKE_CURRENT_BINARY_DIR}/${OUT_PATH_FROM_CONFIG}")
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY	"${CMAKE_CURRENT_BINARY_DIR}/${OUT_PATH_FROM_CONFIG}")
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY	"${CMAKE_CURRENT_BINARY_DIR}/${OUT_PATH_FROM_CONFIG}")
set(LINKER_SCRIPT					"${CMAKE_CURRENT_SOURCE_DIR}/../arm-none-eabi-cm3/linker_script.ld")

# Специфичные флаги для Cortex-M3 (совместимы с mingw-arm и arm-none-eabi)
set(MCPU_FLAGS	"-mcpu=cortex-m3 -mthumb -mfloat-abi=soft")

project(test1 C CXX ASM)

# Исходники
add_executable(${PROJECT_NAME}
    ../arm-none-eabi-cm3/startup.s
    src/main.c
)

# Заголовочные файлы
target_include_directories(${PROJECT_NAME} PRIVATE 
    ${CMAKE_CURRENT_SOURCE_DIR}/inc
)

# Заставляет пересобирать проект, если изменится LINKER_SCRIPT, а не только "исходники"
set_target_properties(${PROJECT_NAME} PROPERTIES 
    LINK_DEPENDS ${LINKER_SCRIPT}
)
# Используем переменную CMAKE_CURRENT_SOURCE_DIR (это папка, где лежит этот CMakeLists)
target_link_options(${PROJECT_NAME} PRIVATE 
    -T${LINKER_SCRIPT}
)

set(MY_EXE_FULL_NAME	"${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${PROJECT_NAME}")
OBJCOPY_GENERATE_BINHEX(${PROJECT_NAME} ${MY_EXE_FULL_NAME})
OBJDUMP_GENERATE_LIST(${PROJECT_NAME} ${MY_EXE_FULL_NAME})

add_custom_target(rebuild
    COMMAND ${CMAKE_COMMAND} -E echo "Cleaning and rebuilding project..."
    COMMAND ${CMAKE_COMMAND} --build ${CMAKE_BINARY_DIR} --target clean
    COMMAND ${CMAKE_COMMAND} --build ${CMAKE_BINARY_DIR}
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
)
