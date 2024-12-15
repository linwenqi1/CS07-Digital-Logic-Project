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
    input clk,                 // ʱ���ź�
    input rst_n,               // ��λ�ź�            // UART TX ���
    input [5:0] current_hour, 
    input [5:0] current_min, 
    input [5:0] current_sec,  // ��ǰʱ��
    input [5:0] working_hour, 
    input [5:0] working_min, 
    input [5:0] working_sec,  // ����ʱ��
    input [5:0] count_down_hour,
    input [5:0] count_down_min,
    input [5:0] count_down_sec,
    input [5:0] hour_threshold,
    input [5:0] min_threshold,
    input [5:0] sec_threshold,
    input light_on,
    input [2:0] state,  // ϵͳ״̬
    output reg tx 
    );
    reg ready;
    // �����ʿ��ƣ����貨����Ϊ 9600
    parameter BAUD_RATE = 9600;
    parameter CLK_FREQ = 100000000;  // ʱ��Ƶ��Ϊ 100 MHz
    parameter DIVISOR = CLK_FREQ / BAUD_RATE;

    reg [20:0] counter;         // �����ʼ�����
    reg [7:0] data;            // Ҫ���͵�����
    reg [3:0] bit_index;       // ��������λ������
    reg sending;               // �Ƿ����ڷ�������
    reg [3:0] byte_index;
    // ��ʼ״̬
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            tx <= 1;             // Ĭ�Ͽ���״̬���ߵ�ƽ��
            ready <= 1;
            counter <= 0;
            bit_index <= 0;
            sending <= 0;
            byte_index <= 0;
            data <= 8'b11111111;  //��ʼ��
        end else begin
            if (sending) begin
                if (counter == DIVISOR - 1) begin
                    counter <= 0;

                    // ������ʼλ
                    if (bit_index == 0) begin
                        tx <= 0;   // ��ʼλΪ�͵�ƽ��0��
                    end 
                    // ��������λ
                    else if(bit_index < 9) begin
                        tx <= data[bit_index - 1];
                    end
                    else if (bit_index == 9) begin
                        tx <= 1;   // ֹͣλΪ�ߵ�ƽ��1��
                    end
                    // ���� bit_index ������
                    if (bit_index == 9) begin
                        bit_index <= 0;     // ���һ���ֽڣ�����λ����
                        sending <= 0;       // ���ݷ������
                        ready <= 1;         // ������ϣ�׼����һ�η���
                        case(byte_index)
                            0: data <= {5'b0, state};
                            1: data <= {2'b0, current_hour};
                            2: data <= {2'b0, current_min};
                            3: data <= {2'b0, current_sec};
                            4: data <= {2'b0, working_hour};
                            5: data <= {2'b0, working_min};
                            6: data <= {2'b0, working_sec};
                            7: data <= {2'b0, count_down_hour};
                            8: data <= {2'b0, count_down_min};
                            9: data <= {2'b0, count_down_sec};
                            10: data <= {2'b0, hour_threshold};
                            11: data <= {2'b0, min_threshold};
                            12: data <= {2'b0, sec_threshold};
                            13: data <= {7'b0, light_on};
                            default: data <= 8'b11111111;
                        endcase
                        if(byte_index == 14)
                            byte_index <= 0;
                        else
                            byte_index <= byte_index + 1;  // �л�����һ���ַ�
                    end else begin
                        bit_index <= bit_index + 1; // ����������һ��λ
                    end
                end else begin
                    counter <= counter + 1;
                end
            end else if (ready) begin
                sending <= 1;    // ��ʼ��������
                ready <= 0;      // ������
            end
        end
    end
endmodule

