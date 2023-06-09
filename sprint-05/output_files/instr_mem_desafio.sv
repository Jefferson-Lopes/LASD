module instr_mem_desafio (
		input [7:0] A,
		
		output [31:0] RD
	);
	
	always_comb begin
		
		case (A)
			/* ----- desafio -----
			ADDi $5, $0, 8'h_CA
			ADD  $4, $5, $5
			ADD  $3, $4, $4
			ADD  $2, $3, $3
			ADD  $1, $2, $2*/
			
			8'd0    : RD <= 32'b_001000_00000_00101_00000_00011_001010;
			8'd1    : RD <= 32'b_000000_00101_00101_00100_00000_100000;
			8'd2    : RD <= 32'b_000000_00100_00100_00011_00000_100000;
			8'd3    : RD <= 32'b_000000_00011_00011_00010_00000_100000;
			8'd4    : RD <= 32'b_000000_00010_00010_00001_00000_100000;
			
			default : RD <= 32'b_000000_00000_00000_00000_00000_000000;
		endcase
		
	end
	
endmodule
