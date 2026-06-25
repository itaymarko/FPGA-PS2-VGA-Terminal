`timescale 1ns / 1ps
module tb_ps2_receiver();

  
    reg clk;
    reg rst_n;
    reg ps2_clk;
    reg ps2_data;

    wire [7:0] scan_code;
    wire valid;

    
    ps2_receiver uut (
        .clk(clk),
        .rst_n(rst_n),
        .ps2_clk(ps2_clk),
        .ps2_data(ps2_data),
        .scan_code(scan_code),
        .valid(valid)
    );
	 initial begin clk <= 1'd0; end
	 always #10 clk = ~clk;
	 initial begin 
		ps2_clk = 1'b1;
		ps2_data = 1'b1;
		rst_n = 1'b0;
		#50;
		rst_n = 1'b1;
		#200000;
		send_byte(8'h1C);
		#200000;
		send_byte(8'hF0);
		#200000;
		send_byte(8'h1C);
			$stop;
		end
		
    // Task: Send a single byte via PS/2 protocol
    // --------------------------------------------------
    task send_byte;
        input [7:0] data_to_send;
        integer i;
        begin
            // 1. Send Start Bit (Value: 0)
            ps2_data = 1'b0;
            #50000;
            ps2_clk = 1'b0;
            #50000;
            ps2_clk = 1'b1;

            // 2. Send 8 Data Bits (LSB first)
            for (i = 0; i < 8; i = i + 1) begin
                ps2_data = data_to_send[i]; 
                #50000;
                ps2_clk = 1'b0;             
                #50000;
                ps2_clk = 1'b1;             
            end

            // 3. Send Parity Bit (Odd Parity)
            ps2_data = ~^data_to_send;      
            #50000;
            ps2_clk = 1'b0;
            #50000;
            ps2_clk = 1'b1;

            // 4. Send Stop Bit (Value: 1)
            ps2_data = 1'b1;
            #50000;
            ps2_clk = 1'b0;
            #50000;
            ps2_clk = 1'b1;
        end
    endtask
endmodule 