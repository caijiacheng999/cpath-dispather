`ifndef DISPATCHER_CFG_MONITOR__SV
`define DISPATCHER_CFG_MONITOR__SV

class dispatcher_cfg_monitor extends uvm_monitor;

    virtual dispatcher_cfg_interface m_vif;
    dispatcher_cfg_cfg               m_cfg;

    uvm_analysis_port#(dispatcher_cfg_transaction) in_ap;
    uvm_analysis_port#(dispatcher_cfg_transaction) out_ap;

    bit [`DISP_CFG_CLST_N-1:0][`DISP_CFG_CU_SUBC_N-1:0][7:0] prev_int_in_stcu;
    bit [`DISP_CFG_CLST_N-1:0][2:0]                         prev_int_in_cache;
    bit [`DISP_CFG_CLST_N-1:0]                              prev_int_in_smmu;
    bit [`DISP_CFG_CLST_N-1:0][4:0]                         prev_int_out_oaiss;
    bit                                                      prev_kernel_ack;
    bit                                                      prev_kernel_rls;

    integer cl_idx;
    integer cu_idx;
    integer cache_idx;
    integer subc_idx;

    `uvm_component_utils(dispatcher_cfg_monitor)

    extern function new(string name = "dispatcher_cfg_monitor", uvm_component parent = null);
    extern function void build_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);

    extern task sample_cfg_channels();
    extern task sample_rsp_channel();
    extern task sample_core_cfg_if();
    extern task sample_cache_cfg_if();
    extern task sample_cctrl_cfg_if();
    extern task sample_smmu_cfg_if();
    extern task sample_clst_cfg_if();
    extern task sample_cpt2disp_if();
    extern task sample_interrupts();
    extern task sample_kernel_boundary();

    extern function void send_in_tr(dispatcher_cfg_transaction tr);
    extern function void send_out_tr(dispatcher_cfg_transaction tr);

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

    prev_int_in_stcu  = m_vif.mon_cb.int_in_stcu;
    prev_int_in_cache = m_vif.mon_cb.int_in_cache;
    prev_int_in_smmu  = m_vif.mon_cb.int_in_smmu;
    prev_int_out_oaiss= m_vif.mon_cb.int_out_oaiss;
    prev_kernel_ack  = m_vif.mon_cb.kernel_ack;
    prev_kernel_rls  = m_vif.mon_cb.kernel_rls;

    forever begin
        @m_vif.mon_cb;
        sample_cfg_channels();
        sample_rsp_channel();
        sample_core_cfg_if();
        sample_cache_cfg_if();
        sample_cctrl_cfg_if();
        sample_smmu_cfg_if();
        sample_clst_cfg_if();
        sample_cpt2disp_if();
        sample_interrupts();
    end
endtask : run_phase

function void dispatcher_cfg_monitor::send_in_tr(dispatcher_cfg_transaction tr);
    `uvm_info(get_full_name(),
              $sformatf("MON-IN evt=%0d clst=%0d cu=%0d idx=%0d ts=%0t", tr.evt_kind, tr.clst_id, tr.cu_id, tr.idx_id, tr.ts),
              UVM_LOW)
    in_ap.write(tr);
endfunction : send_in_tr

function void dispatcher_cfg_monitor::send_out_tr(dispatcher_cfg_transaction tr);
    `uvm_info(get_full_name(),
              $sformatf("MON-OUT evt=%0d clst=%0d cu=%0d idx=%0d ts=%0t", tr.evt_kind, tr.clst_id, tr.cu_id, tr.idx_id, tr.ts),
              UVM_LOW)
    out_ap.write(tr);
endfunction : send_out_tr

task dispatcher_cfg_monitor::sample_cfg_channels();
    dispatcher_cfg_transaction tr;

    for (cl_idx = 0; cl_idx < `DISP_CFG_CLST_N; cl_idx = cl_idx + 1) begin
        if (m_vif.mon_cb.cfg_aw_valid[cl_idx] === 1'b1 && m_vif.mon_cb.cfg_aw_ready[cl_idx] === 1'b1) begin
            tr = dispatcher_cfg_transaction::type_id::create($sformatf("tr_cfg_aw_c%0d", cl_idx), this);
            tr.evt_kind    = DISP_EVT_CFG_AW;
            tr.clst_id     = cl_idx;
            tr.accepted    = 1'b1;
            tr.ts          = $time;
            tr.cfg_aw_addr = m_vif.mon_cb.cfg_aw_addr[cl_idx];
            send_in_tr(tr);
        end

        if (m_vif.mon_cb.cfg_w_valid[cl_idx] === 1'b1 && m_vif.mon_cb.cfg_w_ready[cl_idx] === 1'b1) begin
            tr = dispatcher_cfg_transaction::type_id::create($sformatf("tr_cfg_w_c%0d", cl_idx), this);
            tr.evt_kind   = DISP_EVT_CFG_W;
            tr.clst_id    = cl_idx;
            tr.accepted   = 1'b1;
            tr.ts         = $time;
            tr.cfg_w_data = m_vif.mon_cb.cfg_w_data[cl_idx];
            tr.cfg_w_strb = m_vif.mon_cb.cfg_w_strb[cl_idx];
            send_in_tr(tr);
        end

        if (m_vif.mon_cb.cfg_ar_valid[cl_idx] === 1'b1 && m_vif.mon_cb.cfg_ar_ready[cl_idx] === 1'b1) begin
            tr = dispatcher_cfg_transaction::type_id::create($sformatf("tr_cfg_ar_c%0d", cl_idx), this);
            tr.evt_kind    = DISP_EVT_CFG_AR;
            tr.clst_id     = cl_idx;
            tr.accepted    = 1'b1;
            tr.ts          = $time;
            tr.cfg_ar_addr = m_vif.mon_cb.cfg_ar_addr[cl_idx];
            send_in_tr(tr);
        end

        if (m_vif.mon_cb.cfg_r_valid[cl_idx] === 1'b1 && m_vif.mon_cb.cfg_r_ready[cl_idx] === 1'b1) begin
            tr = dispatcher_cfg_transaction::type_id::create($sformatf("tr_cfg_r_c%0d", cl_idx), this);
            tr.evt_kind   = DISP_EVT_CFG_R;
            tr.clst_id    = cl_idx;
            tr.accepted   = 1'b1;
            tr.ts         = $time;
            tr.cfg_r_data = m_vif.mon_cb.cfg_r_data[cl_idx];
            tr.cfg_r_resp = m_vif.mon_cb.cfg_r_resp[cl_idx];
            send_out_tr(tr);
        end

        if (m_vif.mon_cb.cfg_b_valid[cl_idx] === 1'b1 && m_vif.mon_cb.cfg_b_ready[cl_idx] === 1'b1) begin
            tr = dispatcher_cfg_transaction::type_id::create($sformatf("tr_cfg_b_c%0d", cl_idx), this);
            tr.evt_kind   = DISP_EVT_CFG_B;
            tr.clst_id    = cl_idx;
            tr.accepted   = 1'b1;
            tr.ts         = $time;
            tr.cfg_b_resp = m_vif.mon_cb.cfg_b_resp[cl_idx];
            send_out_tr(tr);
        end
    end
endtask : sample_cfg_channels

task dispatcher_cfg_monitor::sample_rsp_channel();
    dispatcher_cfg_transaction tr;

    for (cl_idx = 0; cl_idx < `DISP_CFG_CLST_N; cl_idx = cl_idx + 1) begin
        if (m_vif.mon_cb.rsp_tvalid[cl_idx] === 1'b1 && m_vif.mon_cb.rsp_tready[cl_idx] === 1'b1) begin
            tr = dispatcher_cfg_transaction::type_id::create($sformatf("tr_rsp_t_c%0d", cl_idx), this);
            tr.evt_kind  = DISP_EVT_RSP_T;
            tr.clst_id   = cl_idx;
            tr.accepted  = 1'b1;
            tr.ts        = $time;
            tr.rsp_tdata = m_vif.mon_cb.rsp_tdata[cl_idx];
            tr.rsp_tstrb = m_vif.mon_cb.rsp_tstrb[cl_idx];
            tr.rsp_tkeep = m_vif.mon_cb.rsp_tkeep[cl_idx];
            tr.rsp_tlast = m_vif.mon_cb.rsp_tlast[cl_idx];
            tr.rsp_tid   = m_vif.mon_cb.rsp_tid[cl_idx];
            tr.rsp_tdest = m_vif.mon_cb.rsp_tdest[cl_idx];
            tr.rsp_tuser = m_vif.mon_cb.rsp_tuser[cl_idx];
            send_out_tr(tr);
        end
    end
