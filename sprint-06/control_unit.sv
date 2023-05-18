module control_unit (
		input [5:0] OP,
		            funct,
		
		output reg reg_write,
					  reg_dst,
					  ULA_src,
					  branch,
					  mem_write,
					  mem_to_reg,
					  jump,
		
		output reg [2:0] ULA_control
	);

	// logic bus
	wire [9:0] w_lbus;
	
	always_comb begin
		case(OP)
			6'b000000: w_lbus = 10'b1100000xxx;       // Tipo R
			6'b100011: w_lbus = {7'b1010010, 3'b010}; // LW
			6'b101011: w_lbus = {7'b0x101x0, 3'b010}; // SW
			6'b000100: w_lbus = 10'b0x010x0110;       // BEQ
			6'b001000: w_lbus = 10'b1010000010;       // ADDi
			6'b000010: w_lbus = 10'b0xxx0x1xxx;       // J
			default  : w_lbus = 10'b0xx0xx0xxx;       // NOPE
		endcase
		
		case(funct)
		   6'b100000: w_lbus[2:0] = 3'b010; // ADD
			6'b100010: w_lbus[2:0] = 3'b110; // SUB
			6'b100100: w_lbus[2:0] = 3'b000; // AND
			6'b100101: w_lbus[2:0] = 3'b001; // OR
			6'b100111: w_lbus[2:0] = 3'b011; // NOR
			6'b101010: w_lbus[2:0] = 3'b111; // SLT
		endcase
		
		{reg_write, reg_dst, ULA_src, branch, mem_write, mem_to_reg, jump, ULA_control} = w_lbus;
	end

endmodule
