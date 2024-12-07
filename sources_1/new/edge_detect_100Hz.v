`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/06 19:01:29
// Design Name: 
// Module Name: edge_detect_100Hz
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


module edge_detect_100Hz(
    input clk_100Hz,         // 时钟信号
    input rst_n,       // 复位信号
    input key_in,      // 稳定的按键信号（debounced）
    output reg press_once  // 生成按键按下信号（按下一次）
    );
    reg key_in_dly;  // 按键信号的延迟版本

    always @(posedge clk_100Hz, negedge rst_n) begin
        if (~rst_n) begin
            key_in_dly <= 0;
            press_once <= 0;
        end else begin
            key_in_dly <= key_in;  // 保存上一个周期的按键信号

            // 检测按键的上升沿
            if (key_in && ~key_in_dly)
                press_once <= 1;  // 按键按下时生成 press_once 信号
            else
                press_once <= 0;  // 未按下时清除 press_once 信号
        end
    end
endmodule

