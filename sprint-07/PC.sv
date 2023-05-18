module PC ( // program_counter
		input clk, _rst, 
		input [7:0] PC_in, 
		output reg[7:0] PC
	);

	always_ff @ (posedge clk, negedge _rst) begin
		
		if (!_rst)
			PC = 8'b0;
		else
			PC = PC_in;
		
	end

endmodule
