class apb_driver extends uvm_driver #(apb_packet);
    `uvm_component_utils(apb_driver)

    function new(string name = "apb_driver", uvm_component parent);
        super.new(name,parent);
    endfunction

    task run_phase(uvm_phase phase);
        forever begin
            apb_packet pkt;
            seq_item_port.get_next_item(pkt);
            send_to_dut(pkt);
            seq_item_port.item_done();

            // `uvm_do(req)
        end
    endtask

    task send_to_dut(apb_packet pkt);
        `uvm_info(get_type_name(), $sformatf("Packet is \n%s", pkt.sprint()), UVM_LOW)
        #10ns;
    endtask
    function void start_of_simulation_phase(uvm_phase phase);
        `uvm_info(get_type_name(),"Running Simulation---", UVM_HIGH)
    endfunction
    function void start_of_simulation_phase(uvm_phase phase);
        `uvm_info(get_type_name(),"Running Simulation---", UVM_HIGH)
    endfunction
endclass