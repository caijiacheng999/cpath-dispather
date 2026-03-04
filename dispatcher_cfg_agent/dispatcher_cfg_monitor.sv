`ifndef DISPATCHER_CFG_MONITOR__SV
`define DISPATCHER_CFG_MONITOR__SV

class dispatcher_cfg_monitor extends uvm_monitor;

    virtual dispatcher_cfg_interface m_vif;
    dispatcher_cfg_cfg               m_cfg;

    uvm_analysis_port#(dispatcher_cfg_transaction) in_ap;
    uvm_analysis_port#(dispatcher_cfg_transaction) out_ap;

    `uvm_component_utils(dispatcher_cfg_monitor)

    extern function new(string name = "dispatcher_cfg_monitor", uvm_component parent = null);
    extern function void build_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);
    extern task sample_cfg_aw();
    extern task sample_cfg_w();
    extern task sample_core_q();

endclass : dispatcher_cfg_monitor

function dispatcher_cfg_monitor::new(string name = "dispatcher_cfg_monitor", uvm_component parent = null);
    super.new(name, parent);
endfunction : new

function void dispatcher_cfg_monitor::build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db#(virtual dispatcher_cfg_interface)::get(this, "", "m_vif", m_vif)) begin
        `uvm_error(get_type_name(), "Could not get dispatcher_cfg_interface!")
    end

    if (!uvm_config_db#(dispatcher_cfg_cfg)::get(this, "", "m_cfg", m_cfg)) begin
        m_cfg = dispatcher_cfg_cfg::type_id::create("m_cfg");
        m_cfg.init("monitor_only");
        `uvm_warning(get_type_name(), "Could not get dispatcher_cfg_cfg, using default")
    end

    in_ap  = new("in_ap", this);
    out_ap = new("out_ap", this);
endfunction : build_phase

task dispatcher_cfg_monitor::run_phase(uvm_phase phase);
    @(posedge m_vif.rst_n);

    forever begin
        @m_vif.mon_cb;
        sample_cfg_aw();
        sample_cfg_w();
        sample_core_q();
    end
endtask : run_phase

task dispatcher_cfg_monitor::sample_cfg_aw();
    dispatcher_cfg_transaction tr;

    for (int cl = 0; cl < `DISP_CFG_CLST_N; cl++) begin
        if (m_vif.mon_cb.cfg_aw_valid[cl] === 1'b1 && m_vif.mon_cb.cfg_aw_ready[cl] === 1'b1) begin
            tr = dispatcher_cfg_transaction::type_id::create($sformatf("tr_cfg_aw_c%0d", cl), this);
            tr.evt_kind    = DISP_EVT_CFG_AW;
            tr.clst_id     = cl;
            tr.cu_id       = 0;
            tr.accepted    = 1'b1;
            tr.ts          = $time;
            tr.cfg_aw_addr = m_vif.mon_cb.cfg_aw_addr[cl];
            in_ap.write(tr);
        end
    end
endtask : sample_cfg_aw

task dispatcher_cfg_monitor::sample_cfg_w();
    dispatcher_cfg_transaction tr;

    for (int cl = 0; cl < `DISP_CFG_CLST_N; cl++) begin
        if (m_vif.mon_cb.cfg_w_valid[cl] === 1'b1 && m_vif.mon_cb.cfg_w_ready[cl] === 1'b1) begin
            tr = dispatcher_cfg_transaction::type_id::create($sformatf("tr_cfg_w_c%0d", cl), this);
            tr.evt_kind   = DISP_EVT_CFG_W;
            tr.clst_id    = cl;
            tr.cu_id      = 0;
            tr.accepted   = 1'b1;
            tr.ts         = $time;
            tr.cfg_w_data = m_vif.mon_cb.cfg_w_data[cl];
            tr.cfg_w_strb = m_vif.mon_cb.cfg_w_strb[cl];
            in_ap.write(tr);
        end
    end
endtask : sample_cfg_w

task dispatcher_cfg_monitor::sample_core_q();
    dispatcher_cfg_transaction tr;

    for (int cl = 0; cl < `DISP_CFG_CLST_N; cl++) begin
        for (int cu = 0; cu < `DISP_CFG_CU_N; cu++) begin
            if (m_vif.mon_cb.core_qvalid[cl][cu] === 1'b1 &&
                m_vif.mon_cb.core_qready[cl][cu] === 1'b1 &&
                m_vif.mon_cb.core_qwen[cl][cu]   === 1'b1) begin
                tr = dispatcher_cfg_transaction::type_id::create($sformatf("tr_core_q_c%0d_u%0d", cl, cu), this);
                tr.evt_kind    = DISP_EVT_CORE_Q;
                tr.clst_id     = cl;
                tr.cu_id       = cu;
                tr.accepted    = 1'b1;
                tr.ts          = $time;
                tr.core_qid    = m_vif.mon_cb.core_qid[cl][cu];
                tr.core_qaddr  = m_vif.mon_cb.core_qaddr[cl][cu];
                tr.core_qwen   = m_vif.mon_cb.core_qwen[cl][cu];
                tr.core_qwdata = m_vif.mon_cb.core_qwdata[cl][cu];
                tr.core_qwstrb = m_vif.mon_cb.core_qwstrb[cl][cu];
                out_ap.write(tr);
            end
        end
    end
endtask : sample_core_q

`endif
