//640x480 ; 60 Hz
module vga_controller(
input	 wire      clk_25MHz,
input  wire      rst_n,
output wire      video_on,
output wire      v_sync,
output wire      h_sync,
output reg [9:0] pixel_x,
output reg [9:0] pixel_y
);

always @(posedge clk_25MHz or negedge rst_n) begin
	if (!rst_n) begin 
		pixel_x<= 10'd0;
		pixel_y<= 10'd0;
	end else if( pixel_x!=799) 
					pixel_x<= pixel_x + 10'd1;
				else begin
						pixel_x <= 10'd0;
						if (pixel_y!=524)  
							pixel_y <= pixel_y + 10'd1;
						else pixel_y <= 10'd0;
					end 
									 
	end 
	
assign h_sync   = (pixel_x >= 656 && pixel_x <= 751) ? 1'b0 : 1'b1;
assign v_sync   = (pixel_y >= 490 && pixel_y <= 491) ? 1'b0 : 1'b1;		
assign video_on = (pixel_x < 640  && pixel_y < 480)  ? 1'b1 : 1'b0;
 
endmodule