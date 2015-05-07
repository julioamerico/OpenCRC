module tb_crc_unit;

//Coding for size signal
localparam BYTE      = 2'b00;
localparam HALF_WORD = 2'b01;
localparam WORD      = 2'b10;

localparam POLY_SIZE_32 = 2'b00;
localparam POLY_SIZE_16 = 2'b01;
localparam POLY_SIZE_8  = 2'b10;
localparam POLY_SIZE_7  = 2'b11;

wire [31:0] crc_poly_out;
wire [31:0] crc_out;
wire [31:0] crc_init_out;
wire [7:0] crc_idr_out;
wire buffer_full;

reg [31:0] bus_wr;
reg [ 1:0] crc_poly_size;
reg [ 1:0] bus_size;
reg [ 1:0] rev_in_type;
reg rev_out_type;
reg crc_init_en;
reg crc_idr_en;
reg crc_poly_en;
reg buffer_write_en;
reg reset_chain;
reg clk;
reg rst_n;

task reset;
	begin
		rst_n = 0;
		clk = 0;
		bus_wr = 0;
		crc_poly_size = 0;
		bus_size = 0;
		rev_in_type = 0;
		rev_out_type = 0;
		crc_init_en = 0;
		crc_idr_en = 0;
		crc_poly_en = 0;
		buffer_write_en = 0;
		reset_chain = 0;
		@(posedge clk);
		rst_n = 1;
	end
endtask

task write_bus;
	input [31:0] data_wr;
	input [ 1:0] data_size;
	begin
		buffer_write_en <= 1;
		bus_wr <= data_wr;
		bus_size <= data_size;
		@(posedge clk);
		buffer_write_en <= 0;
	end
endtask

task reset_chain_crc;
	begin
		reset_chain <= 1;
		@(posedge clk);
		reset_chain <= 0;
	end
endtask 

crc_unit CRC_UNIT
(
	.crc_poly_out    ( crc_poly_out    ),
	.crc_out         ( crc_out         ),
	.crc_init_out    ( crc_init_out    ),
	.crc_idr_out     ( crc_idr_out     ),
	.buffer_full     ( buffer_full     ),
	.bus_wr          ( bus_wr          ),
	.crc_poly_size   ( crc_poly_size   ),
	.bus_size        ( bus_size        ),
	.rev_in_type     ( rev_in_type     ),
	.rev_out_type    ( rev_out_type    ),
	.crc_init_en     ( crc_init_en     ),
	.crc_idr_en      ( crc_idr_en      ),
	.crc_poly_en     ( crc_poly_en     ),
	.buffer_write_en ( buffer_write_en ),
	.reset_chain     ( reset_chain     ),
	.clk             ( clk             ),
	.rst_n           ( rst_n           )
);



reg [31:0] crc_res;

