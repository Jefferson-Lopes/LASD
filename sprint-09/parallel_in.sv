module parallel_in(
		input [7:0] address,	 // mem address
						data_in,	 // input interface
						mem_data, // mem interface
		output[7:0] reg_data	 // output 
	);

	assign reg_data = address == 8'hFF ? data_in : mem_data;

endmodule
