`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.08.2020 17:21:35
// Design Name: 
// Module Name: IMP_Core
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


module IDELAY_Core#(
	parameter REFCLK_FREQUENCY       = 300, 
    parameter MODE = "TIME",
    parameter VTC = 1,
    parameter DELAY_ELEMENTS = 3
)(
	input REFCLK,
    input                                      NATIVE_CLK,
    input                                      NATIVE_EN,
    input                                      NATIVE_WR,
    input   [addr_width-1: 0]           	   NATIVE_ADDR,
    input   [9-1: 0]           				   NATIVE_DATA_IN,
    output  [9-1: 0]	       			   NATIVE_DATA_OUT,
    output  reg                                NATIVE_READY,
    input rst_n,
    input [DELAY_ELEMENTS - 1:0]signal_in,
    output [DELAY_ELEMENTS - 1:0]signal_out,
 	output reg IDELAYCTRL_RST
    );
	parameter addr_width =  $clog2(DELAY_ELEMENTS);

	reg start;
 	reg wr;
 	reg [addr_width-1: 0] addr;
 	reg [9-1: 0] data_in;

	wire [DELAY_ELEMENTS - 1:0]change_done;
	wire [DELAY_ELEMENTS - 1:0]change;
	wire [DELAY_ELEMENTS - 1:0]read;
 	wire [DELAY_ELEMENTS * 9 - 1 : 0] Delay_out;
 	wire [DELAY_ELEMENTS - 1:0] bitsel;
 	generate
 		genvar i;
 		for (i = 0;i < DELAY_ELEMENTS; i = i + 1) begin
 			assign bitsel[i] = (addr == i);
 		end
 	endgenerate
 	wire [8:0] selval;
	generate
 		genvar gp;
 		genvar gq;
 		for (gp = 0;gp < 9; gp = gp + 1) begin
 			wire [DELAY_ELEMENTS-1 :0]temp;
 			for (gq = 0;gq < DELAY_ELEMENTS; gq = gq + 1) begin
 				assign temp[gq] = Delay_out[gq * 9 + gp] & bitsel[gq];
 			end
 			assign selval[gp] = |temp;
 		end
 	endgenerate

 	generate
 		genvar j;
 		for (j = 0;j < DELAY_ELEMENTS; j = j + 1) begin
 			assign change[j] = start & wr & bitsel[j];
 			assign read[j] = start & (!wr) & bitsel[j];
 		end
 	endgenerate
 	assign NATIVE_DATA_OUT =selval ;
	always @(posedge NATIVE_CLK) begin
 		if(NATIVE_EN == 1) begin
 			#1 wr <= NATIVE_WR;
 			#1 addr <= NATIVE_ADDR;
 			#1 start <= 1;
 			#1 data_in <= NATIVE_DATA_IN;
 			   NATIVE_READY <= 0;
 		end
 		else begin
 			#1 start <= 0;
 			#1 NATIVE_READY = |change_done;
 		end
 	end
 	reg [1:0]IDELAY_RST;

 	always @ (posedge REFCLK) begin
 		IDELAYCTRL_RST <= !rst_n;
 		IDELAY_RST <= {IDELAY_RST[0],rst_n};
 	end
	generate
		genvar k;
		for(k = 0;k < DELAY_ELEMENTS; k = k + 1) begin
			IDELAY3_DRP  #(
				.REFCLK_FREQUENCY(REFCLK_FREQUENCY),
				.MODE(MODE)
				)inst_IDELAY3_DRP_lead(
					.clk          (NATIVE_CLK),
					.rst_n        (IDELAY_RST[1]),
					.data_in      (signal_in[k]),
					.data_out     (signal_out[k]),
					.read 		  (read[k]),
					.EN_VTC       (VTC),
					.change       (change[k]),
					.done         (change_done[k]),
					.delay_in     (data_in),
					.delay_out    (Delay_out[(k+1) * 9 - 1 :k * 9])
				);
		end
	endgenerate
	
endmodule
