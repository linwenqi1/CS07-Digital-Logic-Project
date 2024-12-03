`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/02 22:02:33
// Design Name: 
// Module Name: mode_indicator
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


module mode_indicator(
    input [2:0] state,
    output reg [5:0] mode_led
    );
    parameter OFF = 3'b000, 
               STANDBY = 3'b001, 
               MODE_SELECT = 3'b010, 
               FIRST_LEVEL = 3'b011, 
               SECOND_LEVEL = 3'b100, 
               THIRD_LEVEL = 3'b101, 
               SELF_CLEAN = 3'b110;
    always @(state) begin
        case(state)
            OFF: mode_led = 6'b000000;
            STANDBY: mode_led = 6'b000001;
            MODE_SELECT: mode_led = 6'b000010;
            FIRST_LEVEL: mode_led = 6'b000100;
            SECOND_LEVEL: mode_led = 6'b001000;
            THIRD_LEVEL: mode_led = 6'b010000;
            SELF_CLEAN: mode_led = 6'b100000;
        endcase
    end
endmodule
