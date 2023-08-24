module hex_dec (
		input [3:0] bin_in,
		output [6:0] display_out
	);
		
	always_comb begin
		case (bin_in)
			4'h0: display_out = 7'b0000001;
			4'h1: display_out = 7'b1001111;
			4'h2: display_out = 7'b0010010;
			4'h3: display_out = 7'b0000110;
			4'h4: display_out = 7'b1001100;
			4'h5: display_out = 7'b0100100;
			4'h6: display_out = 7'b0100000;
			4'h7: display_out = 7'b0001111;
			4'h8: display_out = 7'b0000000;
			4'h9: display_out = 7'b0000100;
			4'hA: display_out = 7'b0001000;
			4'hB: display_out = 7'b1100000;
			4'hC: display_out = 7'b0110001;
			4'hD: display_out = 7'b1000010;
			4'hE: display_out = 7'b0110000;
			4'hF: display_out = 7'b0111000;
			default: display_out = 7'b1111111;
		endcase
	end
	
endmodule