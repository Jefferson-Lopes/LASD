module ULA (
		input [7:0] src_A, src_B, 
		input [2:0] control, 
		
		output reg [7:0] result, 
		output reg Z
	);
	
	always_comb begin
		
		case (control)
			3'b000:  result = src_A & src_B;
			3'b001:  result = src_A | src_B;
			3'b010:  result = src_A + src_B;
			3'b011:  result = ~(src_A | src_B);
			3'b110:  result = src_A - src_B;
			3'b111:  result = src_A < src_B;
			default: result = 8'b0;
		endcase
		
		Z = !result ? 8'b1 : 8'b0;
		
	end
	
endmodule
