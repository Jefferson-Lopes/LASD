module counter 
	#(
		parameter MAX_COUNT
	)	
	(
		input clock, rst,
		output reg [3:0] count
	);
		
	// counter up and reset logic
	always @ (negedge rst, posedge clock) begin
		
		// reset counter
		if (rst == 1'b0) begin
			count = 4'b0;
		end
		
		// count up
		else begin
			count = count + 1;
			
			if ( count >= MAX_COUNT ) begin
				count = 4'b0;
			end
		end
	end
	
endmodule
