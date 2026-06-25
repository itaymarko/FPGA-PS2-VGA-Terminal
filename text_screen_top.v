module text_screen_top(
input wire clk,
input wire rst_n,
input wire ps2_clk,
input wire ps2_data,
output wire v_sync,
output wire h_sync,
output reg [3:0] red,
output reg [3:0] green,
output reg [3:0] blue
);

reg clk_25MHz;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        clk_25MHz <= 1'b0;
    end
    else clk_25MHz <= ~clk_25MHz;
end 

wire [9:0]  pixel_x;
wire [9:0]  pixel_y;
wire        video_on;
wire [7:0]  scancode;
wire        scan_ready;
wire [7:0]  ascii_char;
wire        char_valid;
wire [7:0]  char_code;
wire [7:0]  font_data;
wire [10:0] font_rom_addr;
     
vga_controller vga_inst (
    .clk_25MHz (clk_25MHz),
    .rst_n     (rst_n),
    .video_on  (video_on),
    .h_sync    (h_sync),
    .v_sync    (v_sync),
    .pixel_x   (pixel_x),
    .pixel_y   (pixel_y)
);

assign font_rom_addr = {char_code[6:0], pixel_y[3:0]};

// --- Edge Detector for valid signal ---
reg char_valid_d;
wire char_valid_pulse;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        char_valid_d <= 1'b0;
    end else begin
        char_valid_d <= char_valid;
    end
end

// Generate a 1-clock-cycle pulse only on the rising edge
assign char_valid_pulse = char_valid & ~char_valid_d;
text_buffer buffer_inst (
    .clk            (clk),
    .rst_n          (rst_n),
    .new_ascii_in   (ascii_char),
    .write_enable   (char_valid_pulse),
    .pixel_x        (pixel_x),
    .pixel_y        (pixel_y),
    .char_code_out  (char_code)
);

font_rom font_inst (
    .clk  (clk),
    .addr (font_rom_addr),
    .data (font_data)
);

ps2_receiver ps2_inst(
    .clk       (clk),
    .rst_n     (rst_n),
    .ps2_clk   (ps2_clk),
    .ps2_data  (ps2_data),
    .scan_code (scancode),
    .valid     (scan_ready)
);

scancode_decoder decoder_inst(
    .clk          (clk),
    .rst_n        (rst_n),
    .valid_in     (scan_ready),
    .scan_code_in (scancode),
    .ascii_out    (ascii_char),
    .char_valid   (char_valid)
);

wire pixel_bit = font_data[3'd7 - pixel_x[2:0]];

always @(*) begin
    if (video_on == 1'b0) begin
         red   = 4'h0;
         green = 4'h0;
         blue  = 4'h0;
    end
    else if (pixel_bit) begin
         red   = 4'hF;
         green = 4'hF;
         blue  = 4'hF;
    end
    else begin 
         red   = 4'h0;
         green = 4'h0;
         blue  = 4'h0;
    end
end
        
endmodule