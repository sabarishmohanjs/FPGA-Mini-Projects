`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/10/2025 05:21:25 PM
// Design Name: 
// Module Name: code_con
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: This Verilog code defines several modules that together implement a system for processing 4-bit data, likely performing some form of bitwise operation controlled by a finite state machine.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: Corrected issues related to R1 loading and FSM state logic.
// 
//////////////////////////////////////////////////////////////////////////////////


// PIPO (Parallel-In, Parallel-Out) Register module
module pipo_reg(input clk, // Clock input
                input rst, // Reset input
                inout [3:0]bus, // 4-bit bidirectional bus
                input in_en, // Input enable signal
                out_en, // Output enable signal
                output [3:0]out); // 4-bit output
    reg [3:0]data; // Internal register to hold the 4-bit data
    
    // Always block for sequential logic (data loading and reset)
    always @(posedge clk or posedge rst)begin
        if(rst)begin
            data<=4'b0; // Reset data to 0
        end
        else if(in_en)begin
            data<=bus; // Load data from bus when in_en is high
        end            
    end 
    
    // Tri-state buffer for output to the bus
    assign bus =(out_en)?out:4'bzzzz; // Drive bus with 'out' when out_en is high, otherwise high-impedance
    assign out=data; // Assign internal data to the output
endmodule


// Single-bit Register module
module bit_reg(input clk, // Clock input
               input rst, // Reset input
               inout bus, // Single-bit bidirectional bus
               input in_en, // Input enable signal
               out_en, // Output enable signal
               output out); // Single-bit output
    reg data; // Internal register to hold the single bit data
    
    // Always block for sequential logic (data loading and reset)
    always @(posedge clk or posedge rst)begin
        if(rst)begin
            data<=1'b0; // Reset data to 0
        end
        else if(in_en)begin
            data<=bus; // Load data from bus when in_en is high
        end            
    end 
    
    // Tri-state buffer for output to the bus
    assign bus =(out_en)?out:1'bz; // Drive bus with 'out' when out_en is high, otherwise high-impedance
    assign out=data; // Assign internal data to the output
endmodule

// XOR gate module
module ex_or(input a, // First input
             input b, // Second input
             output out ); // Output of XOR operation
    assign out =a^b; // Perform XOR operation
endmodule

// 4-to-1 Multiplexer module
module mux_4(input [3:0]data, // 4-bit input data
             input [1:0]sel, // 2-bit select signal
             output out); // Single-bit output
    assign out=data[sel]; // Select one bit from 'data' based on 'sel'
endmodule

// Control Unit module (Finite State Machine)
module control_unit (input rst, // Reset input
                     input clk, // Clock input
                     input start, // Start signal
                     output reg r1_in, // Enable input for R1
                     output reg r1_out, // Enable output for R1
                     output reg r2_in, // Enable input for R2
                     output reg r2_out, // Enable output for R2
                     output reg r3_in, // Enable input for R3
                     output reg r3_out, // Enable output for R3
                     output reg r4_in, // Enable input for R4
                     output reg r4_out, // Enable output for R4
                     output reg [1:0]sel, // Select signal for MUX (current bit index)
                     output reg [1:0]sel_nxt, // Select signal for MUX (next bit index)
                     output reg done); // Done signal

    // State parameters for the FSM
    parameter IDLE=3'd0, // Initial state, waiting for start
              LOAD_R1=3'd1, // New state: Load data into R1 from bus
              LOAD_BITS=3'd2, // Load current and next bits into R3 and R4
              DO_XOR=3'd3, // Perform XOR operation
              STORE_RESULT=3'd4, // Store XOR result (e.g., into R2)
              DEC_INDEX=3'd5, // Decrement bit index
              CHECK_DONE=3'd6, // Check if all bits processed
              DONE_STATE=3'd7; // Operation complete state
    
    reg [2:0]next_state,current_state; // State registers
    reg[1:0] index; // Index for bit selection (0 to 3)

    // Sequential logic for state transitions
    always @(posedge clk or posedge rst)begin
        if(rst)
            current_state<=IDLE; // Reset to IDLE state
        else 
            current_state<=next_state; // Move to next state
    end
    
    // Sequential logic for index decrement
    always @(posedge clk or posedge rst)begin
        if(rst)
            index<=2'd3; // Initialize index to 3 (MSB for 4-bit data)
        else if(current_state==DEC_INDEX) begin
            if(index > 0)
                index<=index-1; // Decrement index if in DEC_INDEX state and not 0
            else
                index<=2'd0; // Stay at 0 if already 0
        end
    end
    
    // Combinational logic for outputs and next state determination
    always @(*) begin
        // Default values for outputs
        r1_in=0;r1_out=0;r2_out=0;r2_in=0;r3_in=0;r3_out=0;r4_in=0;r4_out=0;
        done=0;
        sel=index; // 'sel' is the current index
        sel_nxt=index-1; // 'sel_nxt' is the next lower index (for the other MUX input)
        
        // State transition logic
        case(current_state)
            IDLE:next_state=(start)?LOAD_R1:IDLE; // If start, move to LOAD_R1
            LOAD_R1:next_state=LOAD_BITS; // After loading R1, start processing bits
            LOAD_BITS:next_state=DO_XOR; // After loading bits into R3/R4, perform XOR
            DO_XOR:next_state=STORE_RESULT; // After XOR, store the result
            STORE_RESULT:next_state=DEC_INDEX; // After storing, decrement index
            DEC_INDEX:next_state=CHECK_DONE; // After decrementing, check if done
            CHECK_DONE:next_state=(index==0)? DONE_STATE:LOAD_BITS; // If index is 0, go to DONE_STATE, else repeat bit loading
            DONE_STATE:next_state=DONE_STATE; // Stay in DONE_STATE
            default:next_state=IDLE; // Default to IDLE
        endcase
        
        // Output logic based on current state
        case(current_state)
            LOAD_R1:begin
                r1_in=1; // Enable input to R1 to load data from bus
            end
            LOAD_BITS:begin
                r1_out=1; // Enable output from R1
                r3_in=1; // Enable input to R3
                r4_in=1; // Enable input to R4
                sel = index; // Select current bit
                sel_nxt = index-1; // Select next bit
                // Ensure sel_nxt doesn't go below 0 if index is 0
                if (index == 0) sel_nxt = 2'd0; // Or handle as per specific logic
            end
            DO_XOR:begin
                r3_out=1; // Enable output from R3
                r4_out=1; // Enable output from R4
            end
            STORE_RESULT:begin
                r2_in=1; // Enable input to R2 to store XOR result
            end
            DONE_STATE:begin 
                done=1; // Set done signal
                r2_out=1; // Enable output from R2 (final result)
            end
        endcase
    end   
endmodule

// Top Module for the system
module topmodule(input clk, // Clock input
                 input rst, // Reset input
                 input start, // Start signal
                 inout[3:0]bus); // 4-bit bidirectional bus

    // Wire declarations for connecting sub-modules
    wire r1_in,r1_out,r2_in,r2_out; // Control signals for PIPO registers
    wire r3_in,r3_out,r4_in,r4_out,done; // Control signals for bit registers and done signal
    wire [1:0]sel,sel_next; // MUX select signals
    wire[3:0]r1,r2; // Outputs of PIPO registers
    wire r3,r4,xor_out; // Outputs of bit registers and XOR gate
    
    // Instantiate PIPO registers
    pipo_reg R1(clk,rst,bus,r1_in,r1_out,r1); // R1 connected to the main bus
    pipo_reg R2(clk,rst,bus,r2_in,r2_out,r2); // R2 connected to the main bus
    
    // Instantiate single-bit registers
    // Note: R3 and R4 are connected to the main bus, but in_en/out_en control their interaction.
    // The mux_4 modules drive their inputs, not the main bus.
    bit_reg R3(clk,rst,bus,r3_in,r3_out,r3); 
    bit_reg R4(clk,rst,bus,r4_in,r4_out,r4); 
    
    // Instantiate XOR gate
    ex_or xor1(r3,r4,xor_out); // XORing outputs of R3 and R4
    
    // Instantiate MUXes
    mux_4 one(r1,sel,r3); // Selects a bit from R1 based on 'sel' and feeds to R3
    mux_4 two(r1,sel_next,r4); // Selects a bit from R1 based on 'sel_next' and feeds to R4

    // Instantiate Control Unit
    control_unit control(rst,clk,start,r1_in,r1_out,r2_in,r2_out,r3_in,r3_out,r4_in,r4_out,sel,sel_next,done);    
    
    // The previous 'assign bit_bus' line was removed as it was unused and potentially misleading.
    // The bit_reg instances (R3, R4) are already connected to the main bus via their 'bus' port,
    // but their data transfer is controlled by in_en/out_en from the control unit.
    
endmodule
