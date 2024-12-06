`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/04 08:59:11
// Design Name: 
// Module Name: clk_div
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

module clk_div(
    input clk,
    input rst_n,
    output reg clk_500Hz,
    output reg clk_100Hz
    );
    parameter period1 = 200000;
    parameter period2 = 1000000;
    reg [31:0] cnt_500Hz;
    reg [31:0] cnt_100Hz;
    always @(posedge clk, negedge rst_n) begin
        if(~rst_n) begin
            cnt_500Hz <= 0;
            clk_500Hz <= 0;
            cnt_100Hz <= 0;
            clk_100Hz <= 0;
        end else begin
            if(cnt_500Hz == ((period1 >> 1) - 1)) begin
                clk_500Hz <= ~clk_500Hz;
                cnt_500Hz <= 0;
            end else begin
                cnt_500Hz <= cnt_500Hz + 1;
            end
            
            if(cnt_100Hz == ((period2 >> 1) - 1)) begin
                clk_100Hz <= ~clk_100Hz;
                    cnt_100Hz <= 0;
            end else begin
                cnt_100Hz <= cnt_100Hz + 1;
            end
        end
    end
endmodule

