`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/08 21:33:09
// Design Name: 
// Module Name: check_clean_finish
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


module check_clean_finish(
    input clk_100Hz,
    input rst_n,
    input self_clean,
    input manual_clean,
    output clean_finished
    );
    wire self_clean_finished, manual_clean_finished;
    edge_detect_down_100Hz detector5(.clk_100Hz(clk_100Hz), .rst_n(rst_n), .key_in(self_clean), .release_once(self_clean_finished));
    edge_detect_down_100Hz detector6(.clk_100Hz(clk_100Hz), .rst_n(rst_n), .key_in(manual_clean), .release_once(manual_clean_finished));
    assign clean_finished = self_clean_finished | manual_clean_finished;
endmodule
