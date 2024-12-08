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
    input is_standby, //用is_standby当作en信号
    output reg [3:0] seg_en,
    output [7:0] seg_out
    );
    parameter ADJUST_MIN_REMINDER = 2'b00;
    parameter ADJUST_HOUR_REMINDER = 2'b01;
    reg [1:0] scan_cnt;
    reg [3:0] content_display [3:0];
    always @(adjust_state,is_standby,reminder_duration_set_switch,gesture_time_set_switch) begin
        if(is_standby) begin
        //四个数码管，从左到右3210
        //数码管3显示当前调整的模式 1 2为调整智能提醒时长的分钟、小时，3为调整手势时长的秒钟
        //数码管1和0用来显示时间
            if(reminder_duration_set_switch) begin
                case(adjust_state)    
                            ADJUST_MIN_REMINDER  : begin
                                content_display[0] =  min_threshold % 10;
                                content_display[1] =  min_threshold / 10;
                                content_display[2] = 4'h0 ;//其实什么都不会显示
                                content_display[3] = 4'h1;
                            end
                            ADJUST_HOUR_REMINDER : begin
                                content_display[0] =  hour_threshold % 10;
                                content_display[1] =  hour_threshold / 10;
                                content_display[2] = 4'h0 ;//其实什么都不会显示
                                content_display[3] = 4'h2;
                            end
                endcase
            end
            else if (gesture_time_set_switch) begin
                content_display[0] =  second_gesture % 10;
                content_display[1] =  second_gesture / 10;
                content_display[2] =  4'h0 ;//其实什么都不会显示
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
                3'b101: seg_en=4'b0000; //fjm 这种模式下，从左往右数第二个数码管永远不显示
                3'b111: seg_en=4'b1000;
                default: seg_en=4'b0000;
            endcase
        end
        light_7seg_ego1 u1(.sw(content_display[scan_cnt]), .seg_out(seg_out), .dp(0));//fjm 这里小数点不需要显示，dp直接为0即可
endmodule
