`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/06 18:02:36
// Design Name: 
// Module Name: timer_module2
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


module timer_module2(
    input clk_100Hz,
    input rst_n,
    input start_timer,
    input adjust_en,
    input unit_toggle_press_once,
    input time_increment_press_once,
    input time_decrement_press_once,
    output reg [5:0] hour,
    output reg [5:0] min,
    output reg [5:0] sec
    );
    reg [6:0] counter;
    reg [2:0] state, next_state;
    parameter IDLE = 3'b000;
    parameter NORMAL = 3'b001;
    parameter ADJUST_MIN = 3'b010;
    parameter ADJUST_HOUR = 3'b011;
    always @(posedge clk_100Hz or negedge rst_n) begin
        if (~rst_n)
            state <= IDLE;  // 复位时进入不计时模式
        else
            state <= next_state;
    end
    always @(*) begin
        case (state)
            IDLE: begin
                if(start_timer) next_state = NORMAL;
                else next_state = IDLE;
            end
            NORMAL: begin
                if (~start_timer) 
                    next_state = IDLE;
                else if(adjust_en)
                    next_state = ADJUST_MIN;
                else 
                    next_state = NORMAL;
            end
            ADJUST_MIN: begin
                if (~start_timer)
                    next_state = IDLE;
                else if(~adjust_en)
                    next_state = NORMAL;
                else if(unit_toggle_press_once)
                    next_state = ADJUST_HOUR;
                else
                    next_state = ADJUST_MIN;
            end
            ADJUST_HOUR: begin
                if (~start_timer)
                     next_state = IDLE;
                else if(~adjust_en)
                     next_state = NORMAL;
                else if(unit_toggle_press_once)
                     next_state = ADJUST_MIN;
                else
                     next_state = ADJUST_HOUR;
            end
            default: begin
                next_state = NORMAL;
            end
        endcase
    end
    always @(posedge clk_100Hz, negedge rst_n) begin
        if(~rst_n) begin
            sec <= 0;
            min <= 0;
            hour <= 0;
            counter <= 0;
        end else begin
            case (state)
                IDLE: begin
                end
                NORMAL: begin
                    if(counter == 99) begin
                        counter <= 0;
                        if(sec == 59) begin
                            sec <= 0;
                            if(min == 59) begin
                                min <= 0;
                                if(hour == 23) begin
                                    hour <= 0;
                                end else begin
                                    hour <= hour + 1;
                                end
                            end else begin
                                min <= min + 1;
                            end
                        end else begin
                            sec <= sec + 1;
                        end
                    end else begin
                        counter <= counter + 1;
                    end
                end
                ADJUST_MIN: begin
                    if (time_increment_press_once) begin
                        if (min == 59) min <= 0;
                        else min <= min + 1; // 调整分钟
                    end else if(time_decrement_press_once) begin
                        if (min == 0) min <= 59;
                        else min <= min - 1; // 调整分钟
                    end
                end 
                ADJUST_HOUR: begin
                    if(time_increment_press_once) begin
                        if(hour == 23) hour <= 0;
                        else hour <= hour + 1;
                    end else if(time_decrement_press_once) begin
                        if(hour == 0) hour <= 23;
                        else hour <= hour - 1;
                    end
                end 
            endcase
        end
    end
endmodule
