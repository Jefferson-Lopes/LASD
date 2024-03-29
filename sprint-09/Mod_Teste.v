/*
	Sprint 09
	
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
	wire clock;
	
	clock_divider  #(.FREQ(32'd1)) div_2Hz (
		.clock_50MHz (CLOCK_50),
		.clock_out (clock)
	);
	
	assign LEDG[0] = clock; // test on LED
	// ----------
	
	
	// ----- Questao 01-----
	wire man_clk, man_rst; // manual clock and reset
	wire w_ULA_src, w_PC_src, w_reg_dst, w_reg_write, w_ULA_Z, w_branch, w_mem_write, w_mem_to_reg, w_jump, w_we;
	wire [2:0] w_ULA_control;
	wire [7:0] w_PC, w_PC_, w_m1, w_nPC, w_PC_branch;
	wire [31:0] w_inst;
	wire [7:0] w_S0, w_S1, w_S2, w_S3, w_S4, w_S5, w_S6, w_S7;
	wire [7:0] w_src_B, w_rd1_src_A, w_rd2, w_ULA_result_wd3, w_wa3, w_wd3, w_RData, w_reg_data;
	wire [7:0] w_data_out, w_data_in;
	
	assign w_PC_ = w_PC + 1;
	assign w_PC_branch = w_PC_ + w_inst[7:0];
	
	mux_2x1 mux_PC_src (
		.sel (w_PC_src),
		.x0  (w_PC_),
		.x1  (w_PC_branch),
		.Y   (w_m1)
	);
	
	mux_2x1 mux_jump(
		.sel (w_jump),
		.x0  (w_m1),
		.x1  (w_inst[7:0]),
		.Y   (w_nPC)
	);
	
	PC pc (
		.clk   (man_clk), 
		._rst  (man_rst), 
		.PC_in (w_nPC), 
		.PC    (w_PC)
	);
	
	ROM_mem ROM (
		.address (w_PC),
		.clock   (CLOCK_50),
		.q       (w_inst)
	);
	
	control_unit control (
		.OP          (w_inst[31:26]),
		.funct       (w_inst[5:0]),
		.reg_write   (w_reg_write),
		.reg_dst     (w_reg_dst),
		.ULA_src     (w_ULA_src),
		.branch      (w_branch),
		.mem_write   (w_mem_write),
		.mem_to_reg  (w_mem_to_reg),
		.jump        (w_jump),
		.ULA_control (w_ULA_control)
	);
	
	register_file register_bank (
		.wd3 (w_wd3),
		.wa3 (w_wa3),
		.we3 (w_reg_write),
		.ra1 (w_inst[25:21]),
		.ra2 (w_inst[20:16]),
		.clk (man_clk),
		.rst (man_rst),
		.rd1 (w_rd1_src_A), 
		.rd2 (w_rd2),
		.S0  (w_S0),
		.S1  (w_S1),
		.S2  (w_S2),
		.S3  (w_S3),
		.S4  (w_S4),
		.S5  (w_S5),
		.S6  (w_S6),
		.S7  (w_S7),
	);
	
	mux_2x1 mux_ULA_src (
		.sel (w_ULA_src),
		.x0  (w_rd2),
		.x1  (w_inst[7:0]),
		.Y   (w_src_B)
	);
	
	mux_2x1 mux_WR (
		.sel (w_reg_dst),
		.x0  (w_inst[20:16]),
		.x1  (w_inst[15:11]),
		.Y   (w_wa3)
	);
	
	ULA ula (
		.src_A   (w_rd1_src_A),
		.src_B   (w_src_B),
		.control (w_ULA_control),
		.result  (w_ULA_result_wd3),
		.Z       (w_ULA_Z)
	);
	
	assign w_PC_src = w_branch && w_ULA_Z;
	
	parallel_out par_out(
		.address  (w_ULA_result_wd3),
		.reg_data (w_rd2),
		.we       (w_mem_write),
		.clk      (man_clk),
		.data_out (w_data_out),
		.wren     (w_we)
	);
	
	RAM_mem data_mem (
		.address (w_ULA_result_wd3),
		.clock   (CLOCK_50),
		.data    (w_rd2),
		.wren    (w_we),
		.q       (w_RData)
	);
	
	parallel_in par_in(
		.address  (w_ULA_result_wd3),
		.data_in  (w_data_in),
		.mem_data (w_RData),
		.reg_data (w_reg_data)
	);
	
	mux_2x1 mux_DD (
		.sel (w_mem_to_reg),
		.x0  (w_ULA_result_wd3),
		.x1  (w_reg_data),
		.Y   (w_wd3)
	);
	
	// ----- external control -----
	assign man_clk = clock;
	assign man_rst = SW[17];
	
	assign w_data_in = SW[7:0];
	
	// ----- debug -----
	
	// LCD
	assign w_d0x0 = w_S0;
	assign w_d0x1 = w_S1;
	assign w_d0x2 = w_S2;
	assign w_d0x3 = w_S3;
	assign w_d1x0 = w_S4;
	assign w_d1x1 = w_S5;
	assign w_d1x2 = w_S6;
	assign w_d1x3 = w_S7;
	
	//assign w_d1x4 = w_PC; //nao compila quando deixo essa linha
	//assign w_d0x4 = w_data_out;
	
	// LEDs
	assign LEDG[1]   = man_clk;
	assign LEDR[9]   = w_reg_write;
	assign LEDR[8]   = w_reg_dst;
	assign LEDR[7]   = w_ULA_src;
	assign LEDR[6:4] = w_ULA_control;
	assign LEDR[3]   = w_branch;
	assign LEDR[2]   = w_mem_write;
	assign LEDR[1]   = w_mem_to_reg;
	assign LEDR[0]   = w_jump;
	
	// ----------
	
endmodule
