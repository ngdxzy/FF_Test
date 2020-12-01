`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/25/2020 06:49:12 PM
// Design Name: 
// Module Name: AXI_DELAY
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


module AXI_DELAY 
#(  parameter REFCLK_FREQUENCY       = 300,
    parameter NATIVE_ADDR_WDITH       = 1,                
    parameter NATIVE_DATA_WIDTH       = 9,
    parameter S_AXI_ADDR_WIDTH     = 3,               
    parameter S_AXI_DATA_WIDTH     = 32,
    parameter MODE = "TIME"
)(
	input REFCLK,
	input REFCLK_RESET_N,
	input                             S_AXI_DELAY_aclk,
	input                             S_AXI_DELAY_aresetn,
	input  [S_AXI_ADDR_WIDTH-1:0]     S_AXI_DELAY_araddr,
	output                            S_AXI_DELAY_arready,
	input                             S_AXI_DELAY_arvalid,
	input  [2:0]                      S_AXI_DELAY_arprot,
	input [S_AXI_ADDR_WIDTH-1:0]      S_AXI_DELAY_awaddr,
	output                            S_AXI_DELAY_awready,
	input                             S_AXI_DELAY_awvalid,
	input  [2:0]                      S_AXI_DELAY_awprot,
	output  [1:0]                     S_AXI_DELAY_bresp,  
	input                             S_AXI_DELAY_bready,
	output                            S_AXI_DELAY_bvalid,
	output     [S_AXI_DATA_WIDTH-1:0] S_AXI_DELAY_rdata,
	input                             S_AXI_DELAY_rready,
	output                            S_AXI_DELAY_rvalid,
	output  [1:0]                     S_AXI_DELAY_rresp,
	input  [S_AXI_DATA_WIDTH-1:0]     S_AXI_DELAY_wdata,
	output                            S_AXI_DELAY_wready,
	input                             S_AXI_DELAY_wvalid,
	input  [S_AXI_DATA_WIDTH/8-1:0]   S_AXI_DELAY_wstrb,
	
    input signal_in,
    output signal_out,

 	output IDELAYCTRL_RST
    );
    wire                                      NATIVE_CLK;
    wire                                      NATIVE_EN;
    wire                                      NATIVE_WR;
    wire   [NATIVE_ADDR_WDITH-1: 0]           NATIVE_ADDR;
    wire   [NATIVE_DATA_WIDTH-1: 0]           NATIVE_DATA_IN;
    wire   [NATIVE_DATA_WIDTH-1: 0]           NATIVE_DATA_OUT;
    wire                                      NATIVE_READY;

	AXI_Core #(
		.NATIVE_ADDR_WDITH(NATIVE_ADDR_WDITH),
		.NATIVE_DATA_WIDTH(NATIVE_DATA_WIDTH),
		.S_AXI_ADDR_WIDTH(S_AXI_ADDR_WIDTH),
		.S_AXI_DATA_WIDTH(S_AXI_DATA_WIDTH)
	) inst_AXI_Core (
		.S_AXI_aclk      (S_AXI_DELAY_aclk),
		.S_AXI_aresetn   (S_AXI_DELAY_aresetn),
		.S_AXI_araddr    (S_AXI_DELAY_araddr),
		.S_AXI_arready   (S_AXI_DELAY_arready),
		.S_AXI_arvalid   (S_AXI_DELAY_arvalid),
		.S_AXI_arprot    (S_AXI_DELAY_arprot),
		.S_AXI_awaddr    (S_AXI_DELAY_awaddr),
		.S_AXI_awready   (S_AXI_DELAY_awready),
		.S_AXI_awvalid   (S_AXI_DELAY_awvalid),
		.S_AXI_awprot    (S_AXI_DELAY_awprot),
		.S_AXI_bresp     (S_AXI_DELAY_bresp),
		.S_AXI_bready    (S_AXI_DELAY_bready),
		.S_AXI_bvalid    (S_AXI_DELAY_bvalid),
		.S_AXI_rdata     (S_AXI_DELAY_rdata),
		.S_AXI_rready    (S_AXI_DELAY_rready),
		.S_AXI_rvalid    (S_AXI_DELAY_rvalid),
		.S_AXI_rresp     (S_AXI_DELAY_rresp),
		.S_AXI_wdata     (S_AXI_DELAY_wdata),
		.S_AXI_wready    (S_AXI_DELAY_wready),
		.S_AXI_wvalid    (S_AXI_DELAY_wvalid),
		.S_AXI_wstrb     (S_AXI_DELAY_wstrb),
		.NATIVE_CLK      (NATIVE_CLK),
		.NATIVE_EN       (NATIVE_EN),
		.NATIVE_WR       (NATIVE_WR),
		.NATIVE_ADDR     (NATIVE_ADDR),
		.NATIVE_DATA_IN  (NATIVE_DATA_IN),
		.NATIVE_DATA_OUT (NATIVE_DATA_OUT),
		.NATIVE_READY    (NATIVE_READY)
	);

	IMP_Core #(
			.REFCLK_FREQUENCY(REFCLK_FREQUENCY),
			.NATIVE_ADDR_WDITH(NATIVE_ADDR_WDITH),
			.NATIVE_DATA_WIDTH(NATIVE_DATA_WIDTH),
			.MODE(MODE)
		) inst_IMP_Core (
			.REFCLK          (REFCLK),
			.NATIVE_CLK      (NATIVE_CLK),
			.NATIVE_EN       (NATIVE_EN),
			.NATIVE_WR       (NATIVE_WR),
			.NATIVE_ADDR     (NATIVE_ADDR),
			.NATIVE_DATA_IN  (NATIVE_DATA_IN),
			.NATIVE_DATA_OUT (NATIVE_DATA_OUT),
			.NATIVE_READY    (NATIVE_READY),
			.rst_n           (REFCLK_RESET_N),
			.signal_in       (signal_in),
			.signal_out      (signal_out),
			.IDELAYCTRL_RST  (IDELAYCTRL_RST)
		);



endmodule
