`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/04 09:11:46
// Design Name: 
// Module Name: timer_module
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


module timer_module(
    input clk_100Hz,
    input rst_n,
    input start_timer,
    output reg [5:0] hour,
    output reg [5:0] min,
    output reg [5:0] sec
    );
    reg [6:0] counter;
    always @(posedge clk_100Hz, negedge rst_n) begin
        if(~rst_n) begin
            sec <= 0;
            min <= 0;
            hour <= 0;
            counter <= 0;
        end else if(start_timer)begin
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
    end
endmodule