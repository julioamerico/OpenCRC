module crc_unit
(
 //OUTPUTS
 output [31:0] crc_poly_out,
 output [31:0] crc_out,
 output [31:0] crc_init_out,
 output [7:0] crc_idr_out,
 output buffer_full,
 output read_wait,
 output reset_pending,
 //INPUTS
 input [31:0] bus_wr,
 input [ 1:0] crc_poly_size,
 input [ 1:0] bus_size,
 input [ 1:0] rev_in_type,
 input rev_out_type,
 input crc_init_en,
 input crc_idr_en,
 input crc_poly_en,
 input buffer_write_en,
 input reset_chain,
 input clk,
 input rst_n
);

//Interconection signals
wire [ 1:0] size_in;
wire [ 1:0] byte_sel;
wire clear_crc_init;
wire set_crc_init;
wire bypass_byte0;
wire bypass_size;
wire crc_out_en;
wire byte_en;
wire buffer_en;

//The write in the buffer only occur if there is free space
assign buffer_en = buffer_write_en && !buffer_full;

//Instance of the Datapath
crc_datapath DATAPATH
(
 .crc_out            ( crc_out        ),
 .size_out           ( size_in        ),
 .crc_idr_out        ( crc_idr_out    ),
 .crc_poly_out       ( crc_poly_out   ),
 .crc_init_out       ( crc_init_out   ),
 .bus_wr             ( bus_wr         ), 
 .rev_in_type        ( rev_in_type    ),
 .rev_out_type       ( rev_out_type   ),
 .buffer_en          ( buffer_en      ),
 .byte_en            ( byte_en        ),
 .crc_init_en        ( crc_init_en    ),
 .crc_out_en         ( crc_out_en     ),
 .crc_idr_en         ( crc_idr_en     ),
 .crc_poly_en        ( crc_poly_en    ),
 .buffer_rst         ( clear_crc_init ),
 .bypass_byte0       ( bypass_byte0   ),
 .bypass_size        ( bypass_size    ),
 .byte_sel           ( byte_sel       ),
 .size_in            ( bus_size       ),
 .clear_crc_init_sel ( clear_crc_init ),
 .set_crc_init_sel   ( set_crc_init   ),
 .crc_poly_size      ( crc_poly_size  ),
 .clk                ( clk            ),
 .rst_n              ( rst_n          )
);

//Instance of the Control unit
crc_control_unit CONTROL_UNIT
(
 .byte_en            ( byte_en          ),
 .crc_out_en         ( crc_out_en       ),
 .byte_sel           ( byte_sel         ),
 .bypass_byte0       ( bypass_byte0     ),
 .buffer_full        ( buffer_full      ),
 .read_wait          ( read_wait        ),
 .bypass_size        ( bypass_size      ),
 .set_crc_init_sel   ( set_crc_init     ),
 .clear_crc_init_sel ( clear_crc_init   ),
 .size_in            ( size_in          ),
 .write              ( buffer_write_en  ),
 .reset_chain        ( reset_chain      ),
 .reset_pending      ( reset_pending    ),
 .clk                ( clk              ),
 .rst_n              ( rst_n            )
);
endmodule
