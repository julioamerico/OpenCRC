O OpenCRC é um projeto open source que disponibiliza um IP Core de uma unidade de cálculo de CRC compatível com o protocolo AMBA AHB capaz de operar sobre dados de 8, 16 e 32 bits com polinômio gerador configurável (tanto o grau quanto os coeficientes). O IP Core do projeto OpenCRC é funcionalmente compatível com o periférico CRC presente na família de microcontroladores STM32F334xx. Através do repositório do projeto são disponibilizados:
 - O RTL, em Verilog, do IP Core;
  - Um testbench;
  - Uma camada de abstração de hardware (HAL), escrita em C, compatível com o padrão ARM CMSIS;
	
Para propósito de validação, o IP foi prototipado em um dispositivo SmartFusion A2F200M3F. Todos os arquivos necessários para embarcá-lo nessa plataforma também são disponibilizados através do repositório do projeto.

