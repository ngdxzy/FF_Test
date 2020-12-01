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
    parameter MODE = "TIME",
    parameter Voltage_TEMP_Ctl = 1
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
    input square_in,
    output imp_out,
    output lead,
    output lag,
 	output reg IDELAYCTRL_RST
    );
	
	wire lead_done,lag_done;
	reg [NATIVE_DATA_WIDTH-1: 0] INV_LEAD;
	reg [NATIVE_DATA_WIDTH-1: 0] INV_LAG; 
 	reg [NATIVE_DATA_WIDTH-1: 0] Lead_Delay;
 	reg [NATIVE_DATA_WIDTH-1: 0] Lag_Delay;
 	wire [NATIVE_DATA_WIDTH-1: 0] Lead_Delay_out;
 	wire [NATIVE_DATA_WIDTH-1: 0] Lag_Delay_out;
	reg busy;
	reg start;
 	reg wr;
 	reg [NATIVE_ADDR_WDITH-1: 0] addr;
 	reg [NATIVE_DATA_WIDTH-1: 0] data_in;

 	always @ (*) begin
 		case(addr)
 			0: begin NATIVE_DATA_OUT = Lead_Delay_out; end
 			1: begin NATIVE_DATA_OUT = Lag_Delay_out; end
 			2: begin NATIVE_DATA_OUT <= INV_LEAD; end
 			3: begin NATIVE_DATA_OUT <= INV_LAG; end
 			default:begin
 				NATIVE_DATA_OUT = 0;
 			end
 		endcase
 	end
 	reg inv_done;
	always @ (posedge NATIVE_CLK) begin
 		if (start) begin
 			inv_done <= 1;
 			if(wr) begin
				case(addr)
		 			2: begin INV_LEAD <= data_in[0]; end
		 			3: begin INV_LAG <= data_in[0]; end
		 		endcase
		 	end
		end
		else begin	
 			inv_done <= 0;
		end
 	end
 	wire lead_change = start & wr & (addr == 'd0);
 	wire lag_change = start & wr & (addr == 'd1);
 	wire lead_read = start & (~wr) & (addr == 'd0);
 	wire lag_read = start & (~wr) & (addr == 'd1);


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
 			#1 NATIVE_READY = lead_done | lag_done | inv_done;
 		end
 	end
 	reg [1:0]IDELAY_RST;

 	always @ (posedge REFCLK) begin
 		IDELAYCTRL_RST <= !rst_n;
 		IDELAY_RST <= {IDELAY_RST[0],rst_n};
 	end
	
	wire lead_square_in = INV_LEAD?(~square_in):square_in;
	wire lag_square_in = INV_LAG?(~square_in):square_in;
	IDELAY3_DRP  #(
		.REFCLK_FREQUENCY(REFCLK_FREQUENCY),
		.MODE(MODE),
		.Voltage_TEMP_Ctl (Voltage_TEMP_Ctl)
		)inst_IDELAY3_DRP_lead(
			.clk          (NATIVE_CLK),
			.rst_n        (IDELAY_RST[1]),
			.data_in      (lead_square_in),
			.data_out     (lead),
			.read 		  (lead_read),
			.change       (lead_change),
			.done         (lead_done),
			.delay_in     (data_in),
			.delay_out    (Lead_Delay_out)
		);
	IDELAY3_DRP 		#(
		.REFCLK_FREQUENCY(REFCLK_FREQUENCY),
		.MODE(MODE),
		.Voltage_TEMP_Ctl (Voltage_TEMP_Ctl)
		)inst_IDELAY3_DRP_lag(
			.clk          (NATIVE_CLK),
			.rst_n        (IDELAY_RST[1]),
			.data_in      (lag_square_in),
			.data_out     (lag),
			.read 		  (lag_read),
			.change       (lag_change),
			.done         (lag_done),
			.delay_in     (data_in),
			.delay_out    (Lag_Delay_out)
		);
	assign imp_out = lead & (~lag);

endmodule
