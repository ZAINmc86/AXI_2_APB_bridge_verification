module hw_top;

    logic [31:0]  clock_period = 5;
    logic         run_clock = 1'b1;
    logic         clock;
    logic         reset;

    apb_if apb(clock, reset);

    Bridge_Complete #(32,32) u_bridge (
        .PCLK               (clock),
        .PRESET             (reset),
        .req_fifo_empty     (),
        .req_fifo_rd_data   (),
        .req_fifo_rd_en     (),
        .wr_fifo_empty      (),
        .wr_fifo_rd_data    (),
        .wr_fifo_rd_en      (),
        .rd_fifo_wr_en      (),
        .rd_fifo_wr_data    (),
        .rd_fifo_full       (),
        .PTRANSFER          (apb.PTRANSFER),
        .PWRITE             (apb.PWRITE),
        .PADDR              (apb.PADDR),
        .PWDATA             (apb.PWDATA),
        .PSTRB              (apb.PSTRB),
        .PREADY             (apb.PREADY),
        .PRDATA             (apb.PRDATA)
    );

    clkgen clkgen (.clock(clock), .run_clock(run_clock), .clock_period(clock_period));

    initial begin

    end
endmodule