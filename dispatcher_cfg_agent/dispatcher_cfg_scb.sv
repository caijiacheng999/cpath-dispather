`ifndef DISPATCHER_CFG_SCB__SV
`define DISPATCHER_CFG_SCB__SV

`uvm_analysis_imp_decl(_in)
`uvm_analysis_imp_decl(_out)

class dispatcher_cfg_scb extends uvm_component;

    dispatcher_cfg_cfg m_cfg;

    uvm_analysis_imp_in#(dispatcher_cfg_transaction, dispatcher_cfg_scb)  in_imp;
    uvm_analysis_imp_out#(dispatcher_cfg_transaction, dispatcher_cfg_scb) out_imp;

    dispatcher_cfg_transaction in_q[$];
    dispatcher_cfg_transaction out_q[$];

    int unsigned in_cnt;
    int unsigned out_cnt;

    `uvm_component_utils(dispatcher_cfg_scb)

    extern function new(string name = "dispatcher_cfg_scb", uvm_component parent = null);
    extern function void build_phase(uvm_phase phase);

    extern function void write_in(dispatcher_cfg_transaction tr);
    extern function void write_out(dispatcher_cfg_transaction tr);

endclass : dispatcher_cfg_scb

function dispatcher_cfg_scb::new(string name = "dispatcher_cfg_scb", uvm_component parent = null);
    super.new(name, parent);
endfunction : new

function void dispatcher_cfg_scb::build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db#(dispatcher_cfg_cfg)::get(this, "", "m_cfg", m_cfg)) begin
        m_cfg = dispatcher_cfg_cfg::type_id::create("m_cfg");
        m_cfg.init("monitor_only");
        `uvm_warning(get_type_name(), "Could not get dispatcher_cfg_cfg, using default")
    end

    in_imp  = new("in_imp", this);
    out_imp = new("out_imp", this);

    in_cnt  = 0;
    out_cnt = 0;
endfunction : build_phase

function void dispatcher_cfg_scb::write_in(dispatcher_cfg_transaction tr);
    dispatcher_cfg_transaction cpy;
    cpy = dispatcher_cfg_transaction::type_id::create("in_cpy");
    cpy.copy(tr);
    in_q.push_back(cpy);
    in_cnt++;

    `uvm_info(get_full_name(),
              $sformatf("SCB-IN evt=%0d clst=%0d cu=%0d idx=%0d qaddr=0x%0h qdata=0x%0h ts=%0t in_cnt=%0d",
                        tr.evt_kind, tr.clst_id, tr.cu_id, tr.idx_id, tr.reg_qaddr, tr.reg_qwdata, tr.ts, in_cnt),
              UVM_LOW)
endfunction : write_in

function void dispatcher_cfg_scb::write_out(dispatcher_cfg_transaction tr);
    dispatcher_cfg_transaction cpy;
    cpy = dispatcher_cfg_transaction::type_id::create("out_cpy");
    cpy.copy(tr);
    out_q.push_back(cpy);
    out_cnt++;

    `uvm_info(get_full_name(),
              $sformatf("SCB-OUT evt=%0d clst=%0d cu=%0d idx=%0d qaddr=0x%0h qdata=0x%0h ts=%0t out_cnt=%0d",
                        tr.evt_kind, tr.clst_id, tr.cu_id, tr.idx_id, tr.reg_qaddr, tr.reg_qwdata, tr.ts, out_cnt),
              UVM_LOW)
endfunction : write_out

`endif
