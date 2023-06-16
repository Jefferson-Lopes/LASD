module clock_divider 
	#(
		parameter FREQ
	)
	(
		input clock_50MHz,
		output reg clock_out
	);
	
	parameter [31:0] DIVISOR = 32'd50_000_000 / FREQ;
	
	// counter buffer
	reg [31:0] counter = 32'd0;
	
	// counter and reset logic
	always @ (posedge clock_50MHz) begin
		counter = counter + 32'd1;
		
		if ( counter >= (DIVISOR - 1) ) begin
			counter = 32'd0;
		end
		
		clock_out = (counter < (DIVISOR / 2)) ? (1'b1) : (1'b0);
	end
	
endmodule
