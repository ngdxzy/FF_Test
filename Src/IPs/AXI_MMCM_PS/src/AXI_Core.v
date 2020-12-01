`timescale 1ns/1ns

module AXI_MMCM_PS #(
    parameter NATIVE_ADDR_WDITH       = 1,                
    parameter NATIVE_DATA_WIDTH       = 32,
    parameter S_AXI_ADDR_WIDTH     = 3,               
    parameter S_AXI_DATA_WIDTH     = 32
)(

    //--------------  AXI Interface Signals         --------------
    input                             S_AXI_aclk,
    input                             S_AXI_aresetn,

    input  [S_AXI_ADDR_WIDTH-1:0]                   S_AXI_araddr,
    output reg                        S_AXI_arready,
    input                             S_AXI_arvalid,
    input  [2:0]                      S_AXI_arprot,

    input [S_AXI_ADDR_WIDTH-1:0]                    S_AXI_awaddr,
    output reg                        S_AXI_awready,
    input                             S_AXI_awvalid,
    input  [2:0]                      S_AXI_awprot,

    output  [1:0]                  S_AXI_bresp,  
    input                             S_AXI_bready,
    output reg                        S_AXI_bvalid,

    output reg [S_AXI_DATA_WIDTH-1:0] S_AXI_rdata,
    input                             S_AXI_rready,
    output reg                        S_AXI_rvalid,
    output  [1:0]                  S_AXI_rresp,

    input  [S_AXI_DATA_WIDTH-1:0]     S_AXI_wdata,
    output                         S_AXI_wready,
    input                             S_AXI_wvalid,
    input  [S_AXI_DATA_WIDTH/8-1:0]   S_AXI_wstrb,

    //-------------- PS Port  --------------
    output ps_clk,
    output ps_incdec,
    output ps_en,
    input  ps_done
); // drp_bridge
    wire                                      NATIVE_CLK;
    reg                                    NATIVE_EN;
    wire                                      NATIVE_WR;
    wire    [NATIVE_ADDR_WDITH-1: 0]             NATIVE_ADDR;
    reg [NATIVE_DATA_WIDTH-1: 0]             NATIVE_DATA_IN;
    reg  [NATIVE_DATA_WIDTH-1: 0]                NATIVE_DATA_OUT;
    wire                                       NATIVE_READY;
    reg [NATIVE_ADDR_WDITH-1:0] addr;

    assign ps_clk = NATIVE_CLK;
    assign ps_incdec = NATIVE_DATA_IN[0];
    assign ps_en = NATIVE_EN & NATIVE_WR;
    assign NATIVE_READY = ps_done;
    always @ (posedge S_AXI_aclk or negedge S_AXI_aresetn) begin
        if(!S_AXI_aresetn) begin
            addr <= {NATIVE_ADDR_WDITH{1'b0}};
        end
        else begin
            case({(S_AXI_arvalid & (~S_AXI_arready)),(S_AXI_awvalid & (~S_AXI_awready))})
                2'b00: begin addr <= addr; end
                2'b01: begin addr <= S_AXI_awaddr[NATIVE_ADDR_WDITH + 1:2]; end
                2'b10: begin addr <= S_AXI_araddr[NATIVE_ADDR_WDITH + 1:2]; end
                2'b11: begin addr <= addr; end
            endcase
        end
    end
    assign NATIVE_ADDR = addr;
    // Write/Read
    
    reg wr;
    always @ (posedge S_AXI_aclk or negedge S_AXI_aresetn) begin
        if(~S_AXI_aresetn) begin
            wr <= 1'b0;
        end
        else begin
            case({(S_AXI_arvalid & (~S_AXI_arready)),(S_AXI_awvalid & (~S_AXI_awready))})
                2'b00: begin wr <= wr; end
                2'b01: begin wr <= 1'b1; end
                2'b10: begin wr <= 1'b0; end
                2'b11: begin wr <= wr; end
            endcase
        end
    end

    //AW Channel
    always @ (posedge S_AXI_aclk or negedge S_AXI_aresetn) begin
        if(~S_AXI_aresetn) begin
            S_AXI_awready <= 1'b0;
        end
        else begin
            if(S_AXI_awvalid && (~S_AXI_awready) && S_AXI_wvalid) begin
                S_AXI_awready <= 1;
            end
            else begin
                S_AXI_awready <= 0;
            end
        end
    end

    //W Channel
    assign S_AXI_wready = wr?NATIVE_READY:1'b0;

    always @ (posedge S_AXI_aclk or negedge S_AXI_aresetn) begin
        if(~S_AXI_aresetn) begin
            NATIVE_DATA_IN <= 'b0;
        end
        else begin
            if(S_AXI_wvalid && S_AXI_awvalid && (~S_AXI_awready)) begin
                NATIVE_DATA_IN <= S_AXI_wdata[NATIVE_DATA_WIDTH-1:0];
            end
            else begin
                NATIVE_DATA_IN <= NATIVE_DATA_IN;
            end
        end
    end

    //wrsp channel
    assign S_AXI_bresp = 2'b00;
    always @ (posedge S_AXI_aclk or negedge S_AXI_aresetn) begin
        if(~S_AXI_aresetn) begin
            S_AXI_bvalid <= 0;
        end
        else begin
            if(NATIVE_READY && wr && (~S_AXI_bvalid)) begin
                S_AXI_bvalid <= 1'b1;
            end
            else begin
                if(S_AXI_bvalid && S_AXI_bready) begin
                    S_AXI_bvalid <= 1'b0;
                end
            end
        end
    end

    //AR channel

    always @ (posedge S_AXI_aclk or negedge S_AXI_aresetn) begin
        if(~S_AXI_aresetn) begin
            S_AXI_arready <= 1'b0;
        end
        else begin
            if(S_AXI_arvalid && (~S_AXI_arready)) begin
                S_AXI_arready <= 1;
            end
            else begin
                S_AXI_arready <= 0;
            end
        end
    end

    //R Channel
    assign S_AXI_rresp = 2'b00;
    always @ (posedge S_AXI_aclk or negedge S_AXI_aresetn) begin
        if(~S_AXI_aresetn) begin
            S_AXI_rdata <= 'b0;
            S_AXI_rvalid <= 1'b0;
        end
        else begin
            if((~wr) && (~S_AXI_rvalid)) begin
                S_AXI_rdata <= {'b0,NATIVE_DATA_OUT};
                S_AXI_rvalid <= 1'b1;
            end
            else if(S_AXI_rvalid && S_AXI_rready) begin
                S_AXI_rdata <= S_AXI_rdata;
                S_AXI_rvalid <= 1'b0;
            end
        end
    end
    //
    //en 

    always @ (posedge S_AXI_aclk or negedge S_AXI_aresetn) begin
        if(~S_AXI_aresetn) begin
            NATIVE_EN <= 0;
        end
        else begin
            if(S_AXI_arvalid && (~S_AXI_arready)) begin
                NATIVE_EN <= 1;
            end
            else if(S_AXI_awvalid && (~S_AXI_awready) && S_AXI_wvalid) begin               
                NATIVE_EN <= 1;
            end
            else begin
                NATIVE_EN <= 0;
            end
        end
    end
    assign NATIVE_WR = wr;
    assign NATIVE_CLK = S_AXI_aclk;

    always @ (posedge S_AXI_aclk or negedge S_AXI_aresetn) begin
        if(~S_AXI_aresetn) begin
            NATIVE_DATA_OUT <= 0;
        end
        else if (NATIVE_EN && NATIVE_WR) begin
            if(ps_incdec) begin
            	NATIVE_DATA_OUT <= NATIVE_DATA_OUT + 1;
            end
            else begin
            	NATIVE_DATA_OUT <= NATIVE_DATA_OUT + 32'hffffffff;
            end
        end
    end

endmodule
