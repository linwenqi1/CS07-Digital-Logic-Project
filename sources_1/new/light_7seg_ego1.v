`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/04 12:12:12
// Design Name: 
// Module Name: light_7seg_ego1
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


module light_7seg_ego1(
    input [3:0]sw, output reg [7:0] seg_out
    );
    always @(*) begin
        case(sw)
            4'h0: seg_out = 8'b11111100;
            4'h1: seg_out = 8'b01100000;
            4'h2: seg_out = 8'b11011010;
            4'h3: seg_out = 8'b11110010;
            4'h4: seg_out = 8'b01100110;
            4'h5: seg_out = 8'b10110110;
            4'h6: seg_out = 8'b10111110;
            4'h7: seg_out = 8'b11100000;
            4'h8: seg_out = 8'b11111110;
            4'h9: seg_out = 8'b11110110;
            default: seg_out = 8'b00000000;
        endcase
    end
endmodule

