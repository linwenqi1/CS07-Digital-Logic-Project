`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/03 21:56:25
// Design Name: 
// Module Name: power_state_indicator
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


module power_state_indicator(
    input [2:0] state,        // Current state
    output wire is_power_on,  // High when powered on
    output wire is_working,    // High when in working mode
    output wire is_self_clean,
    output wire is_standby,
    output wire is_countdown_active
    );
    parameter OFF = 3'b000, 
               STANDBY = 3'b001, 
               MODE_SELECT = 3'b010, 
               FIRST_LEVEL = 3'b011, 
               SECOND_LEVEL = 3'b100, 
               THIRD_LEVEL = 3'b101, 
               SELF_CLEAN = 3'b110,
               WAIT_TO_STANDBY = 3'b111;
    assign is_power_on = (state == STANDBY) || (state == MODE_SELECT) || (state == FIRST_LEVEL)
        || (state == SECOND_LEVEL) || (state == THIRD_LEVEL) || (state == WAIT_TO_STANDBY)
        || (state == SELF_CLEAN);
    assign is_working = (state == FIRST_LEVEL) || (state == SECOND_LEVEL) || (state == THIRD_LEVEL);
    assign is_self_clean = (state == SELF_CLEAN);
    assign is_standby = (state == STANDBY);
    assign is_countdown_active = (state == THIRD_LEVEL) || (state == WAIT_TO_STANDBY) || (state == SELF_CLEAN);
endmodule
