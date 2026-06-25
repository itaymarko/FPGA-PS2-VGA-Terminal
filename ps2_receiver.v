module ps2_receiver (
    input  wire       clk,
    input  wire       rst_n,
    input  wire       ps2_clk,
    input  wire       ps2_data,
    output reg  [7:0] scan_code,
    output wire       valid
);

//----------------------------------------------------------------------
localparam  IDLE   = 2'b00,
            R_DATA = 2'b01,
            PARITY = 2'b10,
            DONE   = 2'b11;

reg [1:0] c_state, n_state;
reg [3:0] bit_count;
reg [7:0] shift_reg;
reg q0, q1;
wire falling_edge;

//----------------------------------------------------------------------
// Synchronizer & Edge Detector
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        q0 <= 1'b1;
        q1 <= 1'b1;
    end
    else begin
        q0 <= ps2_clk;
        q1 <= q0;
    end
end

assign falling_edge = q1 & ~q0;

//----------------------------------------------------------------------
// State Machine: Current State Logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) c_state <= IDLE;
    else if (falling_edge) c_state <= n_state;
end

//----------------------------------------------------------------------
// State Machine: Sequential Logic (Counters & Registers)
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        bit_count <= 4'b0000;
        shift_reg <= 8'd0;
        scan_code <= 8'd0;
    end
    else if (falling_edge) begin
        if (c_state == R_DATA) begin
            bit_count <= bit_count + 4'b0001;
            shift_reg <= {ps2_data, shift_reg[7:1]};
        end
		  else if (c_state == PARITY) begin
				bit_count <= 4'b0000;
		  end
        else if (c_state == DONE) begin
            scan_code <= shift_reg;
        end
        else begin
            bit_count <= 4'b0000;
        end
    end
end

//----------------------------------------------------------------------
// State Machine: Next State Logic
always @(*) begin
    case (c_state)
		IDLE:   if (!ps2_data)               n_state = R_DATA; else n_state = IDLE;
		R_DATA: if (bit_count == 4'd7)       n_state = PARITY; else n_state = R_DATA;
		PARITY: if ((~^shift_reg) == ps2_data) n_state = DONE;   else n_state = IDLE;
		DONE:                                n_state = IDLE;
        default:                           n_state = IDLE;
    endcase
end

//----------------------------------------------------------------------
assign valid = (c_state == DONE) ? 1'b1 : 1'b0;

endmodule
