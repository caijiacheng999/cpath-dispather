`ifndef DISPATCHER_CFG_SEQUENCER__SV
`define DISPATCHER_CFG_SEQUENCER__SV

class dispatcher_cfg_sequencer extends uvm_sequencer#(dispatcher_cfg_transaction);

    `uvm_component_utils(dispatcher_cfg_sequencer)

    extern function new(string name = "dispatcher_cfg_sequencer", uvm_component parent = null);

endclass : dispatcher_cfg_sequencer

function dispatcher_cfg_sequencer::new(string name = "dispatcher_cfg_sequencer", uvm_component parent = null);
    super.new(name, parent);
endfunction : new

`endif
