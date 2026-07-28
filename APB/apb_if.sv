interface apb_if (input clk, input rst);
    `timescale 1ns/100ps

    import uvm_pkg::*;
    import apb_pkg::*;

    `include "uvm_macros.svh"
    
    parameter int ADDR_WIDTH = 32;
    parameter int DATA_WIDTH = 32;
    localparam int STRB_WIDTH = DATA_WIDTH / 8;

    // APB-side control signals
    logic                       PTRANSFER; //output port from rtl
    logic                       PWRITE;    //output port from rtl
    logic [ADDR_WIDTH-1:0]      PADDR;     //output port from rtl
    logic [DATA_WIDTH-1:0]      PWDATA;    //output port from rtl
    logic [STRB_WIDTH-1:0]      PSTRB;     //output port from rtl
    logic                       PREADY;    //input port from rtl
    logic [DATA_WIDTH-1:0]      PRDATA;    //input port from rtl

    // signal for transaction recording
    bit monstart, drvstart;

    clocking slave_cb @(posedge clk);
        default input #1step output #0;

        // Inputs from slave's perspective (monitor DUT outputs)
        input  PTRANSFER;
        input  PWRITE;
        input  PADDR;
        input  PWDATA;
        input  PSTRB;

        // Outputs from slave's perspective (drive DUT inputs)
        output PREADY;
        output PRDATA;
    endclocking

    modport slave_mp (
        // Driver uses the clocking block to drive synchronous signals
        clocking slave_cb,       

        input  PTRANSFER,
        input  PWRITE,
        input  PADDR,
        input  PWDATA,
        input  PSTRB,
        input  PRDATA,           
        input  PREADY,
    );
endinterface : apb_if