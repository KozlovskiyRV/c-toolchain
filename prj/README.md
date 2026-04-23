
## `cmake_config.bat`
Конфигурирует CMake (выбирает систему сборки Ninja, добавляет общий "тулчейн" `..\arm-none-eabi\arm-none-eabi-toolchain.cmake`)
Благодаря общему тулчейну обновляется файл clangd `build/compile_commands.json`, из-за чего clangd получает возможность использовать для анализа новые файлы (если был обновлён `add_executable()`/`target_include_directories()`)

## `cmake --build build`
Запускает компиляцию Ninja

## `config_cmake.json`
Файл настройки CMake (можно было бы настройку оставить в CMakeLists.txt, но так удобнее)
