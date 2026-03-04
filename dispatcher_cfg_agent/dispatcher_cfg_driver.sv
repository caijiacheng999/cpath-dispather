`ifndef DISPATCHER_CFG_DRIVER__SV
`define DISPATCHER_CFG_DRIVER__SV

class dispatcher_cfg_driver extends uvm_driver#(dispatcher_cfg_transaction);

    virtual dispatcher_cfg_interface m_vif;
    dispatcher_cfg_cfg               m_cfg;

    `uvm_component_utils(dispatcher_cfg_driver)

    extern function new(string name = "dispatcher_cfg_driver", uvm_component parent = null);
    extern function void build_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);

endclass : dispatcher_cfg_driver

function dispatcher_cfg_driver::new(string name = "dispatcher_cfg_driver", uvm_component parent = null);
    super.new(name, parent);
endfunction : new

function void dispatcher_cfg_driver::build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db#(virtual dispatcher_cfg_interface)::get(this, "", "m_vif", m_vif)) begin
        `uvm_error(get_type_name(), "Could not get dispatcher_cfg_interface!")
    end

    if (!uvm_config_db#(dispatcher_cfg_cfg)::get(this, "", "m_cfg", m_cfg)) begin
        m_cfg = dispatcher_cfg_cfg::type_id::create("m_cfg");
        m_cfg.init("monitor_only");
    end
endfunction : build_phase

task dispatcher_cfg_driver::run_phase(uvm_phase phase);
    forever begin
        @(posedge m_vif.clk);
    end
endtask : run_phase

`endif
