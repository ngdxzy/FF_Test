`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.08.2020 17:28:56
// Design Name: 
// Module Name: IDELAY3_DRP
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


module IDELAY3_DRP #(
	parameter REFCLK_FREQUENCY       = 300,
	parameter MODE = "TIME",
	parameter Voltage_TEMP_Ctl = 1
	)(
		input clk,
		input rst_n,
		input data_in,
		output data_out,
		input change,
		input read,
		output reg done,
		input [8:0] delay_in,
		output reg [8:0] delay_out
    );

	reg [3:0] delay_counter;
	reg en_counter;
	reg delayed;
	wire [8:0] delaytmp;
	reg [2:0] state, nextstate;

	localparam IDLE 	= 3'd0;
	localparam DISABLEVTC = 3'd1;
	localparam WAITDISVTC = 3'd2;
	localparam LOAD_DELAY = 3'd3;
	localparam WAIT_STABLE = 3'd4;
	localparam EN_LOAD = 3'd5;
	localparam WAITCNDELAY = 3'd6;
	localparam DONE = 3'd7;

	reg load;
	reg en_vtc;


	always @(posedge clk or negedge rst_n) begin
		if (~rst_n) begin
			state <= IDLE;
		end
		else begin
			state <= nextstate;
		end
	end

	always @ (*) begin
		load = 0;
		done = 0;
		en_vtc = Voltage_TEMP_Ctl;
		en_counter = 0;
		nextstate = state;
		case(state)
			IDLE:begin
				if(change) begin
					nextstate = DISABLEVTC;
				end
				else if(read) begin
					nextstate = WAITCNDELAY;
				end
			end
			DISABLEVTC:begin
				en_vtc = 0;
				nextstate = WAITDISVTC;
			end
			WAITDISVTC:begin
				en_vtc = 0;
				en_counter = 1;
				if(delayed) begin
					nextstate = LOAD_DELAY;
				end
			end
			LOAD_DELAY:begin
				en_vtc = 0;
				nextstate = WAIT_STABLE;
			end
			WAIT_STABLE:begin
				en_vtc = 0;
				nextstate = EN_LOAD;
			end
			EN_LOAD:begin
				en_vtc = 0;
				load = 1;
				nextstate = WAITCNDELAY;
			end
			WAITCNDELAY:begin
				en_vtc = 0;
				en_counter = 1;
				if(delayed) begin
					nextstate = DONE;
				end
			end
			DONE:begin
				done = 1;
				nextstate = IDLE;
			end
		endcase
	end

	always @(posedge clk or negedge rst_n) begin
		if (~rst_n) begin
			delay_out <= 0;
		end
		else if(state == WAITCNDELAY) begin	
			delay_out <= delaytmp;
		end
	end

	IDELAYE3 #(
		.CASCADE("NONE"),               // Cascade setting (MASTER, NONE, SLAVE_END, SLAVE_MIDDLE)
		.DELAY_FORMAT(MODE),          // Units of the DELAY_VALUE (COUNT, TIME)
		.DELAY_SRC("DATAIN"),          // Delay input (DATAIN, IDATAIN)
		.DELAY_TYPE("VAR_LOAD"),           // Set the type of tap delay line (FIXED, VARIABLE, VAR_LOAD)
		.DELAY_VALUE(0),                // Input delay value setting
		.IS_CLK_INVERTED(1'b0),         // Optional inversion for CLK
		.IS_RST_INVERTED(1'b1),         // Optional inversion for RST
		.REFCLK_FREQUENCY(REFCLK_FREQUENCY),       // IDELAYCTRL clock input frequency in MHz (200.0-2667.0)
		.SIM_DEVICE("ULTRASCALE_PLUS"), // Set the device version (ULTRASCALE, ULTRASCALE_PLUS,
		                              // ULTRASCALE_PLUS_ES1, ULTRASCALE_PLUS_ES2)
		.UPDATE_MODE("ASYNC")           // Determines when updates to the delay will take effect (ASYNC, MANUAL,
		                              // SYNC)
	)
	IDELAYE3_Lead_inst (
		.CASC_OUT(),       // 1-bit output: Cascade delay output to ODELAY input cascade
		.CNTVALUEOUT(delaytmp), // 9-bit output: Counter value output
		.DATAOUT(data_out),         // 1-bit output: Delayed data output
		.CASC_IN(0),         // 1-bit input: Cascade delay input from slave ODELAY CASCADE_OUT
		.CASC_RETURN(0), // 1-bit input: Cascade delay returning from slave ODELAY DATAOUT
		.CE(0),                   // 1-bit input: Active high enable increment/decrement input
		.CLK(clk),                 // 1-bit input: Clock input
		.CNTVALUEIN(delay_in),   // 9-bit input: Counter value input
		.DATAIN(data_in),           // 1-bit input: Data input from the logic
		.EN_VTC(en_vtc),           // 1-bit input: Keep delay constant over VT
		.IDATAIN(0),         // 1-bit input: Data input from the IOBUF
		.INC(0),                 // 1-bit input: Increment / Decrement tap delay input
		.LOAD(load),               // 1-bit input: Load DELAY_VALUE input
		.RST(rst_n)                  // 1-bit input: Asynchronous Reset to the DELAY_VALUE
	);
	//delay component
	always @(posedge clk or negedge rst_n) begin
		if (~rst_n) begin
			// reset
			delay_counter <= 0;
			delayed <= 0;
		end
		else if (en_counter) begin
			if(delay_counter < 4'd15) begin
				delay_counter <= delay_counter + 1;
				delayed <= 0;
			end
			else begin
				delay_counter <= delay_counter;
				delayed <= 1;
			end
		end
		else begin
			delay_counter <= 0;
			delayed <= 0;
		end
	end
endmodule
