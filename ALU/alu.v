`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.07.2025 10:45:47
// Design Name: 
// Module Name: alu
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


module alu(a,b,sel,out,ov);
input [3:0] a,b;
input [2:0] sel;
output reg [3:0] out;
output reg ov;

always@(*)
begin
case(sel)
3'b000 : {ov,out} =a+b;
3'b001 : {ov,out} =a-b;
3'b010 : {ov,out} ={1'b0,a&b};
3'b011 : {ov,out}={1'b0,a|b};
3'b100 : {ov,out}={1'b0,a^b};
3'b101 : {ov,out}={1'b0,a<<b};
3'b110 : {ov,out}={1'b0,a>>b};
3'b111 : {ov,out}={1'b0,a[2:0],a[3]};
default 
: {ov,out}=5'b0000;
endcase
end
endmodule