initial
	begin
		reset;
		
    crc_poly_size = POLY_SIZE_32;
		//Test Case 1:
		write_bus(32'ha, BYTE);
		write_bus(32'hb, BYTE);
		reset_chain_crc;
		write_bus(32'hc, BYTE);
		write_bus(32'hd, BYTE);

		//Test Case 2:
		reset_chain_crc;
		write_bus(32'haabbccdd, WORD);
		write_bus(32'h01020304, WORD);
		@(posedge clk);
		@(posedge clk);
		//@(posedge clk);
		//write_bus(32'h55667788, WORD);
		write_bus(32'h01010188, BYTE);

crc_res = crc_golden(8'h0a, 32'hffffffff);
$display("%x", crc_res);

crc_res = crc_golden(8'h0b, crc_res);
$display("%x", crc_res);

crc_res = crc_golden(8'h0c, 32'hffffffff);
$display("%x", crc_res);

crc_res = crc_golden(8'h0d, crc_res);
$display("%x", crc_res);

crc_res = crc_32(32'hddccbbaa, 32'hffffffff);
$display("%x", crc_res);

crc_res = crc_32(32'h04030201, crc_res);
$display("%x", crc_res);

crc_res = crc_golden(32'h88, crc_res);
//crc_res = crc_32(32'h88776655, crc_res);
$display("%x", crc_res);
	end

always #10
	clk = !clk;


function [31:0] crc_16;

    input [15:0] Data;
    input [31:0] crc;
    reg [15:0] d;
    reg [31:0] c;
    reg [31:0] newcrc;
  begin
    d = Data;
    c = crc;

    newcrc[0] = d[12] ^ d[10] ^ d[9] ^ d[6] ^ d[0] ^ c[16] ^ c[22] ^ c[25] ^ c[26] ^ c[28];
    newcrc[1] = d[13] ^ d[12] ^ d[11] ^ d[9] ^ d[7] ^ d[6] ^ d[1] ^ d[0] ^ c[16] ^ c[17] ^ c[22] ^ c[23] ^ c[25] ^ c[27] ^ c[28] ^ c[29];
    newcrc[2] = d[14] ^ d[13] ^ d[9] ^ d[8] ^ d[7] ^ d[6] ^ d[2] ^ d[1] ^ d[0] ^ c[16] ^ c[17] ^ c[18] ^ c[22] ^ c[23] ^ c[24] ^ c[25] ^ c[29] ^ c[30];
    newcrc[3] = d[15] ^ d[14] ^ d[10] ^ d[9] ^ d[8] ^ d[7] ^ d[3] ^ d[2] ^ d[1] ^ c[17] ^ c[18] ^ c[19] ^ c[23] ^ c[24] ^ c[25] ^ c[26] ^ c[30] ^ c[31];
    newcrc[4] = d[15] ^ d[12] ^ d[11] ^ d[8] ^ d[6] ^ d[4] ^ d[3] ^ d[2] ^ d[0] ^ c[16] ^ c[18] ^ c[19] ^ c[20] ^ c[22] ^ c[24] ^ c[27] ^ c[28] ^ c[31];
    newcrc[5] = d[13] ^ d[10] ^ d[7] ^ d[6] ^ d[5] ^ d[4] ^ d[3] ^ d[1] ^ d[0] ^ c[16] ^ c[17] ^ c[19] ^ c[20] ^ c[21] ^ c[22] ^ c[23] ^ c[26] ^ c[29];
    newcrc[6] = d[14] ^ d[11] ^ d[8] ^ d[7] ^ d[6] ^ d[5] ^ d[4] ^ d[2] ^ d[1] ^ c[17] ^ c[18] ^ c[20] ^ c[21] ^ c[22] ^ c[23] ^ c[24] ^ c[27] ^ c[30];
    newcrc[7] = d[15] ^ d[10] ^ d[8] ^ d[7] ^ d[5] ^ d[3] ^ d[2] ^ d[0] ^ c[16] ^ c[18] ^ c[19] ^ c[21] ^ c[23] ^ c[24] ^ c[26] ^ c[31];
    newcrc[8] = d[12] ^ d[11] ^ d[10] ^ d[8] ^ d[4] ^ d[3] ^ d[1] ^ d[0] ^ c[16] ^ c[17] ^ c[19] ^ c[20] ^ c[24] ^ c[26] ^ c[27] ^ c[28];
    newcrc[9] = d[13] ^ d[12] ^ d[11] ^ d[9] ^ d[5] ^ d[4] ^ d[2] ^ d[1] ^ c[17] ^ c[18] ^ c[20] ^ c[21] ^ c[25] ^ c[27] ^ c[28] ^ c[29];
    newcrc[10] = d[14] ^ d[13] ^ d[9] ^ d[5] ^ d[3] ^ d[2] ^ d[0] ^ c[16] ^ c[18] ^ c[19] ^ c[21] ^ c[25] ^ c[29] ^ c[30];
    newcrc[11] = d[15] ^ d[14] ^ d[12] ^ d[9] ^ d[4] ^ d[3] ^ d[1] ^ d[0] ^ c[16] ^ c[17] ^ c[19] ^ c[20] ^ c[25] ^ c[28] ^ c[30] ^ c[31];
    newcrc[12] = d[15] ^ d[13] ^ d[12] ^ d[9] ^ d[6] ^ d[5] ^ d[4] ^ d[2] ^ d[1] ^ d[0] ^ c[16] ^ c[17] ^ c[18] ^ c[20] ^ c[21] ^ c[22] ^ c[25] ^ c[28] ^ c[29] ^ c[31];
    newcrc[13] = d[14] ^ d[13] ^ d[10] ^ d[7] ^ d[6] ^ d[5] ^ d[3] ^ d[2] ^ d[1] ^ c[17] ^ c[18] ^ c[19] ^ c[21] ^ c[22] ^ c[23] ^ c[26] ^ c[29] ^ c[30];
    newcrc[14] = d[15] ^ d[14] ^ d[11] ^ d[8] ^ d[7] ^ d[6] ^ d[4] ^ d[3] ^ d[2] ^ c[18] ^ c[19] ^ c[20] ^ c[22] ^ c[23] ^ c[24] ^ c[27] ^ c[30] ^ c[31];
    newcrc[15] = d[15] ^ d[12] ^ d[9] ^ d[8] ^ d[7] ^ d[5] ^ d[4] ^ d[3] ^ c[19] ^ c[20] ^ c[21] ^ c[23] ^ c[24] ^ c[25] ^ c[28] ^ c[31];
    newcrc[16] = d[13] ^ d[12] ^ d[8] ^ d[5] ^ d[4] ^ d[0] ^ c[0] ^ c[16] ^ c[20] ^ c[21] ^ c[24] ^ c[28] ^ c[29];
    newcrc[17] = d[14] ^ d[13] ^ d[9] ^ d[6] ^ d[5] ^ d[1] ^ c[1] ^ c[17] ^ c[21] ^ c[22] ^ c[25] ^ c[29] ^ c[30];
    newcrc[18] = d[15] ^ d[14] ^ d[10] ^ d[7] ^ d[6] ^ d[2] ^ c[2] ^ c[18] ^ c[22] ^ c[23] ^ c[26] ^ c[30] ^ c[31];
    newcrc[19] = d[15] ^ d[11] ^ d[8] ^ d[7] ^ d[3] ^ c[3] ^ c[19] ^ c[23] ^ c[24] ^ c[27] ^ c[31];
    newcrc[20] = d[12] ^ d[9] ^ d[8] ^ d[4] ^ c[4] ^ c[20] ^ c[24] ^ c[25] ^ c[28];
    newcrc[21] = d[13] ^ d[10] ^ d[9] ^ d[5] ^ c[5] ^ c[21] ^ c[25] ^ c[26] ^ c[29];
    newcrc[22] = d[14] ^ d[12] ^ d[11] ^ d[9] ^ d[0] ^ c[6] ^ c[16] ^ c[25] ^ c[27] ^ c[28] ^ c[30];
    newcrc[23] = d[15] ^ d[13] ^ d[9] ^ d[6] ^ d[1] ^ d[0] ^ c[7] ^ c[16] ^ c[17] ^ c[22] ^ c[25] ^ c[29] ^ c[31];
    newcrc[24] = d[14] ^ d[10] ^ d[7] ^ d[2] ^ d[1] ^ c[8] ^ c[17] ^ c[18] ^ c[23] ^ c[26] ^ c[30];
    newcrc[25] = d[15] ^ d[11] ^ d[8] ^ d[3] ^ d[2] ^ c[9] ^ c[18] ^ c[19] ^ c[24] ^ c[27] ^ c[31];
    newcrc[26] = d[10] ^ d[6] ^ d[4] ^ d[3] ^ d[0] ^ c[10] ^ c[16] ^ c[19] ^ c[20] ^ c[22] ^ c[26];
    newcrc[27] = d[11] ^ d[7] ^ d[5] ^ d[4] ^ d[1] ^ c[11] ^ c[17] ^ c[20] ^ c[21] ^ c[23] ^ c[27];
    newcrc[28] = d[12] ^ d[8] ^ d[6] ^ d[5] ^ d[2] ^ c[12] ^ c[18] ^ c[21] ^ c[22] ^ c[24] ^ c[28];
    newcrc[29] = d[13] ^ d[9] ^ d[7] ^ d[6] ^ d[3] ^ c[13] ^ c[19] ^ c[22] ^ c[23] ^ c[25] ^ c[29];
    newcrc[30] = d[14] ^ d[10] ^ d[8] ^ d[7] ^ d[4] ^ c[14] ^ c[20] ^ c[23] ^ c[24] ^ c[26] ^ c[30];
    newcrc[31] = d[15] ^ d[11] ^ d[9] ^ d[8] ^ d[5] ^ c[15] ^ c[21] ^ c[24] ^ c[25] ^ c[27] ^ c[31];
    crc_16 = newcrc;
  end
  endfunction

  function [31:0] crc_golden;

    input [7:0] Data;
    input [31:0] crc;
    reg [7:0] d;
    reg [31:0] c;
    reg [31:0] newcrc;
  begin
    d = Data;
    c = crc;

    newcrc[0] = d[6] ^ d[0] ^ c[24] ^ c[30];
    newcrc[1] = d[7] ^ d[6] ^ d[1] ^ d[0] ^ c[24] ^ c[25] ^ c[30] ^ c[31];
    newcrc[2] = d[7] ^ d[6] ^ d[2] ^ d[1] ^ d[0] ^ c[24] ^ c[25] ^ c[26] ^ c[30] ^ c[31];
    newcrc[3] = d[7] ^ d[3] ^ d[2] ^ d[1] ^ c[25] ^ c[26] ^ c[27] ^ c[31];
    newcrc[4] = d[6] ^ d[4] ^ d[3] ^ d[2] ^ d[0] ^ c[24] ^ c[26] ^ c[27] ^ c[28] ^ c[30];
    newcrc[5] = d[7] ^ d[6] ^ d[5] ^ d[4] ^ d[3] ^ d[1] ^ d[0] ^ c[24] ^ c[25] ^ c[27] ^ c[28] ^ c[29] ^ c[30] ^ c[31];
    newcrc[6] = d[7] ^ d[6] ^ d[5] ^ d[4] ^ d[2] ^ d[1] ^ c[25] ^ c[26] ^ c[28] ^ c[29] ^ c[30] ^ c[31];
    newcrc[7] = d[7] ^ d[5] ^ d[3] ^ d[2] ^ d[0] ^ c[24] ^ c[26] ^ c[27] ^ c[29] ^ c[31];
    newcrc[8] = d[4] ^ d[3] ^ d[1] ^ d[0] ^ c[0] ^ c[24] ^ c[25] ^ c[27] ^ c[28];
    newcrc[9] = d[5] ^ d[4] ^ d[2] ^ d[1] ^ c[1] ^ c[25] ^ c[26] ^ c[28] ^ c[29];
    newcrc[10] = d[5] ^ d[3] ^ d[2] ^ d[0] ^ c[2] ^ c[24] ^ c[26] ^ c[27] ^ c[29];
    newcrc[11] = d[4] ^ d[3] ^ d[1] ^ d[0] ^ c[3] ^ c[24] ^ c[25] ^ c[27] ^ c[28];
    newcrc[12] = d[6] ^ d[5] ^ d[4] ^ d[2] ^ d[1] ^ d[0] ^ c[4] ^ c[24] ^ c[25] ^ c[26] ^ c[28] ^ c[29] ^ c[30];
    newcrc[13] = d[7] ^ d[6] ^ d[5] ^ d[3] ^ d[2] ^ d[1] ^ c[5] ^ c[25] ^ c[26] ^ c[27] ^ c[29] ^ c[30] ^ c[31];
    newcrc[14] = d[7] ^ d[6] ^ d[4] ^ d[3] ^ d[2] ^ c[6] ^ c[26] ^ c[27] ^ c[28] ^ c[30] ^ c[31];
    newcrc[15] = d[7] ^ d[5] ^ d[4] ^ d[3] ^ c[7] ^ c[27] ^ c[28] ^ c[29] ^ c[31];
    newcrc[16] = d[5] ^ d[4] ^ d[0] ^ c[8] ^ c[24] ^ c[28] ^ c[29];
    newcrc[17] = d[6] ^ d[5] ^ d[1] ^ c[9] ^ c[25] ^ c[29] ^ c[30];
    newcrc[18] = d[7] ^ d[6] ^ d[2] ^ c[10] ^ c[26] ^ c[30] ^ c[31];
    newcrc[19] = d[7] ^ d[3] ^ c[11] ^ c[27] ^ c[31];
    newcrc[20] = d[4] ^ c[12] ^ c[28];
    newcrc[21] = d[5] ^ c[13] ^ c[29];
    newcrc[22] = d[0] ^ c[14] ^ c[24];
    newcrc[23] = d[6] ^ d[1] ^ d[0] ^ c[15] ^ c[24] ^ c[25] ^ c[30];
    newcrc[24] = d[7] ^ d[2] ^ d[1] ^ c[16] ^ c[25] ^ c[26] ^ c[31];
    newcrc[25] = d[3] ^ d[2] ^ c[17] ^ c[26] ^ c[27];
    newcrc[26] = d[6] ^ d[4] ^ d[3] ^ d[0] ^ c[18] ^ c[24] ^ c[27] ^ c[28] ^ c[30];
    newcrc[27] = d[7] ^ d[5] ^ d[4] ^ d[1] ^ c[19] ^ c[25] ^ c[28] ^ c[29] ^ c[31];
    newcrc[28] = d[6] ^ d[5] ^ d[2] ^ c[20] ^ c[26] ^ c[29] ^ c[30];
    newcrc[29] = d[7] ^ d[6] ^ d[3] ^ c[21] ^ c[27] ^ c[30] ^ c[31];
    newcrc[30] = d[7] ^ d[4] ^ c[22] ^ c[28] ^ c[31];
    newcrc[31] = d[5] ^ c[23] ^ c[29];
    crc_golden = newcrc;
  end
  endfunction


function [31:0] crc_32;

    input [31:0] Data;
    input [31:0] crc;
    reg [31:0] d;
    reg [31:0] c;
    reg [31:0] newcrc;
  begin
    d = Data;
    c = crc;

    newcrc[0] = d[31] ^ d[30] ^ d[29] ^ d[28] ^ d[26] ^ d[25] ^ d[24] ^ d[16] ^ d[12] ^ d[10] ^ d[9] ^ d[6] ^ d[0] ^ c[0] ^ c[6] ^ c[9] ^ c[10] ^ c[12] ^ c[16] ^ c[24] ^ c[25] ^ c[26] ^ c[28] ^ c[29] ^ c[30] ^ c[31];
    newcrc[1] = d[28] ^ d[27] ^ d[24] ^ d[17] ^ d[16] ^ d[13] ^ d[12] ^ d[11] ^ d[9] ^ d[7] ^ d[6] ^ d[1] ^ d[0] ^ c[0] ^ c[1] ^ c[6] ^ c[7] ^ c[9] ^ c[11] ^ c[12] ^ c[13] ^ c[16] ^ c[17] ^ c[24] ^ c[27] ^ c[28];
    newcrc[2] = d[31] ^ d[30] ^ d[26] ^ d[24] ^ d[18] ^ d[17] ^ d[16] ^ d[14] ^ d[13] ^ d[9] ^ d[8] ^ d[7] ^ d[6] ^ d[2] ^ d[1] ^ d[0] ^ c[0] ^ c[1] ^ c[2] ^ c[6] ^ c[7] ^ c[8] ^ c[9] ^ c[13] ^ c[14] ^ c[16] ^ c[17] ^ c[18] ^ c[24] ^ c[26] ^ c[30] ^ c[31];
    newcrc[3] = d[31] ^ d[27] ^ d[25] ^ d[19] ^ d[18] ^ d[17] ^ d[15] ^ d[14] ^ d[10] ^ d[9] ^ d[8] ^ d[7] ^ d[3] ^ d[2] ^ d[1] ^ c[1] ^ c[2] ^ c[3] ^ c[7] ^ c[8] ^ c[9] ^ c[10] ^ c[14] ^ c[15] ^ c[17] ^ c[18] ^ c[19] ^ c[25] ^ c[27] ^ c[31];
    newcrc[4] = d[31] ^ d[30] ^ d[29] ^ d[25] ^ d[24] ^ d[20] ^ d[19] ^ d[18] ^ d[15] ^ d[12] ^ d[11] ^ d[8] ^ d[6] ^ d[4] ^ d[3] ^ d[2] ^ d[0] ^ c[0] ^ c[2] ^ c[3] ^ c[4] ^ c[6] ^ c[8] ^ c[11] ^ c[12] ^ c[15] ^ c[18] ^ c[19] ^ c[20] ^ c[24] ^ c[25] ^ c[29] ^ c[30] ^ c[31];
    newcrc[5] = d[29] ^ d[28] ^ d[24] ^ d[21] ^ d[20] ^ d[19] ^ d[13] ^ d[10] ^ d[7] ^ d[6] ^ d[5] ^ d[4] ^ d[3] ^ d[1] ^ d[0] ^ c[0] ^ c[1] ^ c[3] ^ c[4] ^ c[5] ^ c[6] ^ c[7] ^ c[10] ^ c[13] ^ c[19] ^ c[20] ^ c[21] ^ c[24] ^ c[28] ^ c[29];
    newcrc[6] = d[30] ^ d[29] ^ d[25] ^ d[22] ^ d[21] ^ d[20] ^ d[14] ^ d[11] ^ d[8] ^ d[7] ^ d[6] ^ d[5] ^ d[4] ^ d[2] ^ d[1] ^ c[1] ^ c[2] ^ c[4] ^ c[5] ^ c[6] ^ c[7] ^ c[8] ^ c[11] ^ c[14] ^ c[20] ^ c[21] ^ c[22] ^ c[25] ^ c[29] ^ c[30];
    newcrc[7] = d[29] ^ d[28] ^ d[25] ^ d[24] ^ d[23] ^ d[22] ^ d[21] ^ d[16] ^ d[15] ^ d[10] ^ d[8] ^ d[7] ^ d[5] ^ d[3] ^ d[2] ^ d[0] ^ c[0] ^ c[2] ^ c[3] ^ c[5] ^ c[7] ^ c[8] ^ c[10] ^ c[15] ^ c[16] ^ c[21] ^ c[22] ^ c[23] ^ c[24] ^ c[25] ^ c[28] ^ c[29];
    newcrc[8] = d[31] ^ d[28] ^ d[23] ^ d[22] ^ d[17] ^ d[12] ^ d[11] ^ d[10] ^ d[8] ^ d[4] ^ d[3] ^ d[1] ^ d[0] ^ c[0] ^ c[1] ^ c[3] ^ c[4] ^ c[8] ^ c[10] ^ c[11] ^ c[12] ^ c[17] ^ c[22] ^ c[23] ^ c[28] ^ c[31];
    newcrc[9] = d[29] ^ d[24] ^ d[23] ^ d[18] ^ d[13] ^ d[12] ^ d[11] ^ d[9] ^ d[5] ^ d[4] ^ d[2] ^ d[1] ^ c[1] ^ c[2] ^ c[4] ^ c[5] ^ c[9] ^ c[11] ^ c[12] ^ c[13] ^ c[18] ^ c[23] ^ c[24] ^ c[29];
    newcrc[10] = d[31] ^ d[29] ^ d[28] ^ d[26] ^ d[19] ^ d[16] ^ d[14] ^ d[13] ^ d[9] ^ d[5] ^ d[3] ^ d[2] ^ d[0] ^ c[0] ^ c[2] ^ c[3] ^ c[5] ^ c[9] ^ c[13] ^ c[14] ^ c[16] ^ c[19] ^ c[26] ^ c[28] ^ c[29] ^ c[31];
    newcrc[11] = d[31] ^ d[28] ^ d[27] ^ d[26] ^ d[25] ^ d[24] ^ d[20] ^ d[17] ^ d[16] ^ d[15] ^ d[14] ^ d[12] ^ d[9] ^ d[4] ^ d[3] ^ d[1] ^ d[0] ^ c[0] ^ c[1] ^ c[3] ^ c[4] ^ c[9] ^ c[12] ^ c[14] ^ c[15] ^ c[16] ^ c[17] ^ c[20] ^ c[24] ^ c[25] ^ c[26] ^ c[27] ^ c[28] ^ c[31];
    newcrc[12] = d[31] ^ d[30] ^ d[27] ^ d[24] ^ d[21] ^ d[18] ^ d[17] ^ d[15] ^ d[13] ^ d[12] ^ d[9] ^ d[6] ^ d[5] ^ d[4] ^ d[2] ^ d[1] ^ d[0] ^ c[0] ^ c[1] ^ c[2] ^ c[4] ^ c[5] ^ c[6] ^ c[9] ^ c[12] ^ c[13] ^ c[15] ^ c[17] ^ c[18] ^ c[21] ^ c[24] ^ c[27] ^ c[30] ^ c[31];
    newcrc[13] = d[31] ^ d[28] ^ d[25] ^ d[22] ^ d[19] ^ d[18] ^ d[16] ^ d[14] ^ d[13] ^ d[10] ^ d[7] ^ d[6] ^ d[5] ^ d[3] ^ d[2] ^ d[1] ^ c[1] ^ c[2] ^ c[3] ^ c[5] ^ c[6] ^ c[7] ^ c[10] ^ c[13] ^ c[14] ^ c[16] ^ c[18] ^ c[19] ^ c[22] ^ c[25] ^ c[28] ^ c[31];
    newcrc[14] = d[29] ^ d[26] ^ d[23] ^ d[20] ^ d[19] ^ d[17] ^ d[15] ^ d[14] ^ d[11] ^ d[8] ^ d[7] ^ d[6] ^ d[4] ^ d[3] ^ d[2] ^ c[2] ^ c[3] ^ c[4] ^ c[6] ^ c[7] ^ c[8] ^ c[11] ^ c[14] ^ c[15] ^ c[17] ^ c[19] ^ c[20] ^ c[23] ^ c[26] ^ c[29];
    newcrc[15] = d[30] ^ d[27] ^ d[24] ^ d[21] ^ d[20] ^ d[18] ^ d[16] ^ d[15] ^ d[12] ^ d[9] ^ d[8] ^ d[7] ^ d[5] ^ d[4] ^ d[3] ^ c[3] ^ c[4] ^ c[5] ^ c[7] ^ c[8] ^ c[9] ^ c[12] ^ c[15] ^ c[16] ^ c[18] ^ c[20] ^ c[21] ^ c[24] ^ c[27] ^ c[30];
    newcrc[16] = d[30] ^ d[29] ^ d[26] ^ d[24] ^ d[22] ^ d[21] ^ d[19] ^ d[17] ^ d[13] ^ d[12] ^ d[8] ^ d[5] ^ d[4] ^ d[0] ^ c[0] ^ c[4] ^ c[5] ^ c[8] ^ c[12] ^ c[13] ^ c[17] ^ c[19] ^ c[21] ^ c[22] ^ c[24] ^ c[26] ^ c[29] ^ c[30];
    newcrc[17] = d[31] ^ d[30] ^ d[27] ^ d[25] ^ d[23] ^ d[22] ^ d[20] ^ d[18] ^ d[14] ^ d[13] ^ d[9] ^ d[6] ^ d[5] ^ d[1] ^ c[1] ^ c[5] ^ c[6] ^ c[9] ^ c[13] ^ c[14] ^ c[18] ^ c[20] ^ c[22] ^ c[23] ^ c[25] ^ c[27] ^ c[30] ^ c[31];
    newcrc[18] = d[31] ^ d[28] ^ d[26] ^ d[24] ^ d[23] ^ d[21] ^ d[19] ^ d[15] ^ d[14] ^ d[10] ^ d[7] ^ d[6] ^ d[2] ^ c[2] ^ c[6] ^ c[7] ^ c[10] ^ c[14] ^ c[15] ^ c[19] ^ c[21] ^ c[23] ^ c[24] ^ c[26] ^ c[28] ^ c[31];
    newcrc[19] = d[29] ^ d[27] ^ d[25] ^ d[24] ^ d[22] ^ d[20] ^ d[16] ^ d[15] ^ d[11] ^ d[8] ^ d[7] ^ d[3] ^ c[3] ^ c[7] ^ c[8] ^ c[11] ^ c[15] ^ c[16] ^ c[20] ^ c[22] ^ c[24] ^ c[25] ^ c[27] ^ c[29];
    newcrc[20] = d[30] ^ d[28] ^ d[26] ^ d[25] ^ d[23] ^ d[21] ^ d[17] ^ d[16] ^ d[12] ^ d[9] ^ d[8] ^ d[4] ^ c[4] ^ c[8] ^ c[9] ^ c[12] ^ c[16] ^ c[17] ^ c[21] ^ c[23] ^ c[25] ^ c[26] ^ c[28] ^ c[30];
    newcrc[21] = d[31] ^ d[29] ^ d[27] ^ d[26] ^ d[24] ^ d[22] ^ d[18] ^ d[17] ^ d[13] ^ d[10] ^ d[9] ^ d[5] ^ c[5] ^ c[9] ^ c[10] ^ c[13] ^ c[17] ^ c[18] ^ c[22] ^ c[24] ^ c[26] ^ c[27] ^ c[29] ^ c[31];
    newcrc[22] = d[31] ^ d[29] ^ d[27] ^ d[26] ^ d[24] ^ d[23] ^ d[19] ^ d[18] ^ d[16] ^ d[14] ^ d[12] ^ d[11] ^ d[9] ^ d[0] ^ c[0] ^ c[9] ^ c[11] ^ c[12] ^ c[14] ^ c[16] ^ c[18] ^ c[19] ^ c[23] ^ c[24] ^ c[26] ^ c[27] ^ c[29] ^ c[31];
    newcrc[23] = d[31] ^ d[29] ^ d[27] ^ d[26] ^ d[20] ^ d[19] ^ d[17] ^ d[16] ^ d[15] ^ d[13] ^ d[9] ^ d[6] ^ d[1] ^ d[0] ^ c[0] ^ c[1] ^ c[6] ^ c[9] ^ c[13] ^ c[15] ^ c[16] ^ c[17] ^ c[19] ^ c[20] ^ c[26] ^ c[27] ^ c[29] ^ c[31];
    newcrc[24] = d[30] ^ d[28] ^ d[27] ^ d[21] ^ d[20] ^ d[18] ^ d[17] ^ d[16] ^ d[14] ^ d[10] ^ d[7] ^ d[2] ^ d[1] ^ c[1] ^ c[2] ^ c[7] ^ c[10] ^ c[14] ^ c[16] ^ c[17] ^ c[18] ^ c[20] ^ c[21] ^ c[27] ^ c[28] ^ c[30];
    newcrc[25] = d[31] ^ d[29] ^ d[28] ^ d[22] ^ d[21] ^ d[19] ^ d[18] ^ d[17] ^ d[15] ^ d[11] ^ d[8] ^ d[3] ^ d[2] ^ c[2] ^ c[3] ^ c[8] ^ c[11] ^ c[15] ^ c[17] ^ c[18] ^ c[19] ^ c[21] ^ c[22] ^ c[28] ^ c[29] ^ c[31];
    newcrc[26] = d[31] ^ d[28] ^ d[26] ^ d[25] ^ d[24] ^ d[23] ^ d[22] ^ d[20] ^ d[19] ^ d[18] ^ d[10] ^ d[6] ^ d[4] ^ d[3] ^ d[0] ^ c[0] ^ c[3] ^ c[4] ^ c[6] ^ c[10] ^ c[18] ^ c[19] ^ c[20] ^ c[22] ^ c[23] ^ c[24] ^ c[25] ^ c[26] ^ c[28] ^ c[31];
    newcrc[27] = d[29] ^ d[27] ^ d[26] ^ d[25] ^ d[24] ^ d[23] ^ d[21] ^ d[20] ^ d[19] ^ d[11] ^ d[7] ^ d[5] ^ d[4] ^ d[1] ^ c[1] ^ c[4] ^ c[5] ^ c[7] ^ c[11] ^ c[19] ^ c[20] ^ c[21] ^ c[23] ^ c[24] ^ c[25] ^ c[26] ^ c[27] ^ c[29];
    newcrc[28] = d[30] ^ d[28] ^ d[27] ^ d[26] ^ d[25] ^ d[24] ^ d[22] ^ d[21] ^ d[20] ^ d[12] ^ d[8] ^ d[6] ^ d[5] ^ d[2] ^ c[2] ^ c[5] ^ c[6] ^ c[8] ^ c[12] ^ c[20] ^ c[21] ^ c[22] ^ c[24] ^ c[25] ^ c[26] ^ c[27] ^ c[28] ^ c[30];
    newcrc[29] = d[31] ^ d[29] ^ d[28] ^ d[27] ^ d[26] ^ d[25] ^ d[23] ^ d[22] ^ d[21] ^ d[13] ^ d[9] ^ d[7] ^ d[6] ^ d[3] ^ c[3] ^ c[6] ^ c[7] ^ c[9] ^ c[13] ^ c[21] ^ c[22] ^ c[23] ^ c[25] ^ c[26] ^ c[27] ^ c[28] ^ c[29] ^ c[31];
    newcrc[30] = d[30] ^ d[29] ^ d[28] ^ d[27] ^ d[26] ^ d[24] ^ d[23] ^ d[22] ^ d[14] ^ d[10] ^ d[8] ^ d[7] ^ d[4] ^ c[4] ^ c[7] ^ c[8] ^ c[10] ^ c[14] ^ c[22] ^ c[23] ^ c[24] ^ c[26] ^ c[27] ^ c[28] ^ c[29] ^ c[30];
    newcrc[31] = d[31] ^ d[30] ^ d[29] ^ d[28] ^ d[27] ^ d[25] ^ d[24] ^ d[23] ^ d[15] ^ d[11] ^ d[9] ^ d[8] ^ d[5] ^ c[5] ^ c[8] ^ c[9] ^ c[11] ^ c[15] ^ c[23] ^ c[24] ^ c[25] ^ c[27] ^ c[28] ^ c[29] ^ c[30] ^ c[31];
    crc_32 = newcrc;
  end
  endfunction

endmodule
