module parallel_out(
		input [7:0] address,
						reg_data,
		input 		we,
						clk,
		output[7:0] data_out,
		output		wren
	);

	wire enable = address == 8'hFF & we;
	
	reg [7:0] register;
	
	assign wren = address != 8'hFF & we;

	always_ff@ (posedge clk) begin
		
		if(enable) begin// enable on
			register = reg_data;
		end
		
	end

	assign data_out = register;

endmodule
