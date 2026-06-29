module traffic_light_fsm(
    input clk,
    input rst,
    input ped_btn,
    output reg [2:0] ns_light,  // NS: bit2=RED, bit1=YELLOW, bit0=GREEN
    output reg [2:0] ew_light,  // EW: bit2=RED, bit1=YELLOW, bit0=GREEN
    output reg ped_walk
);

// State encoding
localparam S0 = 3'd0;
localparam S1 = 3'd1;
localparam S2 = 3'd2;
localparam S3 = 3'd3;
localparam S4 = 3'd4;


reg [2:0] state, next_state;
reg [3:0] timer;

// State register
always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= S0;
        timer <= 0;
    end else begin
        if (ped_btn) begin
            state <= S4;
            timer <= 0;
        end else if (
            (state == S0 && timer == 9)  ||
            (state == S1 && timer == 2)  ||
            (state == S2 && timer == 9)  ||
            (state == S3 && timer == 2)  ||
            (state == S4 && timer == 4)
        ) begin
            state <= next_state;
            timer <= 0;
        end else begin
            timer <= timer + 1;
        end
    end
end

// Next state logic
always @(*) begin
    case(state)
        S0: next_state = S1;
        S1: next_state = S2;
        S2: next_state = S3;
        S3: next_state = S0;
        S4: next_state = S0;
        default: next_state = S0;
    endcase
end

// Output logic
always @(*) begin
    ped_walk = 0;
    case(state)
        S0: begin ns_light = 3'b001; ew_light = 3'b100; end // NS=G, EW=R
        S1: begin ns_light = 3'b010; ew_light = 3'b100; end // NS=Y, EW=R
        S2: begin ns_light = 3'b100; ew_light = 3'b001; end // NS=R, EW=G
        S3: begin ns_light = 3'b100; ew_light = 3'b010; end // NS=R, EW=Y
        S4: begin ns_light = 3'b100; ew_light = 3'b100; ped_walk = 1; end
        default: begin ns_light = 3'b100; ew_light = 3'b100; end
    endcase
end

endmodule