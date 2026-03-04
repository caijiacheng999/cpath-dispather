`ifndef DISPATCHER_CFG_TRANSACTION__SV
`define DISPATCHER_CFG_TRANSACTION__SV

typedef enum int {
    DISP_EVT_CFG_AW = 0,
    DISP_EVT_CFG_W  = 1,
    DISP_EVT_CORE_Q = 2
} dispatcher_cfg_evt_e;

class dispatcher_cfg_transaction extends uvm_sequence_item;

    dispatcher_cfg_evt_e evt_kind;

    int unsigned clst_id;
    int unsigned cu_id;

    bit accepted;
    time ts;

    bit [`DISP_CFG_CFG_ADDR_W-1:0]  cfg_aw_addr;
    bit [`DISP_CFG_CFG_DATA_W-1:0]  cfg_w_data;
    bit [`DISP_CFG_CFG_STRB_W-1:0]  cfg_w_strb;

    bit [`DISP_CFG_CORE_ID_W-1:0]   core_qid;
    bit [`DISP_CFG_CORE_ADDR_W-1:0] core_qaddr;
    bit [`DISP_CFG_CORE_DATA_W-1:0] core_qwdata;
    bit [`DISP_CFG_CORE_STRB_W-1:0] core_qwstrb;
    bit                              core_qwen;

    `uvm_object_utils_begin(dispatcher_cfg_transaction)
        `uvm_field_enum(dispatcher_cfg_evt_e, evt_kind, UVM_ALL_ON)
        `uvm_field_int(clst_id,      UVM_ALL_ON)
        `uvm_field_int(cu_id,        UVM_ALL_ON)
        `uvm_field_int(accepted,     UVM_ALL_ON)
        `uvm_field_int(cfg_aw_addr,  UVM_ALL_ON)
        `uvm_field_int(cfg_w_data,   UVM_ALL_ON)
        `uvm_field_int(cfg_w_strb,   UVM_ALL_ON)
        `uvm_field_int(core_qid,     UVM_ALL_ON)
        `uvm_field_int(core_qaddr,   UVM_ALL_ON)
        `uvm_field_int(core_qwdata,  UVM_ALL_ON)
        `uvm_field_int(core_qwstrb,  UVM_ALL_ON)
        `uvm_field_int(core_qwen,    UVM_ALL_ON)
    `uvm_object_utils_end

    extern function new(string name = "dispatcher_cfg_transaction");

endclass : dispatcher_cfg_transaction

function dispatcher_cfg_transaction::new(string name = "dispatcher_cfg_transaction");
    super.new(name);
    evt_kind    = DISP_EVT_CFG_AW;
    clst_id     = 0;
    cu_id       = 0;
    accepted    = 0;
    ts          = 0;
    cfg_aw_addr = '0;
    cfg_w_data  = '0;
    cfg_w_strb  = '0;
    core_qid    = '0;
    core_qaddr  = '0;
    core_qwdata = '0;
    core_qwstrb = '0;
    core_qwen   = '0;
endfunction : new

`endif
