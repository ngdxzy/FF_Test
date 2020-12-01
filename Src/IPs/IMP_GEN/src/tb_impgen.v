`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.08.2020 15:44:50
// Design Name: 
// Module Name: tb_impgen
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


module tb_impgen(

    );
	localparam NATIVE_ADDR_WDITH = 2;
	localparam NATIVE_DATA_WIDTH = 9;

	reg REFCLK;
	reg                                      NATIVE_CLK;
	reg                                      NATIVE_EN;
	reg                                      NATIVE_WR;
	reg   [NATIVE_ADDR_WDITH-1: 0]           NATIVE_ADDR;
	reg   [NATIVE_DATA_WIDTH-1: 0]           NATIVE_DATA_IN;
	wire  [NATIVE_DATA_WIDTH-1: 0]           NATIVE_DATA_OUT;
	wire                                     NATIVE_READY;
	reg square_in;
	reg rst_n;
	wire imp_out;
	IMP_Core #(
			.REFCLK_FREQUENCY(500),
			.NATIVE_ADDR_WDITH(NATIVE_ADDR_WDITH),
			.NATIVE_DATA_WIDTH(NATIVE_DATA_WIDTH)
		) inst_IMP_Core (
			.REFCLK          (REFCLK),
			.NATIVE_CLK      (NATIVE_CLK),
			.NATIVE_EN       (NATIVE_EN),
			.NATIVE_WR       (NATIVE_WR),
			.NATIVE_ADDR     (NATIVE_ADDR),
			.NATIVE_DATA_IN  (NATIVE_DATA_IN),
			.NATIVE_DATA_OUT (NATIVE_DATA_OUT),
			.NATIVE_READY    (NATIVE_READY),
			.rst_n           (rst_n),
			.square_in       (square_in),
			.imp_out         (imp_out)
		);
	always begin
		#5 NATIVE_CLK = !NATIVE_CLK;
	end
	always begin
		#1 REFCLK = !REFCLK;
	end
	always begin
		#10 square_in = !square_in;
	end
	initial begin
		rst_n = 1; NATIVE_CLK = 1; REFCLK = 1; square_in = 0;
		NATIVE_EN = 0;NATIVE_WR = 0; NATIVE_DATA_IN = 0; NATIVE_ADDR = 0;
		#10 rst_n = 0;
		#10 rst_n = 1;
		#100 NATIVE_WR = 1;NATIVE_DATA_IN = 10;NATIVE_EN = 1;
		#10 NATIVE_EN = 0;
		#500 NATIVE_WR = 0; NATIVE_EN = 1;
		#10 NATIVE_EN = 1;
		#10 NATIVE_EN = 0;
		#200 NATIVE_WR = 1;NATIVE_DATA_IN = 11;NATIVE_EN = 1;NATIVE_ADDR = 1;
		#10 NATIVE_EN = 0;
		#500 NATIVE_WR = 0; NATIVE_EN = 1;
		#10 NATIVE_EN = 1;
		#10 NATIVE_EN = 0;
		#200 $stop;


	end
endmodule
