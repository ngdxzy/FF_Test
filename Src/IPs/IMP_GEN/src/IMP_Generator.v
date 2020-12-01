`timescale 1ns / 1ps


module IMP_Generator#(
	parameter REFCLK_FREQUENCY       = 300,
    parameter NATIVE_ADDR_WDITH       = 2,                
    parameter NATIVE_DATA_WIDTH       = 9,
    parameter S_AXI_ADDR_WIDTH     = 4,               
    parameter S_AXI_DATA_WIDTH     = 32,
    parameter MODE = "TIME",
    parameter Voltage_TEMP_Ctl = 1
)(
	input REFCLK,
	input REFCLK_RESET_N,
	input                             S_AXI_PG_aclk,
	input                             S_AXI_PG_aresetn,
	input  [S_AXI_ADDR_WIDTH-1:0]     S_AXI_PG_araddr,
	output                            S_AXI_PG_arready,
	input                             S_AXI_PG_arvalid,
	input  [2:0]                      S_AXI_PG_arprot,
	input [S_AXI_ADDR_WIDTH-1:0]      S_AXI_PG_awaddr,
	output                            S_AXI_PG_awready,
	input                             S_AXI_PG_awvalid,
	input  [2:0]                      S_AXI_PG_awprot,
	output  [1:0]                     S_AXI_PG_bresp,  
	input                             S_AXI_PG_bready,
	output                            S_AXI_PG_bvalid,
	output     [S_AXI_DATA_WIDTH-1:0] S_AXI_PG_rdata,
	input                             S_AXI_PG_rready,
	output                            S_AXI_PG_rvalid,
	output  [1:0]                     S_AXI_PG_rresp,
	input  [S_AXI_DATA_WIDTH-1:0]     S_AXI_PG_wdata,
	output                            S_AXI_PG_wready,
	input                             S_AXI_PG_wvalid,
	input  [S_AXI_DATA_WIDTH/8-1:0]   S_AXI_PG_wstrb,
	input Square_in,
	output IMP_out,
	output IDELAYCTRL_RST,
	output lead,
    output lag
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
		.S_AXI_aclk      (S_AXI_PG_aclk),
		.S_AXI_aresetn   (S_AXI_PG_aresetn),
		.S_AXI_araddr    (S_AXI_PG_araddr),
		.S_AXI_arready   (S_AXI_PG_arready),
		.S_AXI_arvalid   (S_AXI_PG_arvalid),
		.S_AXI_arprot    (S_AXI_PG_arprot),
		.S_AXI_awaddr    (S_AXI_PG_awaddr),
		.S_AXI_awready   (S_AXI_PG_awready),
		.S_AXI_awvalid   (S_AXI_PG_awvalid),
		.S_AXI_awprot    (S_AXI_PG_awprot),
		.S_AXI_bresp     (S_AXI_PG_bresp),
		.S_AXI_bready    (S_AXI_PG_bready),
		.S_AXI_bvalid    (S_AXI_PG_bvalid),
		.S_AXI_rdata     (S_AXI_PG_rdata),
		.S_AXI_rready    (S_AXI_PG_rready),
		.S_AXI_rvalid    (S_AXI_PG_rvalid),
		.S_AXI_rresp     (S_AXI_PG_rresp),
		.S_AXI_wdata     (S_AXI_PG_wdata),
		.S_AXI_wready    (S_AXI_PG_wready),
		.S_AXI_wvalid    (S_AXI_PG_wvalid),
		.S_AXI_wstrb     (S_AXI_PG_wstrb),
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
		.MODE             (MODE),
		.Voltage_TEMP_Ctl (Voltage_TEMP_Ctl)
	) inst_IMP_Core (
		.NATIVE_CLK      (NATIVE_CLK),
		.NATIVE_EN       (NATIVE_EN),
		.NATIVE_WR       (NATIVE_WR),
		.NATIVE_ADDR     (NATIVE_ADDR),
		.NATIVE_DATA_IN  (NATIVE_DATA_IN),
		.NATIVE_DATA_OUT (NATIVE_DATA_OUT),
		.NATIVE_READY    (NATIVE_READY),
		.REFCLK          (REFCLK),
		.rst_n           (REFCLK_RESET_N),
		.square_in       (Square_in),
		.imp_out         (IMP_out),
		.IDELAYCTRL_RST  (IDELAYCTRL_RST),
		.lead			 (lead),
		.lag			 (lag)
	);



endmodule
