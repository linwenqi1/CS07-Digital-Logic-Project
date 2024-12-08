`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/08 15:11:36
// Design Name: 
// Module Name: timeSet_display_module
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


module timeSet_display_module(
    input clk_500Hz,
    input rst_n,
    input [5:0] hour_threshold,
    input [5:0] min_threshold,
    input [5:0] second_gesture,
    input [1:0] adjust_state,
    input reminder_duration_set_switch,
    input gesture_time_set_switch,
    input is_standby, //��is_standby����en�ź�
    output reg [3:0] seg_en,
    output [7:0] seg_out
    );
    parameter ADJUST_MIN_REMINDER = 2'b00;
    parameter ADJUST_HOUR_REMINDER = 2'b01;
    reg [1:0] scan_cnt;
    reg [3:0] content_display [3:0];
    always @(adjust_state,is_standby,reminder_duration_set_switch,gesture_time_set_switch) begin
        if(is_standby) begin
        //�ĸ�����ܣ�������3210
        //�����3��ʾ��ǰ������ģʽ 1 2Ϊ������������ʱ���ķ��ӡ�Сʱ��3Ϊ��������ʱ��������
        //�����1��0������ʾʱ��
            if(reminder_duration_set_switch) begin
                case(adjust_state)    
                            ADJUST_MIN_REMINDER  : begin
                                content_display[0] =  min_threshold % 10;
                                content_display[1] =  min_threshold / 10;
                                content_display[2] = 4'h0 ;//��ʵʲô��������ʾ
                                content_display[3] = 4'h1;
                            end
                            ADJUST_HOUR_REMINDER : begin
                                content_display[0] =  hour_threshold % 10;
                                content_display[1] =  hour_threshold / 10;
                                content_display[2] = 4'h0 ;//��ʵʲô��������ʾ
                                content_display[3] = 4'h2;
                            end
                endcase
            end
            else if (gesture_time_set_switch) begin
                content_display[0] =  second_gesture % 10;
                content_display[1] =  second_gesture / 10;
                content_display[2] =  4'h0 ;//��ʵʲô��������ʾ
                content_display[3] = 4'h2;
                //todo
            end
            else begin
                content_display[0] = 4'h0;
                content_display[1] = 4'h0;
                content_display[2] = 4'h0;
                content_display[3] = 4'h0;
            end
        end
    end
    
    
    always @(posedge clk_500Hz, negedge rst_n) begin
            if(~rst_n)
                scan_cnt <= 0;
            else begin
                if(scan_cnt==3)
                    scan_cnt <= 0;
                else
                    scan_cnt <= scan_cnt + 1;
            end
        end
        always @(scan_cnt, is_standby) begin
            case({scan_cnt, is_standby})
                3'b001: seg_en=4'b0001;
                3'b011: seg_en=4'b0010;
                3'b101: seg_en=4'b0000; //fjm ����ģʽ�£������������ڶ����������Զ����ʾ
                3'b111: seg_en=4'b1000;
                default: seg_en=4'b0000;
            endcase
        end
        light_7seg_ego1 u1(.sw(content_display[scan_cnt]), .seg_out(seg_out), .dp(0));//fjm ����С���㲻��Ҫ��ʾ��dpֱ��Ϊ0����
endmodule
