`include "../scripts/crc_serial_gen.conf"

module tb_crc_parallel;
localparam CRC_SIZE = `CRC_SIZE;
localparam FRAME_SIZE = `FRAME_SIZE;
localparam CRC_INIT = 0;
localparam CODE_SIZE = FRAME_SIZE + CRC_SIZE;
localparam PATTERN_VECTOR_NUMBER = `PATTERN_VECTOR_NUMBER;
localparam PATTERN_POLYNOMIAL_NUMBER = `PATTERN_VECTOR_NUMBER;
localparam CODE_WORD_NUMBER = PATTERN_POLYNOMIAL_NUMBER * PATTERN_VECTOR_NUMBER;

reg [CODE_SIZE - 1 : 0] code_word [0 : CODE_WORD_NUMBER - 1];
reg [CRC_SIZE : 0] crc_poly[0 : PATTERN_POLYNOMIAL_NUMBER - 1];
reg [CRC_SIZE  - 1: 0] crc_poly_size[0 : PATTERN_POLYNOMIAL_NUMBER - 1];
reg [FRAME_SIZE - 1 : 0] data_in;
reg [CRC_SIZE - 1 : 0] crc_init;

wire [CRC_SIZE - 1 : 0] crc_out;
wire crc_ready;
reg crc_in;
reg start;
reg [CRC_SIZE - 1: 0] crc_poly_in;
reg [CRC_SIZE - 1 : 0] crc_poly_size_in;
reg crc_poly_wr;
reg rst_n;
reg clk;

integer error;

  crc_parallel
#(
	.CRC_SIZE      ( CRC_SIZE      ),
	.FRAME_SIZE    ( FRAME_SIZE    )
)CRC_PARALLEL
(
	.crc_out       ( crc_out          ),
	.data_in       ( data_in          ),
	.crc_in        ( crc_init         ),
	.crc_poly      ( crc_poly_in      ),
  .crc_poly_size ( crc_poly_size_in )
);

task reset;
	begin
		clk = 0;
		start = 0;
		crc_poly_in = 0;
		data_in = 0;
		error = 0;
		crc_init = CRC_INIT;
	end
endtask


task check_result;
	input [CRC_SIZE - 1 : 0] result;
	input [CRC_SIZE - 1 : 0] golden;
	begin
		if(result != golden || (result == golden) === 1'bx)
			begin
				$display("ERROR at time %0d: Expected %x, obtained %x", $time, golden, result);
				error = error + 1;
			end
	end
endtask

task check_test;
	input integer test_number;
	begin
		if(error != 0)
			$display("TEST %0d FAILED!! Founded %d errors", test_number, error);
		else
			$display("TEST %0d PASSED!!", test_number);
	end
endtask

task check_final_test;
	begin
		$display("\nEnded Test Phase.");
		if(error != 0)
			$display("TEST FAILED!! Founded %d errors", error);
		else
			$display("TEST PASSED!!");
	end
endtask

task read_files;
	begin
		$readmemb("../scripts/pattern_vector.bin", code_word);
		$readmemb("../scripts/crc_poly.bin", crc_poly);
		$readmemb("../scripts/crc_poly_size.bin", crc_poly_size);
	end
endtask

integer i, j;

initial
	begin
		read_files;
		reset;
		for(j = 0; j < PATTERN_POLYNOMIAL_NUMBER; j = j + 1)
			begin
				$display("Test %0d: Poly = %b", j, crc_poly[j]);
				@(posedge clk);
				crc_poly_in = crc_poly[j][CRC_SIZE - 1 : 0];
        crc_poly_size_in = crc_poly_size[j];
				@(posedge clk);
				for(i = 0; i < PATTERN_VECTOR_NUMBER; i = i + 1)
					begin
						data_in = code_word[i + j*PATTERN_VECTOR_NUMBER][CODE_SIZE - 1 -: FRAME_SIZE];
						@(posedge clk);
						check_result(crc_out, code_word[i + j*PATTERN_VECTOR_NUMBER][CRC_SIZE - 1 : 0]);
					end
				check_test(j);
			end
		check_final_test;
		$stop;
	end

always #10
	clk = !clk;

endmodule
