`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/04 11:55:02
// Design Name: 
// Module Name: time_display_module
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


module time_display_module(
    input clk_500Hz,
    input rst_n,
    input switch1,
    input switch2,
    input en,
    input [5:0] power_on_hour,
    input [5:0] power_on_min,
    input [5:0] power_on_sec,
    input [5:0] working_hour,
    input [5:0] working_min,
    input [5:0] working_sec,
    output reg [3:0] seg_en,
    output [7:0] seg_out
    );
    reg [1:0] scan_cnt;
    reg [3:0] content_display [3:0];
    always @(switch1, switch2) begin
        case({switch1, switch2})
            2'b00: begin
                content_display[0] = power_on_sec % 10;
                content_display[1] = power_on_sec / 10;
                content_display[2] = power_on_min % 10;
                content_display[3] = power_on_min / 10;
            end
            2'b01: begin
                content_display[0] = working_sec % 10;
                content_display[1] = working_sec / 10;
                content_display[2] = working_min % 10;
                content_display[3] = working_min / 10;
            end
            2'b10: begin
                content_display[0] = power_on_min % 10;
                content_display[1] = power_on_min / 10;
                content_display[2] = power_on_hour % 10;
                content_display[3] = power_on_hour / 10;
            end
            2'b11: begin
                content_display[0] = working_min % 10;
                content_display[1] = working_min / 10;
                content_display[2] = working_hour % 10;
                content_display[3] = working_hour / 10;
            end
        endcase
    end
    always @(posedge clk_500Hz, negedge rst_n) begin
        if(~rst_n)
            scan_cnt <= 0;
        else begin
            if(scan_cnt==3)
                scan_cnt <= 0;
            else
                scan_cnt <= scan_cnt + 1;
        end
    end
    always @(scan_cnt, en) begin
        case({scan_cnt, en})
            3'b001: seg_en=4'b0001;
            3'b011: seg_en=4'b0010;
            3'b101: seg_en=4'b0100;
            3'b111: seg_en=4'b1000;
            default: seg_en=4'b0000;
        endcase
    end
    light_7seg_ego1 u0(.sw(content_display[scan_cnt]), .seg_out(seg_out));
endmodule
