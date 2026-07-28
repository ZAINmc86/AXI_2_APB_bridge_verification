module top;
    import uvm_pkg::*;    
    `include "uvm_macros.svh"

    import apb_pkg::*;
    `include "bridge_tb.sv"
    `include "bridge_test_lib.sv"

    hw_top hwtop(.*);

    initial begin
        apb_vif_config::set(null, "*.tb.env.agent.monitor","vif", hwtop.apb);
        ap_vif_config::set(null, "*.tb.env.agent.driver","vif", hwtop.apb);
        run_test();
    end
endmodule : top