`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/07 16:46:57
// Design Name: 
// Module Name: clean_reminder
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


module clean_reminder(
    input clk_100Hz,
    input rst_n,
    input is_standby,
    input [5:0] working_hour,
    input [5:0] working_min,
    input [5:0] working_sec,
    //fjm
    input reminder_duration_set_switch,
    input unit_toggle_press_once,
    input time_increment_press_once,//+1��
    input time_decrement_press_once,//-1��
    output reg [5:0] hour_threshold,
    output reg [5:0] min_threshold,
    output reg [1:0] adjust_state,//00 01�ǵ����������ѵķ���Сʱ�������ģ�飩
    ///---
    output reg warning
    );
    parameter ADJUST_MIN = 2'b00;
    parameter ADJUST_HOUR = 2'b01;
    reg [1:0] adjust_next_state;
    reg [5:0] sec_threshold = 5'b0;//fjm sec�������������ʾ��ֱ��Ĭ��Ϊ0
    
    //fjm
    always @(posedge clk_100Hz or negedge rst_n) begin
            if (~rst_n)
                begin
                adjust_state <= ADJUST_MIN;  // ��λ���ص�������ģʽ
                end
            else
                begin
                adjust_state <= adjust_next_state;
                end
    end
        
    always @(*) begin
        case(adjust_state)
             ADJUST_MIN :begin
                if(unit_toggle_press_once)
                    adjust_next_state = ADJUST_HOUR;
                else
                    adjust_next_state = ADJUST_MIN;
             end
             
             ADJUST_HOUR:begin
                if(unit_toggle_press_once)
                    adjust_next_state = ADJUST_MIN;
                else
                    adjust_next_state = ADJUST_HOUR;
             end
        endcase
    end
    //---
    
    
    always @(posedge clk_100Hz, negedge rst_n) begin
        if(~rst_n) begin
            warning <= 0;
            hour_threshold <= 0;//����Ĭ�ϵ���������ʱ�䣺0Сʱ1����
            min_threshold <= 1;
        end else begin
            if (is_standby) begin
                //�����ڴ���״̬
                // Compare working time with threshold
                if (~reminder_duration_set_switch) begin
                    //��reminder_duration_set_switchû�б��򿪣��������ж�
                    if ((working_hour > hour_threshold) ||
                                    (working_hour == hour_threshold && working_min > min_threshold) ||
                                    (working_hour == hour_threshold && working_min == min_threshold && working_sec > sec_threshold)) begin
                    warning <= 1;
                    end
                    else begin
                    warning <= 0;
                   end
                end
                else begin
                    //fjm ��reminder_duration_set_switch����,��ֹͣ�жϣ���������ʱ������ģʽ
                    warning <= 0;
                    if(adjust_state == ADJUST_MIN)begin
                        if (time_increment_press_once) begin
                            if (min_threshold == 59) min_threshold <= 0;
                            else min_threshold <= min_threshold + 1; // ��������
                        end else if(time_decrement_press_once) begin
                            if (min_threshold == 0) min_threshold <= 59;
                            else min_threshold <= min_threshold - 1; // ��������
                        end
                    end
                    else if(adjust_state == ADJUST_HOUR)begin
                        if (time_increment_press_once) begin
                            if (hour_threshold == 23) hour_threshold <= 0;
                            else hour_threshold <= hour_threshold + 1; // ����Сʱ
                        end else if(time_decrement_press_once) begin
                            if (hour_threshold == 0) hour_threshold <= 23;
                            else hour_threshold <= hour_threshold - 1; // ����Сʱ
                        end
                    end
                    //---
                end
            end
            else begin
                warning <= 0;
                hour_threshold<= hour_threshold;
                min_threshold <= min_threshold;
            end
        end
    end
endmodule