endtask : sample_rsp_channel

task dispatcher_cfg_monitor::sample_core_cfg_if();
    dispatcher_cfg_transaction tr;

    for (cl_idx = 0; cl_idx < `DISP_CFG_CLST_N; cl_idx = cl_idx + 1) begin
        for (cu_idx = 0; cu_idx < `DISP_CFG_CU_N; cu_idx = cu_idx + 1) begin
            if (m_vif.mon_cb.core_cfg_qvalid[cl_idx][cu_idx] === 1'b1 && m_vif.mon_cb.core_cfg_qready[cl_idx][cu_idx] === 1'b1) begin
                tr = dispatcher_cfg_transaction::type_id::create($sformatf("tr_core_cfg_q_c%0d_u%0d", cl_idx, cu_idx), this);
                tr.evt_kind  = DISP_EVT_CORE_CFG_Q;
                tr.clst_id   = cl_idx;
                tr.cu_id     = cu_idx;
                tr.accepted  = 1'b1;
                tr.ts        = $time;
                tr.reg_qid   = m_vif.mon_cb.core_cfg_qid[cl_idx][cu_idx];
                tr.reg_qaddr = m_vif.mon_cb.core_cfg_qaddr[cl_idx][cu_idx];
                tr.reg_qwen  = m_vif.mon_cb.core_cfg_qwen[cl_idx][cu_idx];
                tr.reg_qwdata= m_vif.mon_cb.core_cfg_qwdata[cl_idx][cu_idx];
                tr.reg_qwstrb= m_vif.mon_cb.core_cfg_qwstrb[cl_idx][cu_idx];
                send_out_tr(tr);
            end

            if (m_vif.mon_cb.core_cfg_pvalid[cl_idx][cu_idx] === 1'b1 && m_vif.mon_cb.core_cfg_pready[cl_idx][cu_idx] === 1'b1) begin
                tr = dispatcher_cfg_transaction::type_id::create($sformatf("tr_core_cfg_p_c%0d_u%0d", cl_idx, cu_idx), this);
                tr.evt_kind  = DISP_EVT_CORE_CFG_P;
                tr.clst_id   = cl_idx;
                tr.cu_id     = cu_idx;
                tr.accepted  = 1'b1;
                tr.ts        = $time;
                tr.reg_pid   = m_vif.mon_cb.core_cfg_pid[cl_idx][cu_idx];
                tr.reg_pwen  = m_vif.mon_cb.core_cfg_pwen[cl_idx][cu_idx];
                tr.reg_prdata= m_vif.mon_cb.core_cfg_prdata[cl_idx][cu_idx];
                tr.reg_perr  = m_vif.mon_cb.core_cfg_perr[cl_idx][cu_idx];
                send_in_tr(tr);
            end
        end
    end
endtask : sample_core_cfg_if

