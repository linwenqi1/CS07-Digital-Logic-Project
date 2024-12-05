`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/05 13:11:36
// Design Name: 
// Module Name: display_module
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


module display_module(
    input clk_500Hz,
    input rst_n,
    input en,
    input [3:0] content_0,
    input [3:0] content_1,
    input [3:0] content_2,
    input [3:0] content_3,
    output reg [3:0] seg_en,
    output [7:0] seg_out
    );
    reg [1:0] scan_cnt;
    reg [3:0] content_display;
    always @(posedge clk_500Hz, negedge rst_n) begin
        if(~rst_n) begin
            scan_cnt <= 0;
        end
        else begin
            if(scan_cnt==3)
                scan_cnt <= 0;
            else
                scan_cnt <= scan_cnt + 1;
        end
    end
    always @(scan_cnt, en) begin
        case({en, scan_cnt})
            3'b100: begin
                seg_en=4'b0001;
                content_display = content_0;
            end
            3'b101: begin
                seg_en=4'b0010;
                content_display = content_1;
            end
            3'b110: begin
                seg_en=4'b0100;
                content_display = content_2;
            end
            3'b111: begin
                seg_en=4'b1000;
                content_display = content_3;
            end
            default: begin
                seg_en=4'b0000;
                content_display = 0;
            end
        endcase
    end
    light_7seg_ego1 u0(.sw(content_display), .seg_out(seg_out));
endmodule
