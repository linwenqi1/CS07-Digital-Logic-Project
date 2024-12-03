`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/02 20:36:08
// Design Name: 
// Module Name: key_debounce
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


module key_debounce (
    input wire clk,            // 时钟信号
    input wire rst_n,          // 重置信号
    input wire key_in,         // 按键输入
    output reg key_out         // 去抖后的按键输出
);

    // 定义去抖的计数器宽度
    parameter DEBOUNCE_COUNT = 100000; // 计数器值，可以根据实际时钟频率调整

    // 定义计数器和状态寄存器
    reg [17:0] counter;        // 计数器
    reg key_in_sync_1, key_in_sync_2; // 同步寄存器，避免时钟抖动影响

    // 同步按键信号
    always @(posedge clk, negedge rst_n) begin
        if (~rst_n) begin
            key_in_sync_1 <= 1'b0;
            key_in_sync_2 <= 1'b0;
        end else begin
            key_in_sync_1 <= key_in;
            key_in_sync_2 <= key_in_sync_1;
        end
    end

    // 按键去抖逻辑
    always @(posedge clk, negedge rst_n) begin
        if (~rst_n) begin
            counter <= 18'b0;
            key_out <= 1'b0;
        end else begin
            if (key_in_sync_2 != key_out) begin
                counter <= counter + 1;
                if (counter == DEBOUNCE_COUNT) begin
                    key_out <= key_in_sync_2; // 更新输出
                    counter <= 0; // 重置计数器
                end
            end else begin
                counter <= 0; // 如果按键没有变化，重置计数器
            end
        end
    end
endmodule

