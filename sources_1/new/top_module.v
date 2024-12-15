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
    input display_switch1,  //1: hour min; 0: min, sec
    input display_switch2,  //1: working_time; 0: current_time
    input current_time_set_switch,
    input reminder_duration_set_switch,  //调整智能提醒时间上限的开关
    input gesture_time_set_switch,  //调整手势时间的开关
    input manual_clean,
    output [6:0] mode_led,
    output lighting_func,
    output clean_warning_light,
    output [7:0] seg_en,
    output [7:0] seg_out1,
    output [7:0] seg_out2,
    output tx
    );
    wire clk_100Hz, clk_500Hz;
    wire [2:0] state;
    wire power_menu_short_press, power_menu_long_press;
    wire power_menu_stable, first_level_stable, second_level_stable, third_level_stable, self_clean_stable;
    wire is_power_on, is_working, is_self_clean, is_standby, is_countdown_active;  //Power   Extraction  Self_clean
    wire manual_clean_stable, clean_finished;
    wire [5:0] power_on_hour;
    wire [5:0] power_on_min;
    wire [5:0] power_on_sec;
    wire [5:0] working_hour;
    wire [5:0] working_min;
    wire [5:0] working_sec;
    wire [63:0] time_count_down_in_seconds;
    wire [5:0] count_down_sec;
    wire [5:0] count_down_min;
    wire [5:0] count_down_hour;
    wire time_unit_toggle_button, time_increment_button, time_decrement_button;
    wire time_unit_toggle_press_once, time_increment_press_once, time_decrement_press_once;
    wire [5:0] hour_threshold; 
    wire [5:0] min_threshold;
    wire [5:0] sec_threshold;
    wire [2:0] adjust_state;
    wire [5:0] gesture_sec;
    wire clean_warning;
    clk_div div1(.clk(clk), .rst_n(rst_n), .clk_500Hz(clk_500Hz), .clk_100Hz(clk_100Hz));
    key_debounce debounce0(.clk(clk),.rst_n(rst_n),.key_in(power_menu_button),.key_out(power_menu_stable));
    key_debounce debounce1(.clk(clk),.rst_n(rst_n),.key_in(first_level_button),.key_out(first_level_stable));
    key_debounce debounce2(.clk(clk),.rst_n(rst_n),.key_in(second_level_button),.key_out(second_level_stable));
    key_debounce debounce3(.clk(clk),.rst_n(rst_n),.key_in(third_level_button),.key_out(third_level_stable));
    key_debounce debounce4(.clk(clk),.rst_n(rst_n),.key_in(self_clean_button),.key_out(self_clean_stable));
    key_debounce debounce5(.clk(clk),.rst_n(rst_n),.key_in(manual_clean),.key_out(manual_clean_stable));
    assign lighting_func = is_power_on & light_switch;  //照明功能
    assign time_unit_toggle_button = second_level_stable;   //按键复用, 时分秒切换键
    assign time_increment_button = third_level_stable;    //加1键
    assign time_decrement_button = first_level_stable;    //减1键
    assign clean_warning_light = clean_warning;
    key_press_detector detector1(
            .clk(clk),
            .key_input(power_menu_stable),
            .rst_n(rst_n),
            .long_press(power_menu_long_press),
            .short_press(power_menu_short_press)
            );
    edge_detect_100Hz detector2(
        .clk_100Hz(clk_100Hz),
        .rst_n(rst_n),
        .key_in(time_unit_toggle_button),
        .press_once(time_unit_toggle_press_once)
        );
    edge_detect_100Hz detector3(
        .clk_100Hz(clk_100Hz),
        .rst_n(rst_n),
        .key_in(time_increment_button),
        .press_once(time_increment_press_once)
        );
    edge_detect_100Hz detector4(
        .clk_100Hz(clk_100Hz),
        .rst_n(rst_n),
        .key_in(time_decrement_button),
        .press_once(time_decrement_press_once)
        );
    check_clean_finish checker1(
        .clk_100Hz(clk_100Hz),
        .rst_n(rst_n),
        .self_clean(is_self_clean),
        .manual_clean(manual_clean_stable & is_standby),
        .clean_finished(clean_finished)
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
        .state(state),
        .time_count_down_in_seconds(time_count_down_in_seconds)
        );
    time_converter_module converter1(
        .clk_500Hz(clk_500Hz),
        .rst_n(rst_n),
        .total_seconds(time_count_down_in_seconds),
        .seconds(count_down_sec),
        .minutes(count_down_min),
        .hours(count_down_hour)
        );
    power_state_indicator judge(
        .clk(clk),
        .rst_n(rst_n),
        .state(state),
        .is_power_on(is_power_on),
        .is_working(is_working),
        .is_self_clean(is_self_clean),
        .is_standby(is_standby),
        .is_countdown_active(is_countdown_active)
        );
    mode_indicator indicator2(
        .state(state),
        .mode_led(mode_led)
        );
    timer_module2 timer1(   //当前时间
        .clk_100Hz(clk_100Hz),
        .rst_n(rst_n & is_power_on),
        .start_timer(is_power_on),
        .adjust_en(is_standby & current_time_set_switch),
        .unit_toggle_press_once(time_unit_toggle_press_once),
        .time_increment_press_once(time_increment_press_once),
        .time_decrement_press_once(time_decrement_press_once),
        .hour(power_on_hour),
        .min(power_on_min),
        .sec(power_on_sec)
        );
    timer_module timer2( //工作时间
        .clk_100Hz(clk_100Hz),
        .rst_n(rst_n & is_power_on & ~clean_finished),
        .start_timer(is_working),
        .hour(working_hour),
        .min(working_min),
        .sec(working_sec)
        );
    set_treshold setter1(
        .clk_100Hz(clk_100Hz),
        .rst_n(rst_n & is_power_on),
        .adjust_en(is_standby & reminder_duration_set_switch),
        .unit_toggle_press_once(time_unit_toggle_press_once),
        .time_increment_press_once(time_increment_press_once),
        .time_decrement_press_once(time_decrement_press_once),
        .hour_threshold(hour_threshold),
        .min_threshold(min_threshold),
        .sec_threshold(sec_threshold),
        .state(adjust_state)
        );
    set_gesture_time setter2(
        .clk_100Hz(clk_100Hz),
        .rst_n(rst_n & is_power_on),
        .adjust_en(is_standby & gesture_time_set_switch),
        .time_increment_press_once(time_increment_press_once),
        .time_decrement_press_once(time_decrement_press_once),
        .gesture_sec(gesture_sec)
        );
    clean_reminder reminder1(
        .clk_100Hz(clk_100Hz),
        .rst_n(rst_n),
        .is_standby(is_standby),
        .working_hour(working_hour),
        .working_min(working_min),
        .working_sec(working_sec),
        .hour_threshold(hour_threshold),  //暂时处理，待调整模块写好后传入
        .min_threshold(min_threshold),
        .sec_threshold(sec_threshold),
        .warning(clean_warning)
        );
    time_display_module display1(
        .clk_500Hz(clk_500Hz),
        .rst_n(rst_n),
        .en(is_power_on),
        .switch1(display_switch1),
        .switch2(display_switch2),
        .need_count_down(is_countdown_active),
        .power_on_hour(power_on_hour),
        .power_on_min(power_on_min),
        .power_on_sec(power_on_sec),
        .working_hour(working_hour),
        .working_min(working_min),
        .working_sec(working_sec),
        .count_down_hour(count_down_hour),
        .count_down_min(count_down_min),
        .count_down_sec(count_down_sec),
        .seg_en(seg_en[7:4]),
        .seg_out(seg_out1)
        );
    time_set_display_module display2(
        .clk_500Hz(clk_500Hz),
        .rst_n(rst_n),
        .is_standby(is_standby),
        .hour_threshold(hour_threshold),
        .min_threshold(min_threshold),
        .sec_threshold(sec_threshold),
        .adjust_state(adjust_state),
        .gesture_sec(gesture_sec),
        .reminder_duration_set_switch(reminder_duration_set_switch),
        .gesture_time_set_switch(gesture_time_set_switch),
        .seg_en(seg_en[3:0]),
        .seg_out(seg_out2)
        );
    uart_tx uart_tx_ins(
        .clk(clk),
        .rst_n(rst_n),
        .current_hour(power_on_hour),
        .current_min(power_on_min),
        .current_sec(power_on_sec),
        .working_hour(working_hour),
        .working_min(working_min),
        .working_sec(working_sec),
        .count_down_hour(count_down_hour),
        .count_down_min(count_down_min),
        .count_down_sec(count_down_sec),
        .hour_threshold(hour_threshold),
        .min_threshold(min_threshold),
        .sec_threshold(sec_threshold),
        .light_on(is_power_on & light_switch),
        .state(state),
        .tx(tx)
        );
endmodule
