`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/02 21:25:34
// Design Name: 
// Module Name: transition_mode
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


module transition_module(
    input clk,
    input rst_n,
    input power_menu_short_press,
    input power_menu_long_press,
    input first_level_press,
    input second_level_press,
    input third_level_press,
    input self_clean_press,
    output reg [2:0] state
    );
    reg [2:0] next_state;
    reg [63:0] self_clean_timer;
    reg [63:0] third_level_timer;
    reg [63:0] wait_to_standby_timer;
    reg hurricane_mode_activated;
    parameter OFF = 3'b000, 
                STANDBY = 3'b001, 
                MODE_SELECT = 3'b010, 
                FIRST_LEVEL = 3'b011, 
                SECOND_LEVEL = 3'b100, 
                THIRD_LEVEL = 3'b101, 
                SELF_CLEAN = 3'b110,
                WAIT_TO_STANDBY = 3'b111;
    parameter SELF_CLEAN_TIME = 64'd1500000000;
    parameter THIRD_LEVEL_TIME = 64'd1000000000;
    parameter WAIT_TO_STANDBY_TIME = 64'd1000000000;
    always @(posedge clk, negedge rst_n) begin
        if(~rst_n) begin
            state <= OFF;
            self_clean_timer <= 0;
            third_level_timer <= 0;
            wait_to_standby_timer <= 0;
            hurricane_mode_activated <= 0;
        end
        else begin
            state <= next_state; 
            if(state == SELF_CLEAN) begin
                self_clean_timer <= self_clean_timer + 1;
            end else begin
                self_clean_timer <= 0;
            end
                
            if(state == THIRD_LEVEL) begin
                third_level_timer <= third_level_timer + 1;
                hurricane_mode_activated <= 1;
            end else begin
                third_level_timer <= 0;
            end
            
            if(state == WAIT_TO_STANDBY) begin
                wait_to_standby_timer <= wait_to_standby_timer + 1;
            end else begin
                wait_to_standby_timer <= 0;
            end
            
            if(state == OFF) begin
                hurricane_mode_activated <= 0;
            end else begin
                //do nothing
            end
        end
    end
    always @(*) begin
        case(state)
            OFF: if(power_menu_short_press) next_state = STANDBY; else next_state = OFF;
            STANDBY: begin
                if(power_menu_long_press) 
                    next_state = OFF;
                else if(power_menu_short_press) 
                    next_state = MODE_SELECT; 
                else 
                    next_state = STANDBY;
            end
            MODE_SELECT: begin
                if(power_menu_long_press)
                    next_state = OFF;
                else if(first_level_press)
                    next_state = FIRST_LEVEL;
                else if(second_level_press)
                    next_state = SECOND_LEVEL;
                else if(third_level_press && !hurricane_mode_activated)
                    next_state = THIRD_LEVEL;
                else if(self_clean_press)
                    next_state = SELF_CLEAN;
                else
                    next_state = MODE_SELECT;
            end
            FIRST_LEVEL: begin
                if(power_menu_long_press)
                    next_state = OFF;
                else if(second_level_press)
                    next_state = SECOND_LEVEL;
                else if(power_menu_short_press)
                    next_state = STANDBY;
                else
                    next_state = FIRST_LEVEL;
            end
            SECOND_LEVEL: begin
                if(power_menu_long_press)
                    next_state = OFF;
                else if(first_level_press)
                    next_state = FIRST_LEVEL;
                else if(power_menu_short_press)
                    next_state = STANDBY;
                else
                    next_state = SECOND_LEVEL;
            end
            THIRD_LEVEL: begin
                if(power_menu_long_press)
                    next_state = OFF;
                else if(third_level_timer > THIRD_LEVEL_TIME)
                    next_state = SECOND_LEVEL;
                else if(power_menu_short_press)
                    next_state = WAIT_TO_STANDBY;
                else
                    next_state = THIRD_LEVEL;
            end
            SELF_CLEAN: begin
                if(power_menu_long_press)
                    next_state = OFF;
                else if(self_clean_timer > SELF_CLEAN_TIME)
                    next_state = STANDBY;
                else
                    next_state = SELF_CLEAN;
            end
            WAIT_TO_STANDBY: begin
                if(wait_to_standby_timer > WAIT_TO_STANDBY_TIME)
                    next_state = STANDBY;
                else
                    next_state = WAIT_TO_STANDBY;
            end
        endcase
    end
endmodule
