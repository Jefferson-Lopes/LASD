module clock_divider 
	#(
		parameter DIVISOR
	)
	(
		input clock_in,
		output reg clock_out
	);
	
	// counter buffer
	reg[27:0] counter=28'd0;
	
	// counter and reset logic
	always @ (posedge clock_in) begin
		counter = counter + 28'd1;
		
		if ( counter >= (DIVISOR - 1) ) begin
			counter = 28'd0;
		end
		
		clock_out = (counter < (DIVISOR / 2)) ? (1'b1) : (1'b0);
	end
	
endmodule
