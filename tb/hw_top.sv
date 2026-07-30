module hw_top;

    logic [31:0]  clock_period = 5;
    logic         run_clock = 1'b1;
    logic         clock;
    logic         reset;

    parameter ADDR_WIDTH = 32;
    parameter DATA_WIDTH = 32;

    apb_if apb(clock, reset);
    axi_if #(
        .ADDR_WIDTH (ADDR_WIDTH),
        .DATA_WIDTH (DATA_WIDTH)
    ) axi_if_inst (
        .PCLK   (clock),
        .PRESET (reset)
    );

    Bridge_Complete #(
        .ADDR_WIDTH (ADDR_WIDTH),
        .DATA_WIDTH (DATA_WIDTH)
    ) u_bridge (
        .PCLK               (clock),
        .PRESET             (reset),

        // Request FIFO
        .req_fifo_empty     (axi_if_inst.req_fifo_empty),
        .req_fifo_rd_data   (axi_if_inst.req_fifo_rd_data),
        .req_fifo_rd_en     (axi_if_inst.req_fifo_rd_en),

        // Write FIFO
        .wr_fifo_empty      (axi_if_inst.wr_fifo_empty),
        .wr_fifo_rd_data    (axi_if_inst.wr_fifo_rd_data),
        .wr_fifo_rd_en      (axi_if_inst.wr_fifo_rd_en),

        // Read FIFO
        .rd_fifo_full       (axi_if_inst.rd_fifo_full),
        .rd_fifo_wr_en      (axi_if_inst.rd_fifo_wr_en),
        .rd_fifo_wr_data    (axi_if_inst.rd_fifo_wr_data),
        
        // APB
        .PTRANSFER          (apb.PTRANSFER),
        .PWRITE             (apb.PWRITE),
        .PADDR              (apb.PADDR),
        .PWDATA             (apb.PWDATA),
        .PSTRB              (apb.PSTRB),
        .PREADY             (apb.PREADY),
        .PRDATA             (apb.PRDATA)
    );

    initial begin
        clock = 0;
        forever #(clock_period/2) clock = ~clock;
    end

    initial begin
        reset = 0;   
        #100;
        reset = 1;
        #10;         
    end
endmodule