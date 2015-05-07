module tb_bit_reversal;

localparam DATA_SIZE = 32;

reg [1:0] type;
reg [DATA_SIZE - 1 : 0] data_in;
wire [DATA_SIZE - 1 : 0] data_out;


bit_reversal 
#(
	.DATA_SIZE ( DATA_SIZE )
)REV
(
	.data_out ( data_out ),
	.data_in  ( data_in  ),
	.rev_type ( type     )
);

integer i, size;

initial
	begin
	type = 0;
	data_in = 32'h1a2b3c4d;
	repeat(4)
		begin
			#1;
			$display("%x", data_out);
			type = type + 1;
		end
	end
endmodule
