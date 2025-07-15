`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.07.2025 12:49:33
// Design Name: 
// Module Name: ledblink
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


module ledblink(
    input clk,rst,switch,
    output reg led
    );
    
    localparam count=50000000;
    reg [26:0]counter;
    
    always@(posedge clk or posedge rst)begin
        if(rst)begin
            counter<=0;
            led<=0;
        end
        else begin
            if(switch)begin
                if(counter==count-1)begin
                    counter<=0;
                    led<=~led;
                end
                else
                    counter<=counter+1;
                end
            
            else begin
                counter<=0;
                led<=0;
            end
      end
      end
    
endmodule
