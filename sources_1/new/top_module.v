`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/02 20:15:37
// Design Name: 
// Module Name: top_module
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


module top_module(
    input clk,
    input rst_n,
    input power_menu_button,
    input first_level_button,
    input second_level_button,
    input third_level_button,
    input self_clean_button,
    input light_switch,
    output [5:0] mode_led,
    output lighting_func
    );
    wire [2:0] state;
    wire power_menu_short_press, power_menu_long_press;
    wire power_menu_stable, first_level_stable, second_level_stable, third_level_stable, self_clean_stable;
    wire is_power_on, is_working;  //Power   Extraction
    key_debounce debounce0(.clk(clk),.rst_n(rst_n),.key_in(power_menu_button),.key_out(power_menu_stable));
    key_debounce debounce1(.clk(clk),.rst_n(rst_n),.key_in(first_level_button),.key_out(first_level_stable));
    key_debounce debounce2(.clk(clk),.rst_n(rst_n),.key_in(second_level_button),.key_out(second_level_stable));
    key_debounce debounce3(.clk(clk),.rst_n(rst_n),.key_in(third_level_button),.key_out(third_level_stable));
    key_debounce debounce4(.clk(clk),.rst_n(rst_n),.key_in(self_clean_button),.key_out(self_clean_stable));
    key_press_detector detector1(
            .clk(clk),
            .key_input(power_menu_stable),
            .rst_n(rst_n),
            .long_press(power_menu_long_press),
            .short_press(power_menu_short_press)
            );
    transition_module transition1(
        .clk(clk),
        .rst_n(rst_n),
        .power_menu_short_press(power_menu_short_press),
        .power_menu_long_press(power_menu_long_press),
        .first_level_press(first_level_stable),
        .second_level_press(second_level_stable),
        .third_level_press(third_level_stable),
        .self_clean_press(self_clean_stable),
        .state(state)
        );
    power_state_indicator judge(
        .state(state),
        .is_power_on(is_power_on),
        .is_working(is_working)
        );
    mode_indicator indicator2(
        .state(state),
        .mode_led(mode_led)
        );
    assign lighting_func = is_power_on & light_switch;
endmodule
