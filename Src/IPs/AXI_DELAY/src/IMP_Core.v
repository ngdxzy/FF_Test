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


module IMP_Core#(
	parameter REFCLK_FREQUENCY       = 300,
    parameter NATIVE_ADDR_WDITH       = 2,                
    parameter NATIVE_DATA_WIDTH       = 32,
    parameter MODE = "TIME"
)(
	input REFCLK,
    input                                      NATIVE_CLK,
    input                                      NATIVE_EN,
    input                                      NATIVE_WR,
    input   [NATIVE_ADDR_WDITH-1: 0]           NATIVE_ADDR,
    input   [NATIVE_DATA_WIDTH-1: 0]           NATIVE_DATA_IN,
    output  reg [NATIVE_DATA_WIDTH-1: 0]           NATIVE_DATA_OUT,
    output  reg                                    NATIVE_READY,
    input rst_n,
    input signal_in,
    output signal_out,
 	output reg IDELAYCTRL_RST
    );
	
	wire change_done;
	reg [NATIVE_DATA_WIDTH-1: 0] EN_VTC;
 	wire [NATIVE_DATA_WIDTH-1: 0] Delay_out;
	reg busy;
	reg start;
 	reg wr;
 	reg [NATIVE_ADDR_WDITH-1: 0] addr;
 	reg [NATIVE_DATA_WIDTH-1: 0] data_in;

 	always @ (*) begin
 		case(addr)
 			0: begin NATIVE_DATA_OUT = Delay_out; end
 			1: begin NATIVE_DATA_OUT = EN_VTC; end
 			default:begin
 				NATIVE_DATA_OUT = 0;
 			end
 		endcase
 	end
 	reg EN_VTC_done;
	always @ (posedge NATIVE_CLK) begin
 		if (start) begin
 			EN_VTC_done <= 1;
 			if(wr) begin
				case(addr)
		 			1: begin EN_VTC <= data_in[0]; end
		 		endcase
		 	end
		end
		else begin	
 			EN_VTC_done <= 0;
		end
 	end
 	wire change = start & wr & (addr == 'd0);
 	wire read = start & (!wr) & (addr == 'd0);

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
 			#1 NATIVE_READY = change_done | EN_VTC_done;
 		end
 	end
 	reg [1:0]IDELAY_RST;

 	always @ (posedge REFCLK) begin
 		IDELAYCTRL_RST <= !rst_n;
 		IDELAY_RST <= {IDELAY_RST[0],rst_n};
 	end
	
	IDELAY3_DRP  #(
		.REFCLK_FREQUENCY(REFCLK_FREQUENCY),
		.MODE(MODE)
		)inst_IDELAY3_DRP_lead(
			.clk          (NATIVE_CLK),
			.rst_n        (IDELAY_RST[1]),
			.data_in      (signal_in),
			.data_out     (signal_out),
			.read 		  (read),
			.EN_VTC       (EN_VTC[0]),
			.change       (change),
			.done         (change_done),
			.delay_in     (data_in),
			.delay_out    (Delay_out)
		);
	
endmodule
