module crc_ip
(
	//OUTPUTS
	output [31:0] HRDATA,
	output HREADYOUT,
	output HRESP,
	//INPUTS
	input [31:0] HWDATA,
	input [31:0] HADDR,
	input [ 2:0] HSIZE,
	input [ 1:0] HTRANS,
	input HWRITE,
	input HSElx,
	input HREADY,
	input HRESETn,
	input HCLK
);

//Internal Signals
wire [31:0] crc_poly_out;
wire [31:0] crc_out;
wire [31:0] crc_init_out;
wire [ 7:0] crc_idr_out;
wire buffer_full;
wire read_wait;
wire [31:0] bus_wr;
wire [ 1:0] crc_poly_size;
wire [ 1:0] bus_size;
wire [ 1:0] rev_in_type;
wire rev_out_type;
wire crc_init_en;
wire crc_idr_en;
wire crc_poly_en;
wire buffer_write_en;
wire reset_chain;

//Instanciation of Host Interface
host_interface HOST_INTERFACE
(
	.HRDATA          ( HRDATA          ),
	.HREADYOUT       ( HREADYOUT       ),
	.HRESP           ( HRESP           ),
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
	.reset_pending   ( reset_pending   ),
	.HWDATA          ( HWDATA          ),
	.HADDR           ( HADDR           ),
	.HSIZE           ( HSIZE           ),
	.HTRANS          ( HTRANS          ),
	.HWRITE          ( HWRITE          ),
	.HSElx           ( HSElx           ),
	.HREADY          ( HREADY          ),
	.HRESETn         ( HRESETn         ),
	.HCLK            ( HCLK            ),
	.crc_poly_out    ( crc_poly_out    ),
	.crc_out         ( crc_out         ),
	.crc_init_out    ( crc_init_out    ),
	.crc_idr_out     ( crc_idr_out     ),
	.buffer_full     ( buffer_full     ),
	.read_wait       ( read_wait       )
);

//Instantiation of crc_unit
crc_unit CRC_UNIT
(
	.crc_poly_out    ( crc_poly_out    ),
	.crc_out         ( crc_out         ),
	.crc_init_out    ( crc_init_out    ),
	.crc_idr_out     ( crc_idr_out     ),
	.buffer_full     ( buffer_full     ),
	.read_wait       ( read_wait       ),
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
	.reset_pending   ( reset_pending   ),
	.clk             ( HCLK            ),
	.rst_n           ( HRESETn         )
);
endmodule
