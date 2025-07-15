// Testbench for the top module
module tb_topmodule();
    reg clk = 0; // Clock signal
    reg rst = 0; // Reset signal
    reg start = 0; // Start signal

    wire [3:0] bus; // Bidirectional bus connected to the UUT
    reg [3:0] data_drive; // Data to drive onto the bus
    reg drive_bus = 0; // Control signal to enable driving the bus

    // Assign bus only when drive_bus is 1, otherwise high-impedance
    assign bus = drive_bus ? data_drive : 4'bz;

    // Instantiate topmodule (Unit Under Test)
    topmodule uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .bus(bus)
    );

    // Clock generation (5ns period, 10ns cycle)
    always #5 clk = ~clk;

    initial begin
        // Step 1: Reset the system
        rst = 1; #10; // Assert reset for 10ns
        rst = 0;#1; // De-assert reset

        // Step 2: Drive input data = 1010
        data_drive = 4'b1010; // Set data to drive
        drive_bus = 1; // Enable driving the bus
        start = 1; #10; // Assert start for 10ns
        start = 0; // De-assert start
        drive_bus = 0; // Release the bus to allow other modules to drive it

        // Step 3: Wait for conversion to complete
        #100; // Wait for 100ns to observe the operation

        $finish; // End simulation
    end
endmodule
