#include "fabric_crc.h"
#include <stdio.h>

int main(void){

	uint32_t crc32_d32, crc32_d8, crc32_d16;

	//Reset CRC IP
	CRC_DeInit();

	//Configure CRC IP
	CRC_PolynomialSizeSelect(CRC_PolSize_32);

	//Compute CRC 32, Data 32
	CRC_SetPolynomial(0x04c11db7);
	CRC_SetInitRegister(0x14635287);
	crc32_d32 = CRC_CalcCRC(0xaabbccdd);

	//Compute CRC 32, Data 16
	CRC_ResetDR();
	CRC_SetPolynomial(0x04c11db7);
	CRC_SetInitRegister(0x14635287);
	crc32_d16  = CRC_CalcCRC16bits(0x3344);

	//Compute CRC 32, Data 8
	CRC_ResetDR();
	CRC_SetPolynomial(0x04c11db7);
	CRC_SetInitRegister(0x11223344);
	crc32_d8  = CRC_CalcCRC8bits(0x28);

	while(1){};
	return 0;
}

