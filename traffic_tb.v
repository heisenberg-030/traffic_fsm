`timescale 1ns/1ps

module traffic_tb;

reg clk, rst, ped_btn;
wire [2:0] ns_light, ew_light;
wire ped_walk;

// Instantiate the FSM
traffic_light_fsm uut (
    .clk(clk),
    .rst(rst),
    .ped_btn(ped_btn),
    .ns_light(ns_light),
    .ew_light(ew_light),
    .ped_walk(ped_walk)
);

// Clock: 10ns period
always #5 clk = ~clk;

initial begin
    // Dump waveforms
    $dumpfile("traffic.vcd");
    $dumpvars(0, traffic_tb);

    // Initialize
    clk = 0; rst = 1; ped_btn = 0;

    // Release reset
    #20 rst = 0;

    // Let it run through S0 and S1
    #150;

    // Press pedestrian button
    ped_btn = 1;
    #10;
    ped_btn = 0;

    // Let pedestrian state complete and cycle continue
    #200;

    $finish;
end

// Monitor outputs
// Monitor outputs
initial begin
    $monitor("Time=%0t | State clk=%b | NS=%b | EW=%b | PED_WALK=%b",
              $time, clk, ns_light, ew_light, ped_walk);
end

// Self-checking assertions
// Self-checking assertions
initial begin
    // Wait for reset to clear
    #25;

    // Check S0: NS=GREEN(001), EW=RED(100)
    if(ns_light === 3'b001 && ew_light === 3'b100)
        $display("PASS: S0 - NS GREEN, EW RED verified");
    else
        $display("FAIL: S0 incorrect - NS=%b EW=%b", ns_light, ew_light);

    // Wait for S1: NS=YELLOW(010), EW=RED(100)
    #95;
    if(ns_light === 3'b010 && ew_light === 3'b100)
        $display("PASS: S1 - NS YELLOW, EW RED verified");
    else
        $display("FAIL: S1 incorrect - NS=%b EW=%b", ns_light, ew_light);

    // Wait for S2: NS=RED(100), EW=GREEN(001)
    #35;
    if(ns_light === 3'b100 && ew_light === 3'b001)
        $display("PASS: S2 - NS RED, EW GREEN verified");
    else
        $display("FAIL: S2 incorrect - NS=%b EW=%b", ns_light, ew_light);

    // Wait for pedestrian state S4
    #40;
    if(ns_light === 3'b100 && ew_light === 3'b100 && ped_walk === 1)
        $display("PASS: S4 - PEDESTRIAN state verified");
    else
        $display("FAIL: S4 incorrect - NS=%b EW=%b PED=%b", ns_light, ew_light, ped_walk);
end
endmodule