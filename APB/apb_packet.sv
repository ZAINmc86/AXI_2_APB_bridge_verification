class axi_to_apb_packet extends uvm_sequence_item;

    localparam int ADDR_WIDTH = 32;
    localparam int DATA_WIDTH = 32;
    localparam int STRB_WIDTH = DATA_WIDTH / 8;

    rand bit                  write;             // 1 = Write, 0 = Read
    rand bit [ADDR_WIDTH-1:0] addr;
    rand bit [DATA_WIDTH-1:0] data;            // Valid only for writes
    rand bit [STRB_WIDTH-1:0] strb;            // Byte strobes (write mask)

    bit                  ready;          // PREADY (0 = wait state, 1 = complete)
    bit [DATA_WIDTH-1:0] rdata;         // Valid only for reads
    bit [1:0] resp;                     // Response Channel
    bit read;                         // Read/Write Identification

    `uvm_object_utils_begin(axi_to_apb_packet)
        `uvm_field_int(write, UVM_ALL_ON)
        `uvm_field_int(addr,  UVM_ALL_ON)
        `uvm_field_int(data, UVM_ALL_ON)
        `uvm_field_int(strb,  UVM_ALL_ON)
        `uvm_field_int(ready, UVM_ALL_ON)
        `uvm_field_int(rdata, UVM_ALL_ON)
        `uvm_field_int(resp, UVM_ALL_ON)
        `uvm_field_int(read, UVM_ALL_ON)
    `uvm_object_utils_end

    function new(string name = "axi_to_apb_packet");
        super.new(name);
    endfunction

    constraint c_addr_range {
        addr inside { [0:2**ADDR_WIDTH-1] };
    }

    constraint addr_align_c { addr % 4 == 0; }

    constraint c_strb_valid {
        write -> (strb != 0);
    }

    constraint c_strb_zero_for_read {
        !write -> (strb == 0);
    }

    function void do_print(uvm_printer printer);
        super.do_print(printer);

        printer.print_field("WRITE",write,1,UVM_BIN);

        printer.print_field("ADDR",addr,32,UVM_HEX);

        printer.print_field("DATA",data,32,UVM_HEX);

        printer.print_field("STRB",strb,4,UVM_BIN);

        printer.print_field("RESP",resp,2,UVM_BIN);

        printer.print_field("READY",ready,1,UVM_BIN);

        printer.print_field("RDATA",rdata,32,UVM_HEX);

        printer.print_field("READ",read,1,UVM_BIN);
    endfunction
endclass : axi_to_apb_packet
