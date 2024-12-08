`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/08 16:09:17
// Design Name: 
// Module Name: gesture
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


module gesture(
    input clk_100Hz,
    input rst_n,
    input is_standby,
    input reminder_duration_set_switch,
    input time_increment_press_once,//+1键
    input time_decrement_press_once,//-1键
    output reg [5:0] second_gesture
    );
    
    always @(posedge clk_100Hz or negedge rst_n) begin
        if (~rst_n) begin
            second_gesture <= 5;//调回默认的手势时间：5s
        end
        else if(is_standby & reminder_duration_set_switch)begin
            if (time_increment_press_once) begin
                if (second_gesture == 59)second_gesture <= 0;
                else second_gesture <= second_gesture + 1; 
            end else if(time_decrement_press_once) begin
                if (second_gesture == 0) second_gesture <= 59;
                else second_gesture <= second_gesture - 1; 
            end        
        end
        else begin
            second_gesture <= second_gesture;
        end
    end
    
    
endmodule