task dispatcher_cfg_monitor::sample_cache_cfg_if();
    dispatcher_cfg_transaction tr;

    for (cl_idx = 0; cl_idx < `DISP_CFG_CLST_N; cl_idx = cl_idx + 1) begin
        for (cache_idx = 0; cache_idx < `DISP_CFG_CACHE_N; cache_idx = cache_idx + 1) begin
            if (m_vif.mon_cb.cache_cfg_qvalid[cl_idx][cache_idx] === 1'b1 && m_vif.mon_cb.cache_cfg_qready[cl_idx][cache_idx] === 1'b1) begin
                tr = dispatcher_cfg_transaction::type_id::create($sformatf("tr_cache_cfg_q_c%0d_k%0d", cl_idx, cache_idx), this);
                tr.evt_kind  = DISP_EVT_CACHE_CFG_Q;
                tr.clst_id   = cl_idx;
                tr.idx_id    = cache_idx;
                tr.accepted  = 1'b1;
                tr.ts        = $time;
                tr.reg_qid   = m_vif.mon_cb.cache_cfg_qid[cl_idx][cache_idx];
                tr.reg_qaddr = m_vif.mon_cb.cache_cfg_qaddr[cl_idx][cache_idx];
                tr.reg_qwen  = m_vif.mon_cb.cache_cfg_qwen[cl_idx][cache_idx];
                tr.reg_qwdata= m_vif.mon_cb.cache_cfg_qwdata[cl_idx][cache_idx];
                tr.reg_qwstrb= m_vif.mon_cb.cache_cfg_qwstrb[cl_idx][cache_idx];
                send_out_tr(tr);
            end

            if (m_vif.mon_cb.cache_cfg_pvalid[cl_idx][cache_idx] === 1'b1 && m_vif.mon_cb.cache_cfg_pready[cl_idx][cache_idx] === 1'b1) begin
                tr = dispatcher_cfg_transaction::type_id::create($sformatf("tr_cache_cfg_p_c%0d_k%0d", cl_idx, cache_idx), this);
                tr.evt_kind  = DISP_EVT_CACHE_CFG_P;
                tr.clst_id   = cl_idx;
                tr.idx_id    = cache_idx;
                tr.accepted  = 1'b1;
                tr.ts        = $time;
                tr.reg_pid   = m_vif.mon_cb.cache_cfg_pid[cl_idx][cache_idx];
                tr.reg_pwen  = m_vif.mon_cb.cache_cfg_pwen[cl_idx][cache_idx];
                tr.reg_prdata= m_vif.mon_cb.cache_cfg_prdata[cl_idx][cache_idx];
                tr.reg_perr  = m_vif.mon_cb.cache_cfg_perr[cl_idx][cache_idx];
                send_in_tr(tr);
            end
        end
    end
endtask : sample_cache_cfg_if

