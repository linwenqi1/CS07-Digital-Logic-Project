`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/08 19:01:59
// Design Name: 
// Module Name: set_gesture_time
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


module set_gesture_time(
    input clk_100Hz,
    input rst_n,
    input adjust_en,
    input time_increment_press_once,//+1键
    input time_decrement_press_once,//-1键
    output reg [5:0] gesture_sec
    );
    always @(posedge clk_100Hz or negedge rst_n) begin
        if (~rst_n) begin
            gesture_sec <= 5;//调回默认的手势时间：5s
        end
        else if(adjust_en)begin
            if (time_increment_press_once) begin
                if (gesture_sec == 59) gesture_sec <= 0;
                else gesture_sec <= gesture_sec + 1; 
            end else if(time_decrement_press_once) begin
                if (gesture_sec == 0) gesture_sec <= 59;
                else gesture_sec <= gesture_sec - 1; 
            end
        end
        else begin
            gesture_sec <= gesture_sec;
        end
    end
endmodule
