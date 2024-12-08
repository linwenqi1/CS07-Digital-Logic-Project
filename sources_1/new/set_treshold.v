`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/08 18:23:14
// Design Name: 
// Module Name: set_treshold
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


module set_treshold(
    input clk_100Hz,
    input rst_n,
    input adjust_en,
    input unit_toggle_press_once,
    input time_increment_press_once,
    input time_decrement_press_once,
    output reg [5:0] hour_threshold,
    output reg [5:0] min_threshold,
    output reg [5:0] sec_threshold,
    output reg [2:0] state
    );
    reg [2:0] next_state;
    parameter IDLE = 3'b000;
    parameter ADJUST_SEC = 3'b001;
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
                if(adjust_en)
                    next_state = ADJUST_SEC;
                else 
                    next_state = IDLE;
            end
            ADJUST_SEC: begin
                if (~adjust_en) 
                    next_state = IDLE;
                else if(unit_toggle_press_once)
                    next_state = ADJUST_MIN;
                else 
                    next_state = ADJUST_SEC;
            end
            ADJUST_MIN: begin
                if(~adjust_en)
                    next_state = IDLE;       
                else if(unit_toggle_press_once)
                    next_state = ADJUST_HOUR;
                else
                    next_state = ADJUST_MIN;
            end
            ADJUST_HOUR: begin
                if(~adjust_en)
                    next_state = IDLE;
                else if(unit_toggle_press_once)
                    next_state = ADJUST_SEC;
                else
                    next_state = ADJUST_HOUR;
            end
            default: begin
                next_state = IDLE;
            end
        endcase
    end
    always @(posedge clk_100Hz, negedge rst_n) begin
        if(~rst_n) begin
            hour_threshold <= 0;
            min_threshold <= 1;
            sec_threshold <= 0;
        end else begin
            case (state)
                IDLE: begin
                end
                ADJUST_SEC: begin
                    if(time_increment_press_once) begin
                        if (sec_threshold == 59) sec_threshold <= 0;
                        else sec_threshold <= sec_threshold + 1;
                    end else if(time_decrement_press_once) begin
                        if (sec_threshold == 0) sec_threshold <= 59;
                        else sec_threshold <= sec_threshold - 1;
                    end
                end
                ADJUST_MIN: begin
                    if (time_increment_press_once) begin
                        if (min_threshold == 59) min_threshold <= 0;
                        else min_threshold <= min_threshold + 1; // 调整分钟
                    end else if(time_decrement_press_once) begin
                        if (min_threshold == 0) min_threshold <= 59;
                        else min_threshold <= min_threshold - 1; // 调整分钟
                    end
                end 
                ADJUST_HOUR: begin
                    if(time_increment_press_once) begin
                        if(hour_threshold == 23) hour_threshold <= 0;
                        else hour_threshold <= hour_threshold + 1;
                    end else if(time_decrement_press_once) begin
                        if(hour_threshold == 0) hour_threshold <= 23;
                        else hour_threshold <= hour_threshold - 1;
                    end
                end 
            endcase
        end
    end
endmodule
