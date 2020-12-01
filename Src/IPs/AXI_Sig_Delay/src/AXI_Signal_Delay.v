`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/27/2020 05:40:07 PM
// Design Name: 
// Module Name: AXI_Signal_Delay
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


module AXI_Signal_Delay#(            
    parameter S_AXI_DATA_WIDTH     = 32,
    parameter REFCLK_FREQUENCY       = 300, 
    parameter MODE = "TIME",
    parameter VTC = 1,
    parameter DELAY_ELEMENTS = 3,
    parameter NATIVE_ADDR_WDITH       = 2,
    parameter NATIVE_DATA_WIDTH       = 9,
    parameter S_AXI_ADDR_WIDTH     = 4
)(
	input REFCLK,
	input rst_n,
	input                             S_AXI_SIGDELAY_aclk,
    input                             S_AXI_SIGDELAY_aresetn,

    input  [S_AXI_ADDR_WIDTH-1:0]     S_AXI_SIGDELAY_araddr,
    output                            S_AXI_SIGDELAY_arready,
    input                             S_AXI_SIGDELAY_arvalid,
    input  [2:0]                      S_AXI_SIGDELAY_arprot,

    input [S_AXI_ADDR_WIDTH-1:0]      S_AXI_SIGDELAY_awaddr,
    output                            S_AXI_SIGDELAY_awready,
    input                             S_AXI_SIGDELAY_awvalid,
    input  [2:0]                      S_AXI_SIGDELAY_awprot,

    output  [1:0]                  	  S_AXI_SIGDELAY_bresp,  
    input                             S_AXI_SIGDELAY_bready,
    output                            S_AXI_SIGDELAY_bvalid,

    output     [S_AXI_DATA_WIDTH-1:0] S_AXI_SIGDELAY_rdata,
    input                             S_AXI_SIGDELAY_rready,
    output                            S_AXI_SIGDELAY_rvalid,
    output  [1:0]                     S_AXI_SIGDELAY_rresp,

    input  [S_AXI_DATA_WIDTH-1:0]     S_AXI_SIGDELAY_wdata,
    output                            S_AXI_SIGDELAY_wready,
    input                             S_AXI_SIGDELAY_wvalid,
    input  [S_AXI_DATA_WIDTH/8-1:0]   S_AXI_SIGDELAY_wstrb,

    input [DELAY_ELEMENTS - 1:0]signal_in,
    output [DELAY_ELEMENTS - 1:0]signal_out,
    output IDELAYCTRL_RST
    );
	

    wire                                      NATIVE_CLK;
    wire                                      NATIVE_EN;
    wire                                      NATIVE_WR;
    wire   [NATIVE_ADDR_WDITH-1: 0]           	   NATIVE_ADDR;
    wire   [NATIVE_DATA_WIDTH-1: 0]           				   NATIVE_DATA_IN;
    wire  [NATIVE_DATA_WIDTH-1: 0]	       			   NATIVE_DATA_OUT;
    wire                                NATIVE_READY;

	AXI2NATIVE #(
		.NATIVE_ADDR_WDITH(NATIVE_ADDR_WDITH),
		.NATIVE_DATA_WIDTH(NATIVE_DATA_WIDTH),
		.S_AXI_ADDR_WIDTH(S_AXI_ADDR_WIDTH),
		.S_AXI_DATA_WIDTH(S_AXI_DATA_WIDTH)
	) inst_AXI2NATIVE (
		.S_AXI_aclk      (S_AXI_SIGDELAY_aclk),
		.S_AXI_aresetn   (S_AXI_SIGDELAY_aresetn),
		.S_AXI_araddr    (S_AXI_SIGDELAY_araddr),
		.S_AXI_arready   (S_AXI_SIGDELAY_arready),
		.S_AXI_arvalid   (S_AXI_SIGDELAY_arvalid),
		.S_AXI_arprot    (S_AXI_SIGDELAY_arprot),
		.S_AXI_awaddr    (S_AXI_SIGDELAY_awaddr),
		.S_AXI_awready   (S_AXI_SIGDELAY_awready),
		.S_AXI_awvalid   (S_AXI_SIGDELAY_awvalid),
		.S_AXI_awprot    (S_AXI_SIGDELAY_awprot),
		.S_AXI_bresp     (S_AXI_SIGDELAY_bresp),
		.S_AXI_bready    (S_AXI_SIGDELAY_bready),
		.S_AXI_bvalid    (S_AXI_SIGDELAY_bvalid),
		.S_AXI_rdata     (S_AXI_SIGDELAY_rdata),
		.S_AXI_rready    (S_AXI_SIGDELAY_rready),
		.S_AXI_rvalid    (S_AXI_SIGDELAY_rvalid),
		.S_AXI_rresp     (S_AXI_SIGDELAY_rresp),
		.S_AXI_wdata     (S_AXI_SIGDELAY_wdata),
		.S_AXI_wready    (S_AXI_SIGDELAY_wready),
		.S_AXI_wvalid    (S_AXI_SIGDELAY_wvalid),
		.S_AXI_wstrb     (S_AXI_SIGDELAY_wstrb),
		.NATIVE_CLK      (NATIVE_CLK),
		.NATIVE_EN       (NATIVE_EN),
		.NATIVE_WR       (NATIVE_WR),
		.NATIVE_ADDR     (NATIVE_ADDR),
		.NATIVE_DATA_IN  (NATIVE_DATA_IN),
		.NATIVE_DATA_OUT (NATIVE_DATA_OUT),
		.NATIVE_READY    (NATIVE_READY)
	);
	IDELAY_Core #(
			.REFCLK_FREQUENCY(REFCLK_FREQUENCY),
			.MODE(MODE),
			.VTC(VTC),
			.DELAY_ELEMENTS(DELAY_ELEMENTS)
		) inst_IDELAY_Core (
			.REFCLK          (REFCLK),
			.NATIVE_CLK      (NATIVE_CLK),
			.NATIVE_EN       (NATIVE_EN),
			.NATIVE_WR       (NATIVE_WR),
			.NATIVE_ADDR     (NATIVE_ADDR),
			.NATIVE_DATA_IN  (NATIVE_DATA_IN),
			.NATIVE_DATA_OUT (NATIVE_DATA_OUT),
			.NATIVE_READY    (NATIVE_READY),
			.rst_n           (rst_n),
			.signal_in       (signal_in),
			.signal_out      (signal_out),
			.IDELAYCTRL_RST  (IDELAYCTRL_RST)
		);

endmodule
