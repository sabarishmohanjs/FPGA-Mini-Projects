`timescale 1ns / 1ps

module counter(input clk,input rst,input in,start,output reg [6:0]seg_out,output reg [3:0]loops,output [7:0]an);

reg [3:0]count;
reg [25:0] clk_div=0;
wire slow_clk;
reg prev_in=0;
always @(posedge clk)begin
    clk_div<=clk_div+1;
end

assign slow_clk=clk_div[25];


always @(posedge slow_clk or posedge rst)begin
     if (rst)begin
        count<=4'h0;
        loops<=4'h0;
     end
    else if(start)begin
            if ((~in)&prev_in)begin
                count<=4'h9;
                loops<=4'h0;
            end
            else if((in&(~prev_in)))begin
                count <=4'h0;
                loops<=4'h0;
            end
           
            else begin        
                    if(in)begin
                        if(count==4'h9) begin
                            count<=4'h0;
                            loops<=loops+1;
                        end
                        else  
                             count<=count+1; 
                     end
                    else begin
                        if(count==0) begin
                           count<=4'h9;
                           loops<=loops+1;
                        end
                        else 
                            count<=count-1; 
                    end
            end
                
    end
    prev_in<=in;
    
end


always @(*) begin
        case(count)
            4'd0: seg_out = 7'b1000000;
            4'd1: seg_out = 7'b1111001;
            4'd2: seg_out = 7'b0100100;
            4'd3: seg_out = 7'b0110000;
            4'd4: seg_out = 7'b0011001;
            4'd5: seg_out = 7'b0010010;
            4'd6: seg_out = 7'b0000010;
            4'd7: seg_out = 7'b1111000;
            4'd8: seg_out = 7'b0000000;
            4'd9: seg_out = 7'b0010000;
            default: seg_out = 7'b1111111;
        endcase
    end
assign an=8'b11111110;


endmodule