task dispatcher_cfg_monitor::sample_cctrl_cfg_if();
    dispatcher_cfg_transaction tr;

    for (cl_idx = 0; cl_idx < `DISP_CFG_CLST_N; cl_idx = cl_idx + 1) begin
        if (m_vif.mon_cb.cctrl_cfg_qvalid[cl_idx] === 1'b1 && m_vif.mon_cb.cctrl_cfg_qready[cl_idx] === 1'b1) begin
            tr = dispatcher_cfg_transaction::type_id::create($sformatf("tr_cctrl_cfg_q_c%0d", cl_idx), this);
            tr.evt_kind  = DISP_EVT_CCTRL_CFG_Q;
            tr.clst_id   = cl_idx;
            tr.accepted  = 1'b1;
            tr.ts        = $time;
            tr.reg_qid   = m_vif.mon_cb.cctrl_cfg_qid[cl_idx];
            tr.reg_qaddr = m_vif.mon_cb.cctrl_cfg_qaddr[cl_idx];
            tr.reg_qwen  = m_vif.mon_cb.cctrl_cfg_qwen[cl_idx];
            tr.reg_qwdata= m_vif.mon_cb.cctrl_cfg_qwdata[cl_idx];
            tr.reg_qwstrb= m_vif.mon_cb.cctrl_cfg_qwstrb[cl_idx];
            send_out_tr(tr);
        end

        if (m_vif.mon_cb.cctrl_cfg_pvalid[cl_idx] === 1'b1 && m_vif.mon_cb.cctrl_cfg_pready[cl_idx] === 1'b1) begin
            tr = dispatcher_cfg_transaction::type_id::create($sformatf("tr_cctrl_cfg_p_c%0d", cl_idx), this);
            tr.evt_kind  = DISP_EVT_CCTRL_CFG_P;
            tr.clst_id   = cl_idx;
            tr.accepted  = 1'b1;
            tr.ts        = $time;
            tr.reg_pid   = m_vif.mon_cb.cctrl_cfg_pid[cl_idx];
            tr.reg_pwen  = m_vif.mon_cb.cctrl_cfg_pwen[cl_idx];
            tr.reg_prdata= m_vif.mon_cb.cctrl_cfg_prdata[cl_idx];
            tr.reg_perr  = m_vif.mon_cb.cctrl_cfg_perr[cl_idx];
            send_in_tr(tr);
        end
    end
endtask : sample_cctrl_cfg_if

task dispatcher_cfg_monitor::sample_smmu_cfg_if();
    dispatcher_cfg_transaction tr;

    for (cl_idx = 0; cl_idx < `DISP_CFG_CLST_N; cl_idx = cl_idx + 1) begin
        if (m_vif.mon_cb.smmu_cfg_qvalid[cl_idx] === 1'b1 && m_vif.mon_cb.smmu_cfg_qready[cl_idx] === 1'b1) begin
            tr = dispatcher_cfg_transaction::type_id::create($sformatf("tr_smmu_cfg_q_c%0d", cl_idx), this);
            tr.evt_kind  = DISP_EVT_SMMU_CFG_Q;
            tr.clst_id   = cl_idx;
            tr.accepted  = 1'b1;
            tr.ts        = $time;
            tr.reg_qid   = m_vif.mon_cb.smmu_cfg_qid[cl_idx];
            tr.reg_qaddr = m_vif.mon_cb.smmu_cfg_qaddr[cl_idx];
            tr.reg_qwen  = m_vif.mon_cb.smmu_cfg_qwen[cl_idx];
            tr.reg_qwdata= m_vif.mon_cb.smmu_cfg_qwdata[cl_idx];
            tr.reg_qwstrb= m_vif.mon_cb.smmu_cfg_qwstrb[cl_idx];
            send_out_tr(tr);
        end

        if (m_vif.mon_cb.smmu_cfg_pvalid[cl_idx] === 1'b1 && m_vif.mon_cb.smmu_cfg_pready[cl_idx] === 1'b1) begin
            tr = dispatcher_cfg_transaction::type_id::create($sformatf("tr_smmu_cfg_p_c%0d", cl_idx), this);
            tr.evt_kind  = DISP_EVT_SMMU_CFG_P;
            tr.clst_id   = cl_idx;
            tr.accepted  = 1'b1;
            tr.ts        = $time;
            tr.reg_pid   = m_vif.mon_cb.smmu_cfg_pid[cl_idx];
            tr.reg_pwen  = m_vif.mon_cb.smmu_cfg_pwen[cl_idx];
            tr.reg_prdata= m_vif.mon_cb.smmu_cfg_prdata[cl_idx];
            tr.reg_perr  = m_vif.mon_cb.smmu_cfg_perr[cl_idx];
            send_in_tr(tr);
        end
    end
endtask : sample_smmu_cfg_if

