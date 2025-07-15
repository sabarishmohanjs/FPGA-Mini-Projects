module barrel(input [3:0]in,
input [2:0]sel,
output reg[3:0]out);

    always@(*)begin
        case(sel)
            3'b000:out=in;
            3'b001:out={in[2:0],in[3]};
            3'b010:out={in[1:0],in[3],in[2]};
            3'b011:out={in[0],in[3:1]};
            3'b100:out=in;
            3'b101:out={in[0],in[3:1]};
            3'b110:out={in[1:0],in[3:2]};
            3'b111:out={in[2:0],in[3]};
            default:out=4'bzzzz;
       endcase
   end
            
endmodule
