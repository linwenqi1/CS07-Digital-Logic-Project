`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/08 21:03:08
// Design Name: 
// Module Name: edge_detect_down_100Hz
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


module edge_detect_down_100Hz(
    input clk_100Hz,         // ʱ���ź�
    input rst_n,       // ��λ�ź�
    input key_in,      // �ȶ��İ����źţ�debounced��
    output reg release_once  // ���ɰ��������źţ�����һ�Σ�
    );
    reg key_in_dly;  // �����źŵ��ӳٰ汾

    always @(posedge clk_100Hz, negedge rst_n) begin
        if (~rst_n) begin
            key_in_dly <= 0;
            release_once <= 0;
        end else begin
            key_in_dly <= key_in;  // ������һ�����ڵİ����ź�

            // ��ⰴ�����½���
            if (~key_in && key_in_dly)
                release_once <= 1;  // ��������ʱ���� press_once �ź�
            else
                release_once <= 0;  // δ����ʱ��� press_once �ź�
        end
    end
endmodule
