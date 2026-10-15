module arbiter_fp (
    input  wire       clk,
    input  wire       rst,
    input  wire [3:0] req,
    output reg  [3:0] grant
);

    // Fixed priority: component 0 always wins if requesting,
    // then component 1, then 2, then 3. No pointer, no rotation.
    always @(*) begin
        grant = 4'b0000;
        if (req[0])
            grant[0] = 1'b1;
        else if (req[1])
            grant[1] = 1'b1;
        else if (req[2])
            grant[2] = 1'b1;
        else if (req[3])
            grant[3] = 1'b1;
    end

endmodule