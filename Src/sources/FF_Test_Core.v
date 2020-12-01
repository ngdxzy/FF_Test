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


module FF_Test_Core#(
    parameter NATIVE_ADDR_WDITH       = 3,
    parameter NATIVE_DATA_WIDTH       = 32,
	parameter M = 32'd10000
	)(
	input 										REFCLK,
    input                                      NATIVE_CLK,
    input                                      NATIVE_EN,
    input                                      NATIVE_WR,
    input   [NATIVE_ADDR_WDITH-1: 0]           NATIVE_ADDR,
    input   [NATIVE_DATA_WIDTH-1: 0]           NATIVE_DATA_IN,
    output  reg [NATIVE_DATA_WIDTH-1: 0]	       NATIVE_DATA_OUT,
    output  reg                                NATIVE_READY,
    (* dont_touch="true" *)(* max_fanout=2 *)output reg proba_signal,
    input rst_n,
    input imp_in,
    input ps_done,
    output ps_en,
    output ps_incdec,
    output ps_clk
    );
	
	(* dont_touch="true" *)(* max_fanout=1 *)(* ASYNC_REG="true" *)reg ff_dut;
	(* dont_touch="true" *)(* max_fanout=2 *)(* ASYNC_REG="true" *)reg synchronizer;
	wire [NATIVE_DATA_WIDTH-1: 0] Probability;
	reg InitValue;
	wire load_init;
	wire start_test;
	reg test_done;
	always @ (posedge NATIVE_CLK) begin
		case(NATIVE_ADDR)
			3'b000: begin
				NATIVE_READY <= NATIVE_WR?ps_done:NATIVE_EN;
			end
			3'b001: begin
				NATIVE_READY <= NATIVE_EN;
			end
			3'b010: begin
				NATIVE_READY <= NATIVE_WR?NATIVE_EN:test_done;
			end
			default: begin
				NATIVE_READY <= NATIVE_EN;
			end
		endcase
	end
	
	assign ps_incdec = NATIVE_DATA_IN[0];

	assign ps_en      = (NATIVE_ADDR == 3'b000) & (NATIVE_EN == 1'b1) & (NATIVE_WR == 1'b1);
	assign load_init  = (NATIVE_ADDR == 3'b001) & (NATIVE_EN == 1'b1) & (NATIVE_WR == 1'b1);
	assign start_test = (NATIVE_ADDR == 3'b010) & (NATIVE_EN == 1'b1) & (NATIVE_WR == 1'b0);

	always @ (posedge NATIVE_CLK) begin
		case(NATIVE_ADDR)
			3'b000: begin
				NATIVE_DATA_OUT <= 0;
			end
			3'b001: begin
				NATIVE_DATA_OUT <= {31'd0,InitValue};
			end
			3'b010: begin
				NATIVE_DATA_OUT <= Probability;
			end
			default: begin
				NATIVE_DATA_OUT <= 32'd12345678;
			end
		endcase
	end

	always @ (posedge NATIVE_CLK) begin
		if(load_init) begin
			InitValue <= NATIVE_DATA_IN[0];
		end
	end


	localparam IDLE = 4'd0;
	localparam INIT = 4'd1;
	localparam RSTR = 4'd2;
	localparam META = 4'd3;
	localparam SAMP = 4'd4;
	localparam CONT = 4'd5;
	localparam DONE = 4'd6;

	reg [3:0] state, nextstate;

	reg start_counter;
	reg rst_dut;
	reg probe_dut;
	reg sample_dut;
	reg count_dut;

	wire counter_done;

	always @ (posedge NATIVE_CLK or negedge rst_n) begin
		if(~rst_n) begin
			state <= IDLE;
		end
		else begin
			state <= nextstate;
		end
	end

	always @ (*) begin
		nextstate = state;
		rst_dut = 0;
		probe_dut = 0;
		sample_dut = 0;
		count_dut = 0;
		test_done = 0;
		start_counter = 0;
		case(state)
			IDLE: begin
				if (start_test == 1'd1) begin
					nextstate = INIT;
				end
			end
			INIT: begin
				start_counter = 1;
				nextstate = RSTR;
			end
			RSTR: begin
				rst_dut = 1;
				start_counter = 1;
				if(~counter_done) begin
					nextstate = META;
				end
				else begin
					nextstate = DONE;
				end
			end
			META: begin
				start_counter = 1;
				probe_dut = 1;
				nextstate = CONT;
			end
			CONT: begin
				start_counter = 1;
				count_dut = 1;
				nextstate = RSTR;
			end
			DONE: begin			
				start_counter = 1;
				test_done = 1;
				nextstate = IDLE;
			end
		endcase
	end

	ETS_Adder inst_Probability_Counter(
		.clk(NATIVE_CLK),
		.reset(~rst_n),
		.Average(M),

		.data_in(synchronizer),
		.data(Probability),
		.en_count(count_dut),

		.start(start_counter),
		.done(counter_done)
    );

	//Experiment part

	always @ (*) begin
		case({rst_dut,probe_dut})
			2'b10:begin
				proba_signal = InitValue;
			end
			2'b01:begin
				proba_signal = imp_in;
			end
			default: begin
				proba_signal = 0;
			end
		endcase
	end

	always @ (negedge NATIVE_CLK) begin
		ff_dut <= proba_signal;
	end

	always @ (posedge NATIVE_CLK) begin
		if(probe_dut) begin
			synchronizer <= ff_dut;
		end
	end

	assign ps_clk = NATIVE_CLK;
endmodule
