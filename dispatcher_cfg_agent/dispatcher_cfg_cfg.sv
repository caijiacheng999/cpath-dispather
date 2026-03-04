`ifndef DISPATCHER_CFG_CFG__SV
`define DISPATCHER_CFG_CFG__SV

class dispatcher_cfg_cfg extends uvm_object;

    bit has_drv;
    bit has_mon;
    bit has_slv;
    bit has_scb;

    bit enable_pair_check;

    `uvm_object_utils_begin(dispatcher_cfg_cfg)
        `uvm_field_int(has_drv,           UVM_ALL_ON)
        `uvm_field_int(has_mon,           UVM_ALL_ON)
        `uvm_field_int(has_slv,           UVM_ALL_ON)
        `uvm_field_int(has_scb,           UVM_ALL_ON)
        `uvm_field_int(enable_pair_check, UVM_ALL_ON)
    `uvm_object_utils_end

    extern function new(string name = "dispatcher_cfg_cfg");
    extern function void init(string mode = "monitor_only");

endclass : dispatcher_cfg_cfg

function dispatcher_cfg_cfg::new(string name = "dispatcher_cfg_cfg");
    super.new(name);
    init();
endfunction : new

function void dispatcher_cfg_cfg::init(string mode = "monitor_only");
    has_drv           = 0;
    has_mon           = 1;
    has_slv           = 0;
    has_scb           = 1;
    enable_pair_check = 0;

    if (mode == "active") begin
        has_drv = 1;
    end
endfunction : init

`endif
