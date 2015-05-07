module tb_crc_comb();

localparam FRAME_SIZE = 4;
localparam CRC_SIZE = 4;
localparam MASK = 4'b0000;

wire [CRC_SIZE - 1 : 0] crc_comb_out[0 : FRAME_SIZE];

reg  [FRAME_SIZE - 1 : 0] data_in;
reg  [CRC_SIZE   - 1 : 0] crc_init;
reg  [CRC_SIZE   - 1 : 0] crc_poly;
reg  [CRC_SIZE   - 2 : 0] crc_poly_size;

assign crc_comb_out[0] = crc_init;
generate
	genvar i;
	for(i = 0; i < FRAME_SIZE; i = i + 1)
		begin
			crc_comb 
			#(
				.CRC_SIZE      ( CRC_SIZE      ),
				.MASK          ( MASK          )
			) CRC_COMB
			(
				.crc_out       ( crc_comb_out[i + 1]         ),
				.data_in       ( data_in[FRAME_SIZE - 1 - i] ),
				.crc_in        ( crc_comb_out[i]             ),
				.crc_poly      ( crc_poly                    ),
        .crc_poly_size ( crc_poly_size               )
			);
		end
endgenerate

  function [3:0] crc_golden;

    input [3:0] Data;
    input [3:0] crc;
    reg [3:0] d;
    reg [3:0] c;
    reg [3:0] newcrc;
  begin
    d = Data;
    c = crc;

    newcrc[0] = d[2] ^ d[1] ^ d[0] ^ c[0] ^ c[1] ^ c[2];
    newcrc[1] = d[3] ^ d[0] ^ c[0] ^ c[3];
    newcrc[2] = d[1] ^ c[1];
    newcrc[3] = d[1] ^ d[0] ^ c[0] ^ c[1];
    crc_golden = newcrc;
  end
  endfunction

initial
	begin
		crc_init = 0;
		crc_poly_size = 3'b000;
		crc_poly = 4'b1011;
    data_in = 0;
		repeat(16)
			begin
			#10;
			if(crc_comb_out[FRAME_SIZE] != crc_golden(data_in, crc_init))
				begin
					$display("TEST FAILED!");
					$stop;
				end
			data_in = data_in + 1;
			end
		$display("TEST PASSED!");
	end
endmodule
