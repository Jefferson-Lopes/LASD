module loading_dec (
		input [3:0] bin_in,
		output [6:0] display_out
	);
		
	always_comb begin
		case (bin_in)
			4'h0: display_out = 7'b0111111;
			4'h1: display_out = 7'b1011111;
			4'h2: display_out = 7'b1101111;
			4'h3: display_out = 7'b1110111;
			4'h4: display_out = 7'b1111011;
			4'h5: display_out = 7'b1111101;
			default: display_out = 7'b1111111;
		endcase
	end
	
endmodule
