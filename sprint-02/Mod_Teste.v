/*
	Sprint 02
	
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
		output [17:0] LEDR
		
		//Serial
		/*output UART_TXD,
		input UART_RXD,
		inout [7:0] LCD_DATA,
		output LCD_ON, LCD_BLON, LCD_RW, LCD_EN, LCD_RS,
		
		//GPIO
		inout [35:0] GPIO_0, GPIO_1*/
	);
	
	/*assign GPIO_1 = 36'hzzzzzzzzz;
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
	);*/
	
	//---------- modifique a partir daqui --------
	
	
	// ----- Questao 01 -----
	assign HEX0[0:6] = SW[6:0];
	
	
	// ----- Questao 02 -----
	hex_dec dec_sw (
		.bin_in (SW[11:8]),
		.display_out (HEX3[0:6])
	);
	
	
	// ----- Questao 03 -----
	wire clock_1Hz;
	
	clock_divider #(.DIVISOR(28'd50_000_000)) div_1Hz( // 50MHz / 50M = 1Hz
		.clock_in (CLOCK_50),
		.clock_out (clock_1Hz)
	);
	
	assign LEDG[0] = clock_1Hz; // test on LED

	
	// ----- Questao 04 -----
	wire [3:0] counter_M10;
	
	// instantiates the counter module with parameter d10
	counter #(.MAX_COUNT(4'd10)) cont_M10 (
		.clock (clock_1Hz),
		.rst (KEY[1]),
		.count (LEDR[3:0])
	);
	
	hex_dec dec_counter (
		.bin_in (counter_M10),
		.display_out (HEX4[0:6])
	);
	
	
	// ----- Desafio -----
	wire clock_6Hz;
	wire [3:0] counter_M6;
	
	assign LEDG[1] = clock_6Hz; // test on LED
	
	clock_divider #(.DIVISOR(28'd8_333_333)) div_6Hz( // 50MHz / 8.3M ~= 6Hz
		.clock_in (CLOCK_50),
		.clock_out (clock_6Hz)
	);
	
	counter #(.MAX_COUNT(4'd6)) cont_M6 (
		.clock (clock_6Hz),
		.rst (KEY[2]),
		.count (counter_M6)
	);
	
	loading_dec dec_loading (
		.bin_in (counter_M6),
		.display_out (HEX6[0:6])
	);
	
endmodule
