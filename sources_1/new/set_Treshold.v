`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/08 13:47:33
// Design Name: 
// Module Name: set_Treshold
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


module set_Treshold(
    input [5:0] in_hour_threshold,
    input [5:0] in_min_threshold,
    input [5:0] in_sec_threshold,
    input rst_n,
    input is_standby,
    input reminder_duration_set_switch,
    input unit_toggle_press_once,
    input time_increment_button,//+1¼ü
    input time_decrement_button,//-1¼ü
    output [5:0] out_in_hour_threshold,
    output [5:0] out_min_threshold,
    output [5:0] out_sec_threshold
    );
    
    always @(*)begin
        if (~rst_n) begin
        
        end
    
    
    end
    
endmodule
