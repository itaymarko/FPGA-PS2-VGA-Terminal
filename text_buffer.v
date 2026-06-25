module text_buffer (
    input wire        clk,
    input wire  [9:0] pixel_x,
    input wire  [9:0] pixel_y,
	 input wire  [7:0] new_ascii_in,
	 input wire        write_enable,
	 input wire        rst_n,
	 output wire [7:0] char_code_out
	 
);

wire [6:0]  text_col;
wire [4:0]  text_row;
reg  [7:0]  ram [0:2399];
wire [11:0] read_address;
reg  [11:0] write_address;


assign text_col = pixel_x[9:3];
assign text_row = pixel_y[9:4];
assign read_address = (text_row * 80) + text_col;
assign char_code_out = ram[read_address];

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) 
		write_address<= 12'd0;
	else if (write_enable) begin 
			 ram[write_address] <= new_ascii_in;
				if (write_address == 2399)
					 write_address <= 12'd0;
				else write_address <= write_address + 12'd1;
			end
		end
			 

endmodule 