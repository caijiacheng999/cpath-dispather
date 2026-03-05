`ifndef DISPATCHER_CFG_TRANSACTION__SV
`define DISPATCHER_CFG_TRANSACTION__SV

typedef enum int {
    DISP_EVT_CFG_AW      = 0,
    DISP_EVT_CFG_W       = 1,
    DISP_EVT_CFG_AR      = 2,
    DISP_EVT_CFG_R       = 3,
    DISP_EVT_CFG_B       = 4,
    DISP_EVT_RSP_T       = 5,
    DISP_EVT_CORE_CFG_Q  = 6,
    DISP_EVT_CORE_CFG_P  = 7,
    DISP_EVT_CACHE_CFG_Q = 8,
    DISP_EVT_CACHE_CFG_P = 9,
    DISP_EVT_CCTRL_CFG_Q = 10,
    DISP_EVT_CCTRL_CFG_P = 11,
    DISP_EVT_SMMU_CFG_Q  = 12,
    DISP_EVT_SMMU_CFG_P  = 13,
    DISP_EVT_CLST_CFG_Q  = 14,
    DISP_EVT_CLST_CFG_P  = 15,
    DISP_EVT_CPT_DISP_Q  = 16,
    DISP_EVT_CPT_LKUP_Q  = 17,
    DISP_EVT_CPT_SYNC_Q  = 18,
    DISP_EVT_INT_STCU    = 19,
    DISP_EVT_INT_CACHE   = 20,
    DISP_EVT_INT_SMMU    = 21,
    DISP_EVT_INT_OAISS   = 22
} dispatcher_cfg_evt_e;

class dispatcher_cfg_transaction extends uvm_sequence_item;

    dispatcher_cfg_evt_e evt_kind;

    int unsigned clst_id;
    int unsigned cu_id;
    int unsigned idx_id;

    bit accepted;
    time ts;

    bit [`DISP_CFG_CFG_ADDR_W-1:0]  cfg_aw_addr;
    bit [`DISP_CFG_CFG_DATA_W-1:0]  cfg_w_data;
    bit [`DISP_CFG_CFG_STRB_W-1:0]  cfg_w_strb;
    bit [`DISP_CFG_CFG_ADDR_W-1:0]  cfg_ar_addr;
    bit [`DISP_CFG_CFG_DATA_W-1:0]  cfg_r_data;
    bit [1:0]                       cfg_r_resp;
    bit [1:0]                       cfg_b_resp;

    bit [`DISP_CFG_RSP_DATA_W-1:0]  rsp_tdata;
    bit [`DISP_CFG_RSP_STRB_W-1:0]  rsp_tstrb;
    bit [`DISP_CFG_RSP_KEEP_W-1:0]  rsp_tkeep;
    bit                              rsp_tlast;
    bit [`DISP_CFG_RSP_ID_W-1:0]    rsp_tid;
    bit [`DISP_CFG_RSP_DEST_W-1:0]  rsp_tdest;
    bit [`DISP_CFG_RSP_USER_W-1:0]  rsp_tuser;

    bit [`DISP_CFG_CORE_ID_W-1:0]   reg_qid;
    bit [`DISP_CFG_CORE_ADDR_W-1:0] reg_qaddr;
    bit [`DISP_CFG_CORE_DATA_W-1:0] reg_qwdata;
    bit [`DISP_CFG_CORE_STRB_W-1:0] reg_qwstrb;
    bit                              reg_qwen;

    bit [`DISP_CFG_CORE_ID_W-1:0]   reg_pid;
    bit [`DISP_CFG_CORE_DATA_W-1:0] reg_prdata;
    bit                              reg_pwen;
    bit                              reg_perr;

    bit [`DISP_CFG_CLST_QBID_W-1:0] cpt_qbid;

    bit [7:0] stcu_int_data;
    bit [2:0] cache_int_data;
    bit       smmu_int_data;
    bit [4:0] oaiss_int_data;

    `uvm_object_utils_begin(dispatcher_cfg_transaction)
        `uvm_field_enum(dispatcher_cfg_evt_e, evt_kind, UVM_ALL_ON)
        `uvm_field_int(clst_id,      UVM_ALL_ON)
        `uvm_field_int(cu_id,        UVM_ALL_ON)
        `uvm_field_int(idx_id,       UVM_ALL_ON)
        `uvm_field_int(accepted,     UVM_ALL_ON)
        `uvm_field_int(cfg_aw_addr,  UVM_ALL_ON)
        `uvm_field_int(cfg_w_data,   UVM_ALL_ON)
        `uvm_field_int(cfg_w_strb,   UVM_ALL_ON)
        `uvm_field_int(cfg_ar_addr,  UVM_ALL_ON)
        `uvm_field_int(cfg_r_data,   UVM_ALL_ON)
        `uvm_field_int(cfg_r_resp,   UVM_ALL_ON)
        `uvm_field_int(cfg_b_resp,   UVM_ALL_ON)
        `uvm_field_int(rsp_tdata,    UVM_ALL_ON)
        `uvm_field_int(rsp_tstrb,    UVM_ALL_ON)
        `uvm_field_int(rsp_tkeep,    UVM_ALL_ON)
        `uvm_field_int(rsp_tlast,    UVM_ALL_ON)
        `uvm_field_int(rsp_tid,      UVM_ALL_ON)
        `uvm_field_int(rsp_tdest,    UVM_ALL_ON)
        `uvm_field_int(rsp_tuser,    UVM_ALL_ON)
        `uvm_field_int(reg_qid,      UVM_ALL_ON)
        `uvm_field_int(reg_qaddr,    UVM_ALL_ON)
        `uvm_field_int(reg_qwdata,   UVM_ALL_ON)
        `uvm_field_int(reg_qwstrb,   UVM_ALL_ON)
        `uvm_field_int(reg_qwen,     UVM_ALL_ON)
        `uvm_field_int(reg_pid,      UVM_ALL_ON)
        `uvm_field_int(reg_prdata,   UVM_ALL_ON)
        `uvm_field_int(reg_pwen,     UVM_ALL_ON)
        `uvm_field_int(reg_perr,     UVM_ALL_ON)
        `uvm_field_int(cpt_qbid,     UVM_ALL_ON)
        `uvm_field_int(stcu_int_data,UVM_ALL_ON)
        `uvm_field_int(cache_int_data,UVM_ALL_ON)
        `uvm_field_int(smmu_int_data,UVM_ALL_ON)
        `uvm_field_int(oaiss_int_data,UVM_ALL_ON)
    `uvm_object_utils_end

    extern function new(string name = "dispatcher_cfg_transaction");

endclass : dispatcher_cfg_transaction

function dispatcher_cfg_transaction::new(string name = "dispatcher_cfg_transaction");
    super.new(name);
    evt_kind      = DISP_EVT_CFG_AW;
    clst_id       = 0;
    cu_id         = 0;
    idx_id        = 0;
    accepted      = 0;
    ts            = 0;
    cfg_aw_addr   = '0;
    cfg_w_data    = '0;
    cfg_w_strb    = '0;
    cfg_ar_addr   = '0;
    cfg_r_data    = '0;
    cfg_r_resp    = '0;
    cfg_b_resp    = '0;
    rsp_tdata     = '0;
    rsp_tstrb     = '0;
    rsp_tkeep     = '0;
    rsp_tlast     = '0;
    rsp_tid       = '0;
    rsp_tdest     = '0;
    rsp_tuser     = '0;
    reg_qid       = '0;
    reg_qaddr     = '0;
    reg_qwdata    = '0;
    reg_qwstrb    = '0;
    reg_qwen      = '0;
    reg_pid       = '0;
    reg_prdata    = '0;
    reg_pwen      = '0;
    reg_perr      = '0;
    cpt_qbid      = '0;
    stcu_int_data = '0;
    cache_int_data= '0;
    smmu_int_data = '0;
    oaiss_int_data= '0;
endfunction : new

`endif
