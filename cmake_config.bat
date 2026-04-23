@echo off
..\arm-none-eabi-cm3\env.bat && cmake -B build -G Ninja -DCMAKE_TOOLCHAIN_FILE=../arm-none-eabi-cm3/arm-none-eabi-toolchain.cmake
