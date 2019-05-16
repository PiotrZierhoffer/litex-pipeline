*** Settings ***
Suite Setup                   Setup
Suite Teardown                Teardown
Test Setup                    Reset Emulation
Resource                      /opt/renode/tests/renode-keywords.robot

*** Variables ***
${UART}                       sysbus.uart

*** Keywords ***
Prepare Machine
    [Arguments]

    Execute Command           $bin=@${CURDIR}/artifacts/Image
    Execute Command           $rootfs=@${CURDIR}/artifacts/rootfs.cpio
    Execute Command           i @${CURDIR}/litex_vexriscv_linux.resc
    Execute Command           showAnalyzer ${UART} Antmicro.Renode.Analyzers.LoggingUartAnalyzer

*** Test Cases ***
Should Start Linux From Bootloader
    [Documentation]           Starts the bootloader on Litex with VexRiscv CPU and expects it boots to Linux
    [Tags]                    bootloader  litex  vexriscv  uart  interrupts
    Execute Command           logFile @${CURDIR}/artifacts/bootloader.log
    Prepare Machine

    Create Terminal Tester    ${UART}  prompt=root@buildroot:~#
    Start Emulation
    Wait For Line On Uart     Linux version 5.0.14

    Provides                  finished-bootloader
    Execute Command           Save @${CURDIR}/artifacts/bootloader.save

Should Boot Linux
    [Documentation]           Boots Linux on LiteX with VexRiscv CPU
    [Tags]                    linux  litex  vexriscv  uart  interrupts
    Execute Command           logFile @${CURDIR}/artifacts/linux.log
    Requires                  finished-bootloader

    Wait For Prompt On Uart   buildroot login  timeout=120
    Write Line To Uart        root
    Wait For Prompt On Uart

    Provides                  booted-linux
    Execute Command           Save @${CURDIR}/artifacts/linux.save

Should Ls
    [Documentation]           Tests shell responsiveness in Linux on LiteX with VexRiscv CPU
    [Tags]                    linux  litex  vexriscv  uart  interrupts
    Execute Command           logFile @${CURDIR}/artifacts/ls.log
    Requires                  booted-linux

    Write Line To Uart        ls --color=never /
    Wait For Line On Uart     proc
    Execute Command           Save @${CURDIR}/artifacts/ls.save
