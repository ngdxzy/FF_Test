`timescale 1ns / 1ps
// hello
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/03/2019 03:10:40 PM
// Design Name: 
// Module Name: ETS_Adder
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

module adder_8(
	input clk,
	input rst_n,
	output reg [7:0] counter,
	output C,
	input en,
	input clr
    );

	always @ (posedge clk or negedge rst_n) begin
		if(~rst_n) begin
			counter <= 0;
		end
		else begin
			if(clr) begin
				counter <= 0;
			end
			else begin
				if(en) begin
					counter <= counter + 1;
				end
			end
		end
	end

	assign  C = (counter == 8'hff) & en & (~clr);
endmodule




module Counter_32 (
	input clk,
	input rst_n,
	input clr,
	input en,
	input [31:0] cmp_data,
	output [31:0]data_out,
	output full
    );

	wire [31:0] counter;
	wire C_7_8;
	wire C_15_16;
	wire C_23_24;

	adder_8 inst_adder_7_0 (.clk(clk), .rst_n(rst_n), .counter(counter[7:0]), .C(C_7_8), .en(en), .clr(clr));
	adder_8 inst_adder_15_8 (.clk(clk), .rst_n(rst_n), .counter(counter[15:8]), .C(C_15_16), .en(en & C_7_8), .clr(clr));
	adder_8 inst_adder_23_16 (.clk(clk), .rst_n(rst_n), .counter(counter[23:16]), .C(C_23_24), .en(en & C_15_16), .clr(clr));
	adder_8 inst_adder_31_24 (.clk(clk), .rst_n(rst_n), .counter(counter[31:24]), .C(), .en(en & C_23_24), .clr(clr));

	wire cmp_0 = counter[7:0] >= cmp_data[7:0];
	wire cmp_1 = counter[15:8] >= cmp_data[15:8];
	wire cmp_2 = counter[23:16] >= cmp_data[23:16];
	wire cmp_3 = counter[31:24] >= cmp_data[31:24];
	assign data_out = counter;
	assign full = cmp_3 & cmp_2 & cmp_1 & cmp_0;
endmodule

module ETS_Adder(
	input clk,
	input reset,
	input [31:0] Average,

	input data_in,
	output [31:0] data,
	input en_count,

	input start,
	output reg done
    );

	localparam IDLE = 2'b00;
	localparam BUSY = 2'b01;
	localparam DONE = 2'b10;
	localparam CLR  = 2'b11;
	reg clr;
	reg en;
	wire finish;
	reg [1:0]state,next_state;
	always @(posedge clk or posedge reset) begin
		if(reset) begin
			state <= IDLE;
		end
		else begin
			state <= next_state;
		end
	end

	always @ (*) begin
		clr = 0;
		done = 0;
		en = 0;
		next_state = state;
		case(state)
		IDLE:begin
			if(start) begin
				next_state = BUSY;
			end
		end
		BUSY:begin
			en = 1;
			if(finish) begin
				next_state = DONE;
			end
		end
		DONE:begin
			done = 1;
			if(~start) begin
				next_state = CLR;
			end
		end
		CLR:begin
			clr = 1;
			next_state = IDLE;
		end
		endcase
	end
	wire run_enable = en & en_count;
	Counter_32 U_Counter_d(
		.clk(clk),
		.rst_n(~reset),
		.clr(clr),
		.en(run_enable && data_in),
		.cmp_data(0),
		.data_out(data),
		.full()
    );
	Counter_32 U_Counter(
		.clk(clk),
		.rst_n(~reset),
		.clr(clr),
		.en(run_enable),
		.cmp_data(Average - 1),
		.data_out(),
		.full(finish)
    );

endmodule
