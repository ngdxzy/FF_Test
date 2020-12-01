`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/01/2020 11:30:32 AM
// Design Name: 
// Module Name: tb_ffcore
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_ffcore(

    );
 	parameter NATIVE_ADDR_WDITH       = 3;
    parameter NATIVE_DATA_WIDTH       = 32;
	parameter M = 32'd100;
	FF_Test_Core #(
			.NATIVE_ADDR_WDITH(NATIVE_ADDR_WDITH),
			.NATIVE_DATA_WIDTH(NATIVE_DATA_WIDTH),
			.M(M)
		) inst_FF_Test_Core (
			.REFCLK          (REFCLK),
			.NATIVE_CLK      (NATIVE_CLK),
			.NATIVE_EN       (NATIVE_EN),
			.NATIVE_WR       (NATIVE_WR),
			.NATIVE_ADDR     (NATIVE_ADDR),
			.NATIVE_DATA_IN  (NATIVE_DATA_IN),
			.NATIVE_DATA_OUT (NATIVE_DATA_OUT),
			.NATIVE_READY    (NATIVE_READY),
			.proba_signal    (proba_signal),
			.rst_n           (rst_n),
			.imp_in          (imp_in),
			.ps_done         (ps_done),
			.ps_en           (ps_en),
			.ps_incdec       (ps_incdec),
			.ps_clk          (ps_clk)
		);

	reg 										REFCLK;
    reg                                      NATIVE_CLK;
    reg                                      NATIVE_EN;
    reg                                      NATIVE_WR;
    reg   [NATIVE_ADDR_WDITH-1: 0]           NATIVE_ADDR;
    reg   [NATIVE_DATA_WIDTH-1: 0]           NATIVE_DATA_IN;
    wire   [NATIVE_DATA_WIDTH-1: 0]	       NATIVE_DATA_OUT;
    wire                                  NATIVE_READY;
    wire  proba_signal;
    reg rst_n;
    reg imp_in;
    reg ps_done;
    wire ps_en;
    wire ps_incdec;
    wire ps_clk;

    always begin
    	#5 NATIVE_CLK = ~NATIVE_CLK;
    end
    always begin
    	#2 imp_in = ~imp_in;
    	REFCLK = ~REFCLK;
    end
    initial begin
    	REFCLK = 0;NATIVE_CLK = 0;NATIVE_EN = 0;NATIVE_WR = 0;NATIVE_ADDR = 0;NATIVE_DATA_IN = 0;rst_n = 1; imp_in = 0;ps_done = 1;
    	#10 rst_n = 0;
    	#10 rst_n = 1;
    	#10 NATIVE_EN = 1;NATIVE_WR = 1;NATIVE_ADDR = 1;NATIVE_DATA_IN = 1;
    	#10 NATIVE_EN = 0;NATIVE_WR = 1;NATIVE_ADDR = 1;NATIVE_DATA_IN = 1;
    	#10 NATIVE_EN = 0;NATIVE_WR = 1;NATIVE_ADDR = 1;NATIVE_DATA_IN = 1;
    	#100 
    	#10 NATIVE_EN = 1;NATIVE_WR = 0;NATIVE_ADDR = 2;NATIVE_DATA_IN = 0;
    	#10 NATIVE_EN = 0;NATIVE_WR = 0;NATIVE_ADDR = 2;NATIVE_DATA_IN = 0;
    	#1000 $stop;
    end
endmodule
