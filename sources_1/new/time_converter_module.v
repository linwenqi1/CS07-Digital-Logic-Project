`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/05 23:09:23
// Design Name: 
// Module Name: time_converter_module
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


module time_converter_module(
    input clk_500Hz,
    input rst_n,
    input [63:0] total_seconds,
    output reg[5:0] seconds,
    output reg [5:0] minutes,
    output reg [5:0] hours
    );
    always @(posedge clk_500Hz, negedge rst_n) begin
        if(~rst_n) begin
            seconds <= 0;
            minutes <= 0;
            hours <= 0;
        end else begin
            hours <= total_seconds / 3600;  
            minutes <= (total_seconds % 3600) / 60;
            seconds <= total_seconds % 60;
        end
    end
endmodule
