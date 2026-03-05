`ifndef DISPATCHER_CFG_AGENT__SV
`define DISPATCHER_CFG_AGENT__SV

class dispatcher_cfg_agent extends uvm_agent;

    dispatcher_cfg_cfg        m_cfg;
    dispatcher_cfg_driver     m_drv;
    dispatcher_cfg_monitor    m_mon;
    dispatcher_cfg_slave      m_slv;
    dispatcher_cfg_sequencer  m_sqr;
    dispatcher_cfg_scb        m_scb;

    virtual dispatcher_cfg_interface m_vif;

    uvm_analysis_port#(dispatcher_cfg_transaction) in_ap;
    uvm_analysis_port#(dispatcher_cfg_transaction) out_ap;

    `uvm_component_utils(dispatcher_cfg_agent)

    extern function new(string name = "dispatcher_cfg_agent", uvm_component parent = null);
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);

endclass : dispatcher_cfg_agent

function dispatcher_cfg_agent::new(string name = "dispatcher_cfg_agent", uvm_component parent = null);
    super.new(name, parent);
endfunction : new

function void dispatcher_cfg_agent::build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db#(virtual dispatcher_cfg_interface)::get(this, "", "m_vif", m_vif)) begin
        `uvm_error(get_type_name(), "Could not get dispatcher_cfg_interface!")
    end

    if (!uvm_config_db#(dispatcher_cfg_cfg)::get(this, "", "m_cfg", m_cfg)) begin
        m_cfg = dispatcher_cfg_cfg::type_id::create("m_cfg");
        m_cfg.init("monitor_only");
        `uvm_warning(get_type_name(), "Could not get dispatcher_cfg_cfg, using default")
    end

    uvm_config_db#(dispatcher_cfg_cfg)::set(this, "*", "m_cfg", m_cfg);
    uvm_config_db#(virtual dispatcher_cfg_interface)::set(this, "*", "m_vif", m_vif);

    if (m_cfg.has_drv == 1) begin
        m_drv = dispatcher_cfg_driver::type_id::create("m_drv", this);
        m_sqr = dispatcher_cfg_sequencer::type_id::create("m_sqr", this);
    end

    if (m_cfg.has_mon == 1) begin
        m_mon = dispatcher_cfg_monitor::type_id::create("m_mon", this);
    end

    if (m_cfg.has_slv == 1) begin
        m_slv = dispatcher_cfg_slave::type_id::create("m_slv", this);
    end

    if (m_cfg.has_scb == 1) begin
        m_scb = dispatcher_cfg_scb::type_id::create("m_scb", this);
    end
endfunction : build_phase

function void dispatcher_cfg_agent::connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    if (m_cfg.has_drv == 1) begin
        m_drv.seq_item_port.connect(m_sqr.seq_item_export);
    end

    if (m_cfg.has_mon == 1) begin
        in_ap  = m_mon.in_ap;
        out_ap = m_mon.out_ap;
    end

    if (m_cfg.has_mon == 1 && m_cfg.has_scb == 1) begin
        m_mon.in_ap.connect(m_scb.in_imp);
        m_mon.out_ap.connect(m_scb.out_imp);
    end
endfunction : connect_phase

`endif
