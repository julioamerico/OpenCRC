################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../drivers/mss_rtc/mss_rtc.c 

OBJS += \
./drivers/mss_rtc/mss_rtc.o 

C_DEPS += \
./drivers/mss_rtc/mss_rtc.d 


# Each subdirectory must supply rules for building sources it contributes
drivers/mss_rtc/%.o: ../drivers/mss_rtc/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: GNU C Compiler'
	arm-none-eabi-gcc -mthumb -mcpu=cortex-m3 -IE:\Julio\Projetos\IPs\CRC\src\SoC\crc_ahb_ip\SoftConsole\crc_ahb_ip_MSS_MSS_CM3_0\crc_ahb_ip_MSS_MSS_CM3_0_hw_platform -IE:\Julio\Projetos\IPs\CRC\src\SoC\crc_ahb_ip\SoftConsole\crc_ahb_ip_MSS_MSS_CM3_0\crc_ahb_ip_MSS_MSS_CM3_0_hw_platform\CMSIS -IE:\Julio\Projetos\IPs\CRC\src\SoC\crc_ahb_ip\SoftConsole\crc_ahb_ip_MSS_MSS_CM3_0\crc_ahb_ip_MSS_MSS_CM3_0_hw_platform\CMSIS\startup_gcc -IE:\Julio\Projetos\IPs\CRC\src\SoC\crc_ahb_ip\SoftConsole\crc_ahb_ip_MSS_MSS_CM3_0\crc_ahb_ip_MSS_MSS_CM3_0_hw_platform\drivers -IE:\Julio\Projetos\IPs\CRC\src\SoC\crc_ahb_ip\SoftConsole\crc_ahb_ip_MSS_MSS_CM3_0\crc_ahb_ip_MSS_MSS_CM3_0_hw_platform\drivers\mss_gpio -IE:\Julio\Projetos\IPs\CRC\src\SoC\crc_ahb_ip\SoftConsole\crc_ahb_ip_MSS_MSS_CM3_0\crc_ahb_ip_MSS_MSS_CM3_0_hw_platform\drivers\mss_nvm -IE:\Julio\Projetos\IPs\CRC\src\SoC\crc_ahb_ip\SoftConsole\crc_ahb_ip_MSS_MSS_CM3_0\crc_ahb_ip_MSS_MSS_CM3_0_hw_platform\drivers\mss_pdma -IE:\Julio\Projetos\IPs\CRC\src\SoC\crc_ahb_ip\SoftConsole\crc_ahb_ip_MSS_MSS_CM3_0\crc_ahb_ip_MSS_MSS_CM3_0_hw_platform\drivers\mss_rtc -IE:\Julio\Projetos\IPs\CRC\src\SoC\crc_ahb_ip\SoftConsole\crc_ahb_ip_MSS_MSS_CM3_0\crc_ahb_ip_MSS_MSS_CM3_0_hw_platform\drivers\mss_timer -IE:\Julio\Projetos\IPs\CRC\src\SoC\crc_ahb_ip\SoftConsole\crc_ahb_ip_MSS_MSS_CM3_0\crc_ahb_ip_MSS_MSS_CM3_0_hw_platform\drivers\mss_uart -IE:\Julio\Projetos\IPs\CRC\src\SoC\crc_ahb_ip\SoftConsole\crc_ahb_ip_MSS_MSS_CM3_0\crc_ahb_ip_MSS_MSS_CM3_0_hw_platform\hal -IE:\Julio\Projetos\IPs\CRC\src\SoC\crc_ahb_ip\SoftConsole\crc_ahb_ip_MSS_MSS_CM3_0\crc_ahb_ip_MSS_MSS_CM3_0_hw_platform\hal\CortexM3 -IE:\Julio\Projetos\IPs\CRC\src\SoC\crc_ahb_ip\SoftConsole\crc_ahb_ip_MSS_MSS_CM3_0\crc_ahb_ip_MSS_MSS_CM3_0_hw_platform\hal\CortexM3\GNU -O0 -ffunction-sections -fdata-sections -g3 -Wall -c -fmessage-length=0 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o"$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