task dispatcher_cfg_monitor::sample_clst_cfg_if();
    dispatcher_cfg_transaction tr;

    for (cl_idx = 0; cl_idx < `DISP_CFG_CLST_N; cl_idx = cl_idx + 1) begin
        if (m_vif.mon_cb.clst_cfg_qvalid[cl_idx] === 1'b1 && m_vif.mon_cb.clst_cfg_qready[cl_idx] === 1'b1) begin
            tr = dispatcher_cfg_transaction::type_id::create($sformatf("tr_clst_cfg_q_c%0d", cl_idx), this);
            tr.evt_kind  = DISP_EVT_CLST_CFG_Q;
            tr.clst_id   = cl_idx;
            tr.accepted  = 1'b1;
            tr.ts        = $time;
            tr.reg_qid   = m_vif.mon_cb.clst_cfg_qid[cl_idx];
            tr.reg_qaddr = m_vif.mon_cb.clst_cfg_qaddr[cl_idx];
            tr.reg_qwen  = m_vif.mon_cb.clst_cfg_qwen[cl_idx];
            tr.reg_qwdata= m_vif.mon_cb.clst_cfg_qwdata[cl_idx];
            tr.reg_qwstrb= m_vif.mon_cb.clst_cfg_qwstrb[cl_idx];
            send_out_tr(tr);
        end

        if (m_vif.mon_cb.clst_cfg_pvalid[cl_idx] === 1'b1 && m_vif.mon_cb.clst_cfg_pready[cl_idx] === 1'b1) begin
            tr = dispatcher_cfg_transaction::type_id::create($sformatf("tr_clst_cfg_p_c%0d", cl_idx), this);
            tr.evt_kind  = DISP_EVT_CLST_CFG_P;
            tr.clst_id   = cl_idx;
            tr.accepted  = 1'b1;
            tr.ts        = $time;
            tr.reg_pid   = m_vif.mon_cb.clst_cfg_pid[cl_idx];
            tr.reg_pwen  = m_vif.mon_cb.clst_cfg_pwen[cl_idx];
            tr.reg_prdata= m_vif.mon_cb.clst_cfg_prdata[cl_idx];
            tr.reg_perr  = m_vif.mon_cb.clst_cfg_perr[cl_idx];
            send_in_tr(tr);
        end
    end
endtask : sample_clst_cfg_if

task dispatcher_cfg_monitor::sample_cpt2disp_if();
    dispatcher_cfg_transaction tr;

    for (cl_idx = 0; cl_idx < `DISP_CFG_CLST_N; cl_idx = cl_idx + 1) begin
        for (cu_idx = 0; cu_idx < `DISP_CFG_CU_N; cu_idx = cu_idx + 1) begin
            if (m_vif.mon_cb.cpt2disp_disp_qvld[cl_idx][cu_idx] === 1'b1 && m_vif.mon_cb.cpt2disp_disp_qrdy[cl_idx][cu_idx] === 1'b1) begin
                tr = dispatcher_cfg_transaction::type_id::create($sformatf("tr_cpt_disp_q_c%0d_u%0d", cl_idx, cu_idx), this);
                tr.evt_kind = DISP_EVT_CPT_DISP_Q;
                tr.clst_id  = cl_idx;
                tr.cu_id    = cu_idx;
                tr.accepted = 1'b1;
                tr.ts       = $time;
                tr.cpt_qbid = m_vif.mon_cb.cpt2disp_disp_qbid[cl_idx][cu_idx];
                send_in_tr(tr);
            end

            if (m_vif.mon_cb.cpt2disp_lkup_qvld[cl_idx][cu_idx] === 1'b1 && m_vif.mon_cb.cpt2disp_lkup_qrdy[cl_idx][cu_idx] === 1'b1) begin
                tr = dispatcher_cfg_transaction::type_id::create($sformatf("tr_cpt_lkup_q_c%0d_u%0d", cl_idx, cu_idx), this);
                tr.evt_kind = DISP_EVT_CPT_LKUP_Q;
                tr.clst_id  = cl_idx;
                tr.cu_id    = cu_idx;
                tr.accepted = 1'b1;
                tr.ts       = $time;
                tr.cpt_qbid = m_vif.mon_cb.cpt2disp_lkup_qbid[cl_idx][cu_idx];
                send_in_tr(tr);
            end

            if (m_vif.mon_cb.cpt2disp_sync_qvld[cl_idx][cu_idx] === 1'b1 && m_vif.mon_cb.cpt2disp_sync_qrdy[cl_idx][cu_idx] === 1'b1) begin
                tr = dispatcher_cfg_transaction::type_id::create($sformatf("tr_cpt_sync_q_c%0d_u%0d", cl_idx, cu_idx), this);
                tr.evt_kind = DISP_EVT_CPT_SYNC_Q;
                tr.clst_id  = cl_idx;
                tr.cu_id    = cu_idx;
                tr.accepted = 1'b1;
                tr.ts       = $time;
                tr.cpt_qbid = m_vif.mon_cb.cpt2disp_sync_qbid[cl_idx][cu_idx];
                send_in_tr(tr);
            end
        end
    end
endtask : sample_cpt2disp_if

task dispatcher_cfg_monitor::sample_interrupts();
    dispatcher_cfg_transaction tr;

    for (cl_idx = 0; cl_idx < `DISP_CFG_CLST_N; cl_idx = cl_idx + 1) begin
        for (subc_idx = 0; subc_idx < `DISP_CFG_CU_SUBC_N; subc_idx = subc_idx + 1) begin
            if (m_vif.mon_cb.int_in_stcu[cl_idx][subc_idx] != prev_int_in_stcu[cl_idx][subc_idx]) begin
                tr = dispatcher_cfg_transaction::type_id::create($sformatf("tr_int_stcu_c%0d_s%0d", cl_idx, subc_idx), this);
                tr.evt_kind      = DISP_EVT_INT_STCU;
                tr.clst_id       = cl_idx;
                tr.idx_id        = subc_idx;
                tr.accepted      = 1'b1;
                tr.ts            = $time;
                tr.stcu_int_data = m_vif.mon_cb.int_in_stcu[cl_idx][subc_idx];
                send_in_tr(tr);
            end
        end

        if (m_vif.mon_cb.int_in_cache[cl_idx] != prev_int_in_cache[cl_idx]) begin
            tr = dispatcher_cfg_transaction::type_id::create($sformatf("tr_int_cache_c%0d", cl_idx), this);
            tr.evt_kind       = DISP_EVT_INT_CACHE;
            tr.clst_id        = cl_idx;
            tr.accepted       = 1'b1;
            tr.ts             = $time;
            tr.cache_int_data = m_vif.mon_cb.int_in_cache[cl_idx];
            send_in_tr(tr);
        end

        if (m_vif.mon_cb.int_in_smmu[cl_idx] != prev_int_in_smmu[cl_idx]) begin
            tr = dispatcher_cfg_transaction::type_id::create($sformatf("tr_int_smmu_c%0d", cl_idx), this);
            tr.evt_kind      = DISP_EVT_INT_SMMU;
            tr.clst_id       = cl_idx;
            tr.accepted      = 1'b1;
            tr.ts            = $time;
            tr.smmu_int_data = m_vif.mon_cb.int_in_smmu[cl_idx];
            send_in_tr(tr);
        end

        if (m_vif.mon_cb.int_out_oaiss[cl_idx] != prev_int_out_oaiss[cl_idx]) begin
            tr = dispatcher_cfg_transaction::type_id::create($sformatf("tr_int_oaiss_c%0d", cl_idx), this);
            tr.evt_kind       = DISP_EVT_INT_OAISS;
            tr.clst_id        = cl_idx;
            tr.accepted       = 1'b1;
            tr.ts             = $time;
            tr.oaiss_int_data = m_vif.mon_cb.int_out_oaiss[cl_idx];
            send_out_tr(tr);
        end
    end

    prev_int_in_stcu   = m_vif.mon_cb.int_in_stcu;
    prev_int_in_cache  = m_vif.mon_cb.int_in_cache;
    prev_int_in_smmu   = m_vif.mon_cb.int_in_smmu;
    prev_int_out_oaiss = m_vif.mon_cb.int_out_oaiss;
endtask : sample_interrupts

task dispatcher_cfg_monitor::sample_kernel_boundary();
    dispatcher_cfg_transaction tr;

    if (m_vif.mon_cb.kernel_ack != prev_kernel_ack) begin
        tr = dispatcher_cfg_transaction::type_id::create("tr_kernel_ack", this);
        tr.evt_kind   = DISP_EVT_KNL_ACK;
        tr.accepted   = 1'b1;
        tr.ts         = $time;
        tr.kernel_ack = m_vif.mon_cb.kernel_ack;
        send_out_tr(tr);
    end

    if (m_vif.mon_cb.kernel_rls != prev_kernel_rls) begin
        tr = dispatcher_cfg_transaction::type_id::create("tr_kernel_rls", this);
        tr.evt_kind   = DISP_EVT_KNL_RLS;
        tr.accepted   = 1'b1;
        tr.ts         = $time;
        tr.kernel_rls = m_vif.mon_cb.kernel_rls;
        send_out_tr(tr);
    end

    prev_kernel_ack = m_vif.mon_cb.kernel_ack;
    prev_kernel_rls = m_vif.mon_cb.kernel_rls;
endtask : sample_kernel_boundary

`endif
