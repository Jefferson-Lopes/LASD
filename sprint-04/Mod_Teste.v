/*
	Sprint 04
	
	Jefferson Lopes

*/

`default_nettype none //Comando para desabilitar declaração automática de wires

module Mod_Teste (
		//Clocks
		input CLOCK_27, CLOCK_50,
		
		//Chaves e Botoes
		input [3:0] KEY,
		input [17:0] SW,
		
		//Displays de 7 seg e LEDs
		output [0:6] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7,
		output [8:0] LEDG,
		output [17:0] LEDR,
		
		//Serial
		output UART_TXD,
		input UART_RXD,
		inout [7:0] LCD_DATA,
		output LCD_ON, LCD_BLON, LCD_RW, LCD_EN, LCD_RS,
		
		//GPIO
		inout [35:0] GPIO_0, GPIO_1
	);
	
	assign GPIO_1 = 36'hzzzzzzzzz;
	assign GPIO_0 = 36'hzzzzzzzzz;
	assign LCD_ON = 1'b1;
	assign LCD_BLON = 1'b1;
	
	wire [7:0] w_d0x0, w_d0x1, w_d0x2, w_d0x3, w_d0x4, w_d0x5,
	w_d1x0, w_d1x1, w_d1x2, w_d1x3, w_d1x4, w_d1x5;
	
	LCD_TEST MyLCD (
		.iCLK ( CLOCK_50 ),
		.iRST_N ( KEY[0] ),
		.d0x0(w_d0x0),.d0x1(w_d0x1),.d0x2(w_d0x2),.d0x3(w_d0x3),.d0x4(w_d0x4),.d0x5(w_d0x5),
		.d1x0(w_d1x0),.d1x1(w_d1x1),.d1x2(w_d1x2),.d1x3(w_d1x3),.d1x4(w_d1x4),.d1x5(w_d1x5),
		.LCD_DATA( LCD_DATA ),
		.LCD_RW ( LCD_RW ),
		.LCD_EN ( LCD_EN ),
		.LCD_RS ( LCD_RS )
	);
	
	
	//---------- modifique a partir daqui --------
	
	
	// ----- clock setup ----- 
	wire clock_1Hz;
	
	clock_divider  #(.FREQ(32'd1)) div_1Hz (
		.clock_50MHz (CLOCK_50),
		.clock_out (clock_1Hz)
	);
	
	assign LEDG[0] = clock_1Hz; // test on LED
	// ----------
	
	
	// ----- Questao 02 -----
	wire [7:0] w_src_B, w_rd1_src_A, w_rd2, w_ULA_result_wd3;
	
	register_file register_bank (
		.wd3 (SW[7:0]),
		.wa3 (SW[16:14]),
		.we3 (1'b1),
		.ra1 (SW[13:11]),
		.ra2 (3'b010),
		.clk (KEY[1]),
		.rst (KEY[2]),
		.rd1 (w_rd1_src_A), 
		.rd2 (w_rd2)
	);
	
	mux_2x1 mux_ULA_src (
		.sel (SW[17]),
		.x0  (w_rd2),
		.x1  (8'h07),
		.Y   (w_src_B)
	);
	
	ULA ula (
		.src_A   (w_rd1_src_A),
		.src_B   (w_src_B),
		.control (SW[10:8]),
		.result  (w_ULA_result_wd3),
		.Z       (LEDG[1])
	);
	
	assign LEDG[8] = ~ KEY[1];
	assign w_d0x0 = w_rd1_src_A;
	assign w_d1x0 = w_rd2;
	assign w_d1x1 = w_src_B;
	assign w_d0x4 = w_ULA_result_wd3;
	
	hex_dec dec_sw_0 (
		.bin_in (SW[3:0]),
		.display_out (HEX0[0:6])
	);
	
	hex_dec dec_sw_1 (
		.bin_in (SW[7:4]),
		.display_out (HEX1[0:6])
	);
	
	// ----------
	
endmodule
