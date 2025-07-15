`timescale 1ns / 1ps

module counter_tb();

    reg clk;
    reg rst;
    reg in,start;
    wire [6:0]seg_out ;
    wire [3:0]loops;
    wire [7:0]an;
    
    counter dut(clk,rst,in,start,seg_out,loops,an);
    
    initial begin
        clk=0;
        forever #5 clk=~clk;
    end
    
    initial begin
        rst=1;in=0;start=1;#5
        rst=0;in=0;start=1;#5000 
        rst=0;in=1;start=1;#5000 
        $finish;
    end
    
    initial begin
        $monitor("Time=%t||loop=%d.",$time,loops);
    end

endmodule
