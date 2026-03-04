`ifndef DISPATCHER_CFG_INTERFACE__SV
`define DISPATCHER_CFG_INTERFACE__SV

interface dispatcher_cfg_interface(input clk, input rst_n);

    logic [`DISP_CFG_CLST_N-1:0] cfg_aw_valid;
    logic [`DISP_CFG_CLST_N-1:0] cfg_aw_ready;
    logic [`DISP_CFG_CLST_N-1:0][`DISP_CFG_CFG_ADDR_W-1:0] cfg_aw_addr;
    logic [`DISP_CFG_CLST_N-1:0][2:0]                      cfg_aw_prot;
    logic [`DISP_CFG_CLST_N-1:0][5:0]                      cfg_aw_user;

    logic [`DISP_CFG_CLST_N-1:0] cfg_w_valid;
    logic [`DISP_CFG_CLST_N-1:0] cfg_w_ready;
    logic [`DISP_CFG_CLST_N-1:0][`DISP_CFG_CFG_DATA_W-1:0] cfg_w_data;
    logic [`DISP_CFG_CLST_N-1:0][`DISP_CFG_CFG_STRB_W-1:0] cfg_w_strb;

    logic [`DISP_CFG_CLST_N-1:0] cfg_b_valid;
    logic [`DISP_CFG_CLST_N-1:0] cfg_b_ready;
    logic [`DISP_CFG_CLST_N-1:0][1:0] cfg_b_resp;

    logic [`DISP_CFG_CLST_N-1:0] cfg_ar_valid;
    logic [`DISP_CFG_CLST_N-1:0] cfg_ar_ready;
    logic [`DISP_CFG_CLST_N-1:0][`DISP_CFG_CFG_ADDR_W-1:0] cfg_ar_addr;
    logic [`DISP_CFG_CLST_N-1:0][2:0]                      cfg_ar_prot;
    logic [`DISP_CFG_CLST_N-1:0][5:0]                      cfg_ar_user;

    logic [`DISP_CFG_CLST_N-1:0] cfg_r_valid;
    logic [`DISP_CFG_CLST_N-1:0] cfg_r_ready;
    logic [`DISP_CFG_CLST_N-1:0][`DISP_CFG_CFG_DATA_W-1:0] cfg_r_data;
    logic [`DISP_CFG_CLST_N-1:0][1:0]                      cfg_r_resp;

    logic [`DISP_CFG_CLST_N-1:0][`DISP_CFG_CU_N-1:0] core_qvalid;
    logic [`DISP_CFG_CLST_N-1:0][`DISP_CFG_CU_N-1:0] core_qready;
    logic [`DISP_CFG_CLST_N-1:0][`DISP_CFG_CU_N-1:0][`DISP_CFG_CORE_ID_W-1:0]   core_qid;
    logic [`DISP_CFG_CLST_N-1:0][`DISP_CFG_CU_N-1:0][`DISP_CFG_CORE_ADDR_W-1:0] core_qaddr;
    logic [`DISP_CFG_CLST_N-1:0][`DISP_CFG_CU_N-1:0] core_qwen;
    logic [`DISP_CFG_CLST_N-1:0][`DISP_CFG_CU_N-1:0][`DISP_CFG_CORE_DATA_W-1:0] core_qwdata;
    logic [`DISP_CFG_CLST_N-1:0][`DISP_CFG_CU_N-1:0][`DISP_CFG_CORE_STRB_W-1:0] core_qwstrb;

    logic [`DISP_CFG_CLST_N-1:0][`DISP_CFG_CU_N-1:0] core_pvalid;
    logic [`DISP_CFG_CLST_N-1:0][`DISP_CFG_CU_N-1:0] core_pready;
    logic [`DISP_CFG_CLST_N-1:0][`DISP_CFG_CU_N-1:0] core_pwen;
    logic [`DISP_CFG_CLST_N-1:0][`DISP_CFG_CU_N-1:0][`DISP_CFG_CORE_DATA_W-1:0] core_prdata;
    logic [`DISP_CFG_CLST_N-1:0][`DISP_CFG_CU_N-1:0] core_perr;
    logic [`DISP_CFG_CLST_N-1:0][`DISP_CFG_CU_N-1:0][`DISP_CFG_CORE_ID_W-1:0]   core_pid;

    clocking mon_cb @(posedge clk);
        input cfg_aw_valid;
        input cfg_aw_ready;
        input cfg_aw_addr;
        input cfg_aw_prot;
        input cfg_aw_user;

        input cfg_w_valid;
        input cfg_w_ready;
        input cfg_w_data;
        input cfg_w_strb;

        input cfg_b_valid;
        input cfg_b_ready;
        input cfg_b_resp;

        input cfg_ar_valid;
        input cfg_ar_ready;
        input cfg_ar_addr;
        input cfg_ar_prot;
        input cfg_ar_user;

        input cfg_r_valid;
        input cfg_r_ready;
        input cfg_r_data;
        input cfg_r_resp;

        input core_qvalid;
        input core_qready;
        input core_qid;
        input core_qaddr;
        input core_qwen;
        input core_qwdata;
        input core_qwstrb;

        input core_pvalid;
        input core_pready;
        input core_pwen;
        input core_prdata;
        input core_perr;
        input core_pid;
    endclocking : mon_cb

endinterface : dispatcher_cfg_interface

`endif
