module scancode_decoder (
    input  wire       clk,
    input  wire       rst_n,
    input  wire       valid_in,
    input  wire [7:0] scan_code_in,
    output reg  [7:0] ascii_out,
    output reg        char_valid
);

reg break_flag;
reg valid_in_d;       
wire valid_pulse;     

assign valid_pulse = valid_in & ~valid_in_d;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        break_flag <= 1'b0;
        char_valid <= 1'b0;
        ascii_out  <= 8'h00;
        valid_in_d <= 1'b0;
    end else begin
        valid_in_d <= valid_in;
        char_valid <= 1'b0;
        
        if (valid_pulse) begin
            if (scan_code_in == 8'hF0) begin
                break_flag <= 1'b1; 
            end else begin
                if (break_flag) begin
                    break_flag <= 1'b0; 
                end else begin
                    char_valid <= 1'b1;
                    
                    case (scan_code_in)
                        8'h1C: ascii_out <= 8'h41; // 'A'
                        8'h32: ascii_out <= 8'h42; // 'B'
                        8'h21: ascii_out <= 8'h43; // 'C'
                        8'h23: ascii_out <= 8'h44; // 'D'
                        8'h24: ascii_out <= 8'h45; // 'E'
                        8'h2B: ascii_out <= 8'h46; // 'F'
                        8'h34: ascii_out <= 8'h47; // 'G'
                        8'h33: ascii_out <= 8'h48; // 'H'
                        8'h43: ascii_out <= 8'h49; // 'I'
                        8'h3B: ascii_out <= 8'h4A; // 'J'
                        8'h42: ascii_out <= 8'h4B; // 'K'
                        8'h4B: ascii_out <= 8'h4C; // 'L'
                        8'h3A: ascii_out <= 8'h4D; // 'M'
                        8'h31: ascii_out <= 8'h4E; // 'N'
                        8'h44: ascii_out <= 8'h4F; // 'O'
                        8'h4D: ascii_out <= 8'h50; // 'P'
                        8'h15: ascii_out <= 8'h51; // 'Q'
                        8'h2D: ascii_out <= 8'h52; // 'R'
                        8'h1B: ascii_out <= 8'h53; // 'S'
                        8'h2C: ascii_out <= 8'h54; // 'T'
                        8'h3C: ascii_out <= 8'h55; // 'U'
                        8'h2A: ascii_out <= 8'h56; // 'V'
                        8'h1D: ascii_out <= 8'h57; // 'W'
                        8'h22: ascii_out <= 8'h58; // 'X'
                        8'h35: ascii_out <= 8'h59; // 'Y'
                        8'h1A: ascii_out <= 8'h5A; // 'Z'

                        8'h45: ascii_out <= 8'h30; // '0'
                        8'h16: ascii_out <= 8'h31; // '1'
                        8'h1E: ascii_out <= 8'h32; // '2'
                        8'h26: ascii_out <= 8'h33; // '3'
                        8'h25: ascii_out <= 8'h34; // '4'
                        8'h2E: ascii_out <= 8'h35; // '5'
                        8'h36: ascii_out <= 8'h36; // '6'
                        8'h3D: ascii_out <= 8'h37; // '7'
                        8'h3E: ascii_out <= 8'h38; // '8'
                        8'h46: ascii_out <= 8'h39; // '9'

                        8'h29: ascii_out <= 8'h20; // Space
                        8'h5A: ascii_out <= 8'h0D; // Enter 
                        
                        default: ascii_out <= 8'h3F;
                    endcase
                end
            end
        end
    end
end

endmodule