`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/08 00:05:50
// Design Name: 
// Module Name: uart_tx
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


module uart_tx(
    input clk,                 // 时钟信号
    input rst_n,               // 复位信号            // UART TX 输出
    input [5:0] current_hour, 
    input [5:0] current_min, 
    input [5:0] current_sec,  // 当前时间
    input [5:0] working_hour, 
    input [5:0] working_min, 
    input [5:0] working_sec,  // 工作时间
    input [2:0] state,  // 系统状态
    output reg tx 
    );
    reg ready;
    // 波特率控制，假设波特率为 9600
    parameter BAUD_RATE = 9600;
    parameter CLK_FREQ = 100000000;  // 时钟频率为 100 MHz
    parameter DIVISOR = CLK_FREQ / BAUD_RATE;

    reg [20:0] counter;         // 波特率计数器
    reg [7:0] data;            // 要发送的数据
    reg [3:0] bit_index;       // 发送数据位的索引
    reg sending;               // 是否正在发送数据
    reg [3:0] byte_index;
    // 初始状态
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            tx <= 1;             // 默认空闲状态（高电平）
            ready <= 1;
            counter <= 0;
            bit_index <= 0;
            sending <= 0;
            byte_index <= 0;
            data <= 8'b11111111;  //起始符
        end else begin
            if (sending) begin
                if (counter == DIVISOR - 1) begin
                    counter <= 0;

                    // 发送起始位
                    if (bit_index == 0) begin
                        tx <= 0;   // 起始位为低电平（0）
                    end 
                    // 发送数据位
                    else if(bit_index < 9) begin
                        tx <= data[bit_index - 1];
                    end
                    else if (bit_index == 9) begin
                        tx <= 1;   // 停止位为高电平（1）
                    end
                    // 更新 bit_index 和数据
                    if (bit_index == 9) begin
                        bit_index <= 0;     // 完成一个字节，重置位索引
                        sending <= 0;       // 数据发送完毕
                        ready <= 1;         // 发送完毕，准备下一次发送
                        case(byte_index)
                            0: data <= {5'b0, state};
                            1: data <= {2'b0, current_hour};
                            2: data <= {2'b0, current_min};
                            3: data <= {2'b0, current_sec};
                            4: data <= {2'b0, working_hour};
                            5: data <= {2'b0, working_min};
                            6: data <= {2'b0, working_sec};
                            default: data <= 8'b11111111;
                        endcase
                        if(byte_index == 7)
                            byte_index <= 0;
                        else
                            byte_index <= byte_index + 1;  // 切换到下一个字符
                    end else begin
                        bit_index <= bit_index + 1; // 继续发送下一个位
                    end
                end else begin
                    counter <= counter + 1;
                end
            end else if (ready) begin
                sending <= 1;    // 开始发送数据
                ready <= 0;      // 发送中
            end
        end
    end
endmodule

