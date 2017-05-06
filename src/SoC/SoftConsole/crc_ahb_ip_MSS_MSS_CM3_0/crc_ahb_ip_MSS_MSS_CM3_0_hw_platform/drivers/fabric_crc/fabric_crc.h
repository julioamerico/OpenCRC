/**
  ******************************************************************************
  * @file    fabric_crc.h
  * @author  Júlio Cesar - Adapted from STMicroelectronics Driver Code
  * @version V1.0.1
  * @date    30/09/2014
  * @brief   This file contains all the functions prototypes for the CRC firmware
  *          library.
  ******************************************************************************
  */

/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef __FABRIC_CRC_H
#define __FABRIC_CRC_H

#ifdef __cplusplus
 extern "C" {
#endif

/*!< Includes ----------------------------------------------------------------*/
#include "a2fxxxm3.h"
#include "crc_ahb_ip_hw_platform.h"

 /**
   * @brief CRC calculation unit
   */

 typedef struct
 {
   __IO uint32_t DR;          /*!< CRC Data register,                           Address offset: 0x00 */
   __IO uint8_t  IDR;         /*!< CRC Independent data register,               Address offset: 0x04 */
   uint8_t       RESERVED0;   /*!< Reserved,                                                    0x05 */
   uint16_t      RESERVED1;   /*!< Reserved,                                                    0x06 */
   __IO uint32_t CR;          /*!< CRC Control register,                        Address offset: 0x08 */
   uint32_t      RESERVED2;   /*!< Reserved,                                                    0x0C */
   __IO uint32_t INIT;        /*!< Initial CRC value register,                  Address offset: 0x10 */
   __IO uint32_t POL;         /*!< CRC polynomial register,                     Address offset: 0x14 */
 } CRC_TypeDef;

#define CRC_BASE            (CRC_IP_0)
#define CRC                 ((CRC_TypeDef *) CRC_BASE)
#define IS_FUNCTIONAL_STATE(STATE) (((STATE) == DISABLE) || ((STATE) == ENABLE))

 typedef enum {DISABLE = 0, ENABLE = !DISABLE} FunctionalState;

 /******************************************************************************/
 /*                                                                            */
 /*                     CRC calculation unit (CRC)                             */
 /*                                                                            */
 /******************************************************************************/
 /*******************  Bit definition for CRC_DR register  *********************/
 #define  CRC_DR_DR                           ((uint32_t)0xFFFFFFFF) /*!< Data register bits */

 /*******************  Bit definition for CRC_IDR register  ********************/
 #define  CRC_IDR_IDR                         ((uint8_t)0xFF)        /*!< General-purpose 8-bit data register bits */

 /********************  Bit definition for CRC_CR register  ********************/
 #define  CRC_CR_RESET                        ((uint32_t)0x00000001) /*!< RESET the CRC computation unit bit */
 #define  CRC_CR_POLSIZE                      ((uint32_t)0x00000018) /*!< Polynomial size bits */
 #define  CRC_CR_POLSIZE_0                    ((uint32_t)0x00000008) /*!< Polynomial size bit 0 */
 #define  CRC_CR_POLSIZE_1                    ((uint32_t)0x00000010) /*!< Polynomial size bit 1 */
 #define  CRC_CR_REV_IN                       ((uint32_t)0x00000060) /*!< REV_IN Reverse Input Data bits */
 #define  CRC_CR_REV_IN_0                     ((uint32_t)0x00000020) /*!< Bit 0 */
 #define  CRC_CR_REV_IN_1                     ((uint32_t)0x00000040) /*!< Bit 1 */
 #define  CRC_CR_REV_OUT                      ((uint32_t)0x00000080) /*!< REV_OUT Reverse Output Data bits */

 /*******************  Bit definition for CRC_INIT register  *******************/
 #define  CRC_INIT_INIT                       ((uint32_t)0xFFFFFFFF) /*!< Initial CRC value bits */

 /*******************  Bit definition for CRC_POL register  ********************/
 #define  CRC_POL_POL                         ((uint32_t)0xFFFFFFFF) /*!< Coefficients of the polynomial */

/** @addtogroup STM32F30x_StdPeriph_Driver
  * @{
  */

/** @addtogroup CRC
  * @{
  */

/* Exported types ------------------------------------------------------------*/
/* Exported constants --------------------------------------------------------*/

/** @defgroup CRC_ReverseInputData
  * @{
  */
#define CRC_ReverseInputData_No             ((uint32_t)0x00000000) /*!< No reverse operation of Input Data */
#define CRC_ReverseInputData_8bits          CRC_CR_REV_IN_0        /*!< Reverse operation of Input Data on 8 bits */
#define CRC_ReverseInputData_16bits         CRC_CR_REV_IN_1        /*!< Reverse operation of Input Data on 16 bits */
#define CRC_ReverseInputData_32bits         CRC_CR_REV_IN          /*!< Reverse operation of Input Data on 32 bits */

#define IS_CRC_REVERSE_INPUT_DATA(DATA) (((DATA) == CRC_ReverseInputData_No)     || \
                                         ((DATA) == CRC_ReverseInputData_8bits)  || \
                                         ((DATA) == CRC_ReverseInputData_16bits) || \
                                         ((DATA) == CRC_ReverseInputData_32bits))

/**
  * @}
  */

/** @defgroup CRC_PolynomialSize
  * @{
  */
#define CRC_PolSize_7                       CRC_CR_POLSIZE        /*!< 7-bit polynomial for CRC calculation */
#define CRC_PolSize_8                       CRC_CR_POLSIZE_1      /*!< 8-bit polynomial for CRC calculation */
#define CRC_PolSize_16                      CRC_CR_POLSIZE_0      /*!< 16-bit polynomial for CRC calculation */
#define CRC_PolSize_32                      ((uint32_t)0x00000000)/*!< 32-bit polynomial for CRC calculation */

#define IS_CRC_POL_SIZE(SIZE) (((SIZE) == CRC_PolSize_7)  || \
                               ((SIZE) == CRC_PolSize_8)  || \
                               ((SIZE) == CRC_PolSize_16) || \
                               ((SIZE) == CRC_PolSize_32))

/**
  * @}
  */

/* Exported macro ------------------------------------------------------------*/
/* Exported functions ------------------------------------------------------- */
/* Configuration of the CRC computation unit **********************************/
void CRC_DeInit(void);
void CRC_ResetDR(void);
void CRC_PolynomialSizeSelect(uint32_t CRC_PolSize);
void CRC_ReverseInputDataSelect(uint32_t CRC_ReverseInputData);
void CRC_ReverseOutputDataCmd(FunctionalState NewState);
void CRC_SetInitRegister(uint32_t CRC_InitValue);
void CRC_SetPolynomial(uint32_t CRC_Pol);

/* CRC computation ************************************************************/
uint32_t CRC_CalcCRC(uint32_t CRC_Data);
uint32_t CRC_CalcCRC16bits(uint16_t CRC_Data);
uint32_t CRC_CalcCRC8bits(uint8_t CRC_Data);
uint32_t CRC_CalcBlockCRC(uint32_t pBuffer[], uint32_t BufferLength);
uint32_t CRC_GetCRC(void);

/* Independent register (IDR) access (write/read) *****************************/
void CRC_SetIDRegister(uint8_t CRC_IDValue);
uint8_t CRC_GetIDRegister(void);

#ifdef __cplusplus
}
#endif

#endif

/**
  * @}
  */

/**
  * @}
  */
