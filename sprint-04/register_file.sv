module register_file(
		// inputs
		input [7:0] 	wd3, // write data
		input	[2:0]		wa3, // write address
		input 			we3, // write enable
		input [2:0]ra1,ra2, // register address
		input				clk, // clock
		input     		rst, // clock auxiliar para comutar a saída
		
		// outputs
		output reg[7:0] rd1, rd2 // register data
	);

	// registers bank
	reg [7:0] registers[7:0];

	// register write
	always @ (posedge clk, negedge rst) begin
		
		if (~rst) begin
			// reset all registers
			registers[0] <= 8'b0; // $0
			registers[1] <= 8'b0; // $1
			registers[2] <= 8'b0; // $2
			registers[3] <= 8'b0; // $3
			registers[4] <= 8'b0; // $4
			registers[5] <= 8'b0; // $5
			registers[6] <= 8'b0; // $6
			registers[7] <= 8'b0; // $7
		end
		
		else if (we3 && wa3)	begin
			registers[wa3][7:0] <= wd3;
		end
		
	end
	
	// register read
	always_comb begin
		
		rd1 <= registers[ra1];
		rd2 <= registers[ra2];
		
	end

endmodule
