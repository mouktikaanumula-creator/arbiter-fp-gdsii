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

module tt_um_arbiter_fp (
    input  wire [7:0] ui_in,
    output wire [7:0] uo_out,
    input  wire [7:0] uio_in,
    output wire [7:0] uio_out,
    output wire [7:0] uio_oe,
    input  wire       ena,
    input  wire       clk,
    input  wire       rst_n
);

    wire [3:0] req_internal = ui_in[3:0];
    wire [3:0] grant_internal;

    arbiter_fp dut (
        .clk(clk),
        .rst(~rst_n),
        .req(req_internal),
        .grant(grant_internal)
    );

    assign uo_out  = {4'b0000, grant_internal};
    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

    wire _unused = &{ena, uio_in, 1'b0};

endmodule

module tt_um_arbiter_fp (
    input  wire [7:0] ui_in,
    output wire [7:0] uo_out,
    input  wire [7:0] uio_in,
    output wire [7:0] uio_out,
    output wire [7:0] uio_oe,
    input  wire        ena,
    input  wire        clk,
    input  wire        rst_n
);

    wire [3:0] grant_internal;

    arbiter_fp dut (
        .clk(clk),
        .rst(~rst_n),
        .req(ui_in[3:0]),
        .grant(grant_internal)
    );

    assign uo_out  = {4'b0000, grant_internal};
    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

    wire _unused = &{ena, uio_in, ui_in[7:4], 1'b0};

endmodule