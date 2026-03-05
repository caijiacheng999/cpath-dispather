`ifndef DISPATCHER_CFG_SLAVE__SV
`define DISPATCHER_CFG_SLAVE__SV

class dispatcher_cfg_slave extends uvm_component;

    virtual dispatcher_cfg_interface m_vif;
    dispatcher_cfg_cfg               m_cfg;

    `uvm_component_utils(dispatcher_cfg_slave)

    extern function new(string name = "dispatcher_cfg_slave", uvm_component parent = null);
    extern function void build_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);

endclass : dispatcher_cfg_slave

function dispatcher_cfg_slave::new(string name = "dispatcher_cfg_slave", uvm_component parent = null);
    super.new(name, parent);
endfunction : new

function void dispatcher_cfg_slave::build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db#(virtual dispatcher_cfg_interface)::get(this, "", "m_vif", m_vif)) begin
        `uvm_error(get_type_name(), "Could not get dispatcher_cfg_interface!")
    end

    if (!uvm_config_db#(dispatcher_cfg_cfg)::get(this, "", "m_cfg", m_cfg)) begin
        m_cfg = dispatcher_cfg_cfg::type_id::create("m_cfg");
        m_cfg.init("monitor_only");
    end
endfunction : build_phase

task dispatcher_cfg_slave::run_phase(uvm_phase phase);
    forever begin
        @m_vif.mon_cb;
    end
endtask : run_phase

`endif
