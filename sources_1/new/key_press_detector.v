`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/02 20:02:26
// Design Name: 
// Module Name: key_press_detector
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


module key_press_detector(
    input clk,
    input key_input,
    input rst_n,
    output reg long_press,
    output reg short_press
    );
    reg [31:0] press_count;
    reg key_prev;
    
    parameter LONG_PRESS_TIME = 32'd300000000;
    always @(posedge clk, negedge rst_n) begin
        if(~rst_n) begin
            press_count <= 0;
            short_press <= 0;
            long_press <= 0;
        end else begin
            if(key_input) begin
                press_count <= press_count + 1;
                if(press_count >= LONG_PRESS_TIME) begin
                    long_press <= 1;
                end
            end else if(!key_input && key_prev) begin
                if(press_count < LONG_PRESS_TIME) begin
                    short_press <= 1;
                end
                press_count <= 0;
                long_press <= 0;
            end else begin
                short_press <= 0;
                long_press <= 0;
            end
            key_prev <= key_input;
        end
    end
endmodule
