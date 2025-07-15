`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/07/2025 06:01:26 PM
// Design Name: 
// Module Name: barrel_tb
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


module barrel_tb();

    reg [3:0]in;
    reg [2:0]sel;
    wire[3:0]out;
    
    barrel dut(in,sel,out);
    
    initial begin
        in=4'ha;
        sel=3'h0;#2;
        sel=3'h1;#2;
        sel=3'h2;#2;
        sel=3'h3;#2;
        sel=3'h4;#2;
        sel=3'h5;#2;
        sel=3'h6;#2;
        sel=3'h7;#2;
        $finish;
    end
    
endmodule
