`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/07 16:46:57
// Design Name: 
// Module Name: clean_reminder
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


module clean_reminder(
    input clk_100Hz,
    input rst_n,
    input is_standby,
    input [5:0] hour_threshold,
    input [5:0] min_threshold,
    input [5:0] sec_threshold,
    input [5:0] working_hour,
    input [5:0] working_min,
    input [5:0] working_sec,
    output reg warning
    );
    always @(posedge clk_100Hz, negedge rst_n) begin
        if(~rst_n) begin
            warning <= 0;
        end else begin
            if (is_standby) begin
                // Compare working time with threshold
                if ((working_hour > hour_threshold) ||
                    (working_hour == hour_threshold && working_min > min_threshold) ||
                    (working_hour == hour_threshold && working_min == min_threshold && working_sec > sec_threshold)) begin
                    warning <= 1;
                end
                else begin
                    warning <= 0;
                end
            end
            else begin
                warning <= 0;
            end
        end
    end
endmodule
