module adder #(parameter n = 8) (
		input [n-1:0] src_A, src_B,
		output result
	);
	
	always_comb begin
		
		result <= src_A + src_B;
		
	end
	
endmodule
