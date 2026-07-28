class apb_monitor extends uvm_monitor;
    `uvm_component_utils(apb_monitor)

    virtual apb_if.slave_mp vif;
    bit transfer_detected;

    function new(string name = "apb_monitor" , uvm_component parent);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db #(virtual apb_if.slave_mp)::get(this, "", "vif", vif))
            `uvm_fatal(get_type_name(), "No virtual interface (vif) found in config DB")
    endfunction

    task run_phase(uvm_phase phase);
        `uvm_info(get_type_name(),"You are in the monitor.", UVM_LOW)
        forever begin
            collect_packets();
        end
    endtask

    task collect_packets();
        apb_packet pkt;
        `uvm_info(get_type_name(), "collect_transfer: waiting for PTRANSFER", UVM_LOW)
        @(posedge vif.clk); // iff vif.slave_cb.PTRANSFER == 1'd1);
        if(vif.slave_cb.PTRANSFER == 1'd1)
        `uvm_info(get_type_name(), "collect_transfer: PTRANSFER detected!", UVM_LOW)

        `uvm_info(get_type_name(),
              $sformatf("RAW APB SIGNALS:\n  PWRITE = %b\n  PADDR  = 0x%08h\n  PWDATA = 0x%08h\n  PSTRB  = 0x%0h\n  PREADY = %b\n  PRDATA = 0x%08h",
                        vif.slave_cb.PWRITE,
                        vif.slave_cb.PADDR,
                        vif.slave_cb.PWDATA,
                        vif.slave_cb.PSTRB,
                        vif.slave_cb.PREADY,
                        vif.slave_cb.PRDATA),
              UVM_LOW)

        pkt = apb_packet::type_id::create("pkt");
        pkt.write = vif.slave_cb.PWRITE;
        pkt.addr  = vif.slave_cb.PADDR;
        pkt.wdata = vif.slave_cb.PWDATA;
        pkt.strb  = vif.slave_cb.PSTRB;
        pkt.ready = vif.slave_cb.PREADY;   
        pkt.rdata = vif.slave_cb.PRDATA;   
        transfer_detected = 1'b1;

        `uvm_info(get_type_name(),
                  $sformatf("Collected APB transfer:\n%s", pkt.convert2string()),
                  UVM_MEDIUM)
        
        @(posedge vif.clk iff vif.slave_cb.PTRANSFER == 1'b0);

        `uvm_info(get_type_name(), "Transfer ended", UVM_DEBUG)
    endtask

    function void start_of_simulation_phase(uvm_phase phase);
        `uvm_info(get_type_name(),"Running Simulation---", UVM_HIGH)
    endfunction
endclass