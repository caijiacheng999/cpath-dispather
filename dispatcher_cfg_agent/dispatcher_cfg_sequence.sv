`ifndef DISPATCHER_CFG_SEQUENCE__SV
`define DISPATCHER_CFG_SEQUENCE__SV

class dispatcher_cfg_sequence extends uvm_sequence#(dispatcher_cfg_transaction);

    `uvm_object_utils(dispatcher_cfg_sequence)

    extern function new(string name = "dispatcher_cfg_sequence");
    extern task body();

endclass : dispatcher_cfg_sequence

function dispatcher_cfg_sequence::new(string name = "dispatcher_cfg_sequence");
    super.new(name);
endfunction : new

task dispatcher_cfg_sequence::body();
    `uvm_info(get_type_name(), "dispatcher_cfg_sequence placeholder body", UVM_LOW)
endtask : body

`endif
