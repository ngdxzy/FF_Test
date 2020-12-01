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


module AXI_FF_Test#(            
    parameter S_AXI_DATA_WIDTH     = 32,
    parameter REFCLK_FREQUENCY       = 300, 
    parameter MODE = "TIME",
    parameter VTC = 1,
    parameter DELAY_ELEMENTS = 3,
    parameter NATIVE_ADDR_WDITH       = 3,
    parameter NATIVE_DATA_WIDTH       = 32,
    parameter S_AXI_ADDR_WIDTH     = 5,

	parameter M = 32'd10000
)(
	input REFCLK,
	input rst_n,
	input                             S_AXI_FF_TEST_aclk,
    input                             S_AXI_FF_TEST_aresetn,

    input  [S_AXI_ADDR_WIDTH-1:0]     S_AXI_FF_TEST_araddr,
    output                            S_AXI_FF_TEST_arready,
    input                             S_AXI_FF_TEST_arvalid,
    input  [2:0]                      S_AXI_FF_TEST_arprot,

    input [S_AXI_ADDR_WIDTH-1:0]      S_AXI_FF_TEST_awaddr,
    output                            S_AXI_FF_TEST_awready,
    input                             S_AXI_FF_TEST_awvalid,
    input  [2:0]                      S_AXI_FF_TEST_awprot,

    output  [1:0]                  	  S_AXI_FF_TEST_bresp,  
    input                             S_AXI_FF_TEST_bready,
    output                            S_AXI_FF_TEST_bvalid,

    output     [S_AXI_DATA_WIDTH-1:0] S_AXI_FF_TEST_rdata,
    input                             S_AXI_FF_TEST_rready,
    output                            S_AXI_FF_TEST_rvalid,
    output  [1:0]                     S_AXI_FF_TEST_rresp,

    input  [S_AXI_DATA_WIDTH-1:0]     S_AXI_FF_TEST_wdata,
    output                            S_AXI_FF_TEST_wready,
    input                             S_AXI_FF_TEST_wvalid,
    input  [S_AXI_DATA_WIDTH/8-1:0]   S_AXI_FF_TEST_wstrb,

    input shift_clk_in,
    input ps_done,
    output ps_en,
    output ps_incdec,
    output ps_clk,
    output proba_signal,
    output IDELAYCTRL_RST
    );
	

    wire                                      NATIVE_CLK;
    wire                                      NATIVE_EN;
    wire                                      NATIVE_WR;
    wire   [NATIVE_ADDR_WDITH-1: 0]           	   NATIVE_ADDR;
    wire   [NATIVE_DATA_WIDTH-1: 0]           				   NATIVE_DATA_IN;
    reg  [NATIVE_DATA_WIDTH-1: 0]	       			   NATIVE_DATA_OUT;
    reg                                NATIVE_READY;
    wire  [NATIVE_DATA_WIDTH-1: 0]	       			   NATIVE_DATA_OUT_IMP;
    wire                                NATIVE_READY_IMP;
    wire  [NATIVE_DATA_WIDTH-1: 0]	       			   NATIVE_DATA_OUT_FF;
    wire                                NATIVE_READY_FF;

    always @(*) begin
    	if(NATIVE_ADDR < 3) begin
    		NATIVE_DATA_OUT = NATIVE_DATA_OUT_FF;
    		NATIVE_READY = NATIVE_READY_FF;
    	end
    	else begin
    		NATIVE_DATA_OUT = NATIVE_DATA_OUT_IMP;
    		NATIVE_READY = NATIVE_READY_IMP;
    	end
    end
	AXI2NATIVE #(
		.NATIVE_ADDR_WDITH(NATIVE_ADDR_WDITH),
		.NATIVE_DATA_WIDTH(NATIVE_DATA_WIDTH),
		.S_AXI_ADDR_WIDTH(S_AXI_ADDR_WIDTH),
		.S_AXI_DATA_WIDTH(S_AXI_DATA_WIDTH)
	) inst_AXI2NATIVE (
		.S_AXI_aclk      (S_AXI_FF_TEST_aclk),
		.S_AXI_aresetn   (S_AXI_FF_TEST_aresetn),
		.S_AXI_araddr    (S_AXI_FF_TEST_araddr),
		.S_AXI_arready   (S_AXI_FF_TEST_arready),
		.S_AXI_arvalid   (S_AXI_FF_TEST_arvalid),
		.S_AXI_arprot    (S_AXI_FF_TEST_arprot),
		.S_AXI_awaddr    (S_AXI_FF_TEST_awaddr),
		.S_AXI_awready   (S_AXI_FF_TEST_awready),
		.S_AXI_awvalid   (S_AXI_FF_TEST_awvalid),
		.S_AXI_awprot    (S_AXI_FF_TEST_awprot),
		.S_AXI_bresp     (S_AXI_FF_TEST_bresp),
		.S_AXI_bready    (S_AXI_FF_TEST_bready),
		.S_AXI_bvalid    (S_AXI_FF_TEST_bvalid),
		.S_AXI_rdata     (S_AXI_FF_TEST_rdata),
		.S_AXI_rready    (S_AXI_FF_TEST_rready),
		.S_AXI_rvalid    (S_AXI_FF_TEST_rvalid),
		.S_AXI_rresp     (S_AXI_FF_TEST_rresp),
		.S_AXI_wdata     (S_AXI_FF_TEST_wdata),
		.S_AXI_wready    (S_AXI_FF_TEST_wready),
		.S_AXI_wvalid    (S_AXI_FF_TEST_wvalid),
		.S_AXI_wstrb     (S_AXI_FF_TEST_wstrb),
		.NATIVE_CLK      (NATIVE_CLK),
		.NATIVE_EN       (NATIVE_EN),
		.NATIVE_WR       (NATIVE_WR),
		.NATIVE_ADDR     (NATIVE_ADDR),
		.NATIVE_DATA_IN  (NATIVE_DATA_IN),
		.NATIVE_DATA_OUT (NATIVE_DATA_OUT),
		.NATIVE_READY    (NATIVE_READY)
	);

	wire imp_out;
	IMP_Core #(
		.REFCLK_FREQUENCY(REFCLK_FREQUENCY),
		.NATIVE_ADDR_WDITH(NATIVE_ADDR_WDITH),
		.NATIVE_DATA_WIDTH(NATIVE_DATA_WIDTH),
		.MODE(MODE),
		.Voltage_TEMP_Ctl(VTC)
	) inst_IMP_Core (
		.REFCLK          (REFCLK),
		.NATIVE_CLK      (NATIVE_CLK),
		.NATIVE_EN       (NATIVE_EN),
		.NATIVE_WR       (NATIVE_WR),
		.NATIVE_ADDR     (NATIVE_ADDR),
		.NATIVE_DATA_IN  (NATIVE_DATA_IN),
		.NATIVE_DATA_OUT (NATIVE_DATA_OUT_IMP),
		.NATIVE_READY    (NATIVE_READY_IMP),
		.rst_n           (rst_n),
		.square_in       (shift_clk_in),
		.imp_out         (imp_out),
		.lead            (),
		.lag             (),
		.IDELAYCTRL_RST  (IDELAYCTRL_RST)
	);

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
			.NATIVE_DATA_OUT (NATIVE_DATA_OUT_FF),
			.NATIVE_READY    (NATIVE_READY_FF),
			.proba_signal    (proba_signal),
			.rst_n           (rst_n),
			.imp_in          (imp_out),
			.ps_done         (ps_done),
			.ps_en           (ps_en),
			.ps_incdec       (ps_incdec),
			.ps_clk          (ps_clk)
		);

endmodule
