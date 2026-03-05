`ifndef DISPATCHER_CFG_INTERFACE__SV
`define DISPATCHER_CFG_INTERFACE__SV

interface dispatcher_cfg_interface(input clk, input rst_n);


    // ------------------------------
    // Kernel packet boundary signals
    // ------------------------------
    logic kernel_ack;
    logic kernel_rls;

    // ------------------------------
    // Dispatcher cfg_if (AxiLiteIf.Slave)
    // ------------------------------
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

    // ------------------------------
    // Dispatcher rsp_if (AxiStreamIf.Master)
    // ------------------------------
    logic [`DISP_CFG_CLST_N-1:0] rsp_tvalid;
    logic [`DISP_CFG_CLST_N-1:0] rsp_tready;
    logic [`DISP_CFG_CLST_N-1:0][`DISP_CFG_RSP_DATA_W-1:0] rsp_tdata;
    logic [`DISP_CFG_CLST_N-1:0][`DISP_CFG_RSP_STRB_W-1:0] rsp_tstrb;
    logic [`DISP_CFG_CLST_N-1:0][`DISP_CFG_RSP_KEEP_W-1:0] rsp_tkeep;
    logic [`DISP_CFG_CLST_N-1:0]                          rsp_tlast;
    logic [`DISP_CFG_CLST_N-1:0][`DISP_CFG_RSP_ID_W-1:0]   rsp_tid;
    logic [`DISP_CFG_CLST_N-1:0][`DISP_CFG_RSP_DEST_W-1:0] rsp_tdest;
    logic [`DISP_CFG_CLST_N-1:0][`DISP_CFG_RSP_USER_W-1:0] rsp_tuser;

    // ------------------------------
    // Dispatcher core_cfg_if (StcuRegIf.Master)
    // ------------------------------
    logic [`DISP_CFG_CLST_N-1:0][`DISP_CFG_CU_N-1:0] core_cfg_qvalid;
    logic [`DISP_CFG_CLST_N-1:0][`DISP_CFG_CU_N-1:0] core_cfg_qready;
    logic [`DISP_CFG_CLST_N-1:0][`DISP_CFG_CU_N-1:0][`DISP_CFG_CORE_ID_W-1:0]   core_cfg_qid;
    logic [`DISP_CFG_CLST_N-1:0][`DISP_CFG_CU_N-1:0][`DISP_CFG_CORE_ADDR_W-1:0] core_cfg_qaddr;
    logic [`DISP_CFG_CLST_N-1:0][`DISP_CFG_CU_N-1:0] core_cfg_qwen;
    logic [`DISP_CFG_CLST_N-1:0][`DISP_CFG_CU_N-1:0][`DISP_CFG_CORE_DATA_W-1:0] core_cfg_qwdata;
    logic [`DISP_CFG_CLST_N-1:0][`DISP_CFG_CU_N-1:0][`DISP_CFG_CORE_STRB_W-1:0] core_cfg_qwstrb;

    logic [`DISP_CFG_CLST_N-1:0][`DISP_CFG_CU_N-1:0] core_cfg_pvalid;
    logic [`DISP_CFG_CLST_N-1:0][`DISP_CFG_CU_N-1:0] core_cfg_pready;
    logic [`DISP_CFG_CLST_N-1:0][`DISP_CFG_CU_N-1:0] core_cfg_pwen;
    logic [`DISP_CFG_CLST_N-1:0][`DISP_CFG_CU_N-1:0][`DISP_CFG_CORE_DATA_W-1:0] core_cfg_prdata;
    logic [`DISP_CFG_CLST_N-1:0][`DISP_CFG_CU_N-1:0] core_cfg_perr;
    logic [`DISP_CFG_CLST_N-1:0][`DISP_CFG_CU_N-1:0][`DISP_CFG_CORE_ID_W-1:0]   core_cfg_pid;

    // ------------------------------
    // Dispatcher extra StcuRegIf.Master ports
    // ------------------------------
    logic [`DISP_CFG_CLST_N-1:0][`DISP_CFG_CACHE_N-1:0] cache_cfg_qvalid;
    logic [`DISP_CFG_CLST_N-1:0][`DISP_CFG_CACHE_N-1:0] cache_cfg_qready;
    logic [`DISP_CFG_CLST_N-1:0][`DISP_CFG_CACHE_N-1:0][`DISP_CFG_CORE_ID_W-1:0]   cache_cfg_qid;
    logic [`DISP_CFG_CLST_N-1:0][`DISP_CFG_CACHE_N-1:0][`DISP_CFG_CORE_ADDR_W-1:0] cache_cfg_qaddr;
    logic [`DISP_CFG_CLST_N-1:0][`DISP_CFG_CACHE_N-1:0] cache_cfg_qwen;
    logic [`DISP_CFG_CLST_N-1:0][`DISP_CFG_CACHE_N-1:0][`DISP_CFG_CORE_DATA_W-1:0] cache_cfg_qwdata;
    logic [`DISP_CFG_CLST_N-1:0][`DISP_CFG_CACHE_N-1:0][`DISP_CFG_CORE_STRB_W-1:0] cache_cfg_qwstrb;
    logic [`DISP_CFG_CLST_N-1:0][`DISP_CFG_CACHE_N-1:0] cache_cfg_pvalid;
    logic [`DISP_CFG_CLST_N-1:0][`DISP_CFG_CACHE_N-1:0] cache_cfg_pready;
    logic [`DISP_CFG_CLST_N-1:0][`DISP_CFG_CACHE_N-1:0] cache_cfg_pwen;
    logic [`DISP_CFG_CLST_N-1:0][`DISP_CFG_CACHE_N-1:0][`DISP_CFG_CORE_DATA_W-1:0] cache_cfg_prdata;
    logic [`DISP_CFG_CLST_N-1:0][`DISP_CFG_CACHE_N-1:0] cache_cfg_perr;
    logic [`DISP_CFG_CLST_N-1:0][`DISP_CFG_CACHE_N-1:0][`DISP_CFG_CORE_ID_W-1:0]   cache_cfg_pid;

    logic [`DISP_CFG_CLST_N-1:0] cctrl_cfg_qvalid;
    logic [`DISP_CFG_CLST_N-1:0] cctrl_cfg_qready;
    logic [`DISP_CFG_CLST_N-1:0][`DISP_CFG_CORE_ID_W-1:0]   cctrl_cfg_qid;
    logic [`DISP_CFG_CLST_N-1:0][`DISP_CFG_CORE_ADDR_W-1:0] cctrl_cfg_qaddr;
    logic [`DISP_CFG_CLST_N-1:0] cctrl_cfg_qwen;
    logic [`DISP_CFG_CLST_N-1:0][`DISP_CFG_CORE_DATA_W-1:0] cctrl_cfg_qwdata;
    logic [`DISP_CFG_CLST_N-1:0][`DISP_CFG_CORE_STRB_W-1:0] cctrl_cfg_qwstrb;
    logic [`DISP_CFG_CLST_N-1:0] cctrl_cfg_pvalid;
    logic [`DISP_CFG_CLST_N-1:0] cctrl_cfg_pready;
    logic [`DISP_CFG_CLST_N-1:0] cctrl_cfg_pwen;
    logic [`DISP_CFG_CLST_N-1:0][`DISP_CFG_CORE_DATA_W-1:0] cctrl_cfg_prdata;
    logic [`DISP_CFG_CLST_N-1:0] cctrl_cfg_perr;
    logic [`DISP_CFG_CLST_N-1:0][`DISP_CFG_CORE_ID_W-1:0]   cctrl_cfg_pid;

    logic [`DISP_CFG_CLST_N-1:0] smmu_cfg_qvalid;
    logic [`DISP_CFG_CLST_N-1:0] smmu_cfg_qready;
    logic [`DISP_CFG_CLST_N-1:0][`DISP_CFG_CORE_ID_W-1:0]   smmu_cfg_qid;
    logic [`DISP_CFG_CLST_N-1:0][`DISP_CFG_CORE_ADDR_W-1:0] smmu_cfg_qaddr;
    logic [`DISP_CFG_CLST_N-1:0] smmu_cfg_qwen;
    logic [`DISP_CFG_CLST_N-1:0][`DISP_CFG_CORE_DATA_W-1:0] smmu_cfg_qwdata;
    logic [`DISP_CFG_CLST_N-1:0][`DISP_CFG_CORE_STRB_W-1:0] smmu_cfg_qwstrb;
    logic [`DISP_CFG_CLST_N-1:0] smmu_cfg_pvalid;
    logic [`DISP_CFG_CLST_N-1:0] smmu_cfg_pready;
    logic [`DISP_CFG_CLST_N-1:0] smmu_cfg_pwen;
    logic [`DISP_CFG_CLST_N-1:0][`DISP_CFG_CORE_DATA_W-1:0] smmu_cfg_prdata;
    logic [`DISP_CFG_CLST_N-1:0] smmu_cfg_perr;
    logic [`DISP_CFG_CLST_N-1:0][`DISP_CFG_CORE_ID_W-1:0]   smmu_cfg_pid;

    logic [`DISP_CFG_CLST_N-1:0] clst_cfg_qvalid;
    logic [`DISP_CFG_CLST_N-1:0] clst_cfg_qready;
    logic [`DISP_CFG_CLST_N-1:0][`DISP_CFG_CORE_ID_W-1:0]   clst_cfg_qid;
    logic [`DISP_CFG_CLST_N-1:0][`DISP_CFG_CORE_ADDR_W-1:0] clst_cfg_qaddr;
    logic [`DISP_CFG_CLST_N-1:0] clst_cfg_qwen;
    logic [`DISP_CFG_CLST_N-1:0][`DISP_CFG_CORE_DATA_W-1:0] clst_cfg_qwdata;
    logic [`DISP_CFG_CLST_N-1:0][`DISP_CFG_CORE_STRB_W-1:0] clst_cfg_qwstrb;
    logic [`DISP_CFG_CLST_N-1:0] clst_cfg_pvalid;
    logic [`DISP_CFG_CLST_N-1:0] clst_cfg_pready;
    logic [`DISP_CFG_CLST_N-1:0] clst_cfg_pwen;
    logic [`DISP_CFG_CLST_N-1:0][`DISP_CFG_CORE_DATA_W-1:0] clst_cfg_prdata;
    logic [`DISP_CFG_CLST_N-1:0] clst_cfg_perr;
    logic [`DISP_CFG_CLST_N-1:0][`DISP_CFG_CORE_ID_W-1:0]   clst_cfg_pid;

    // ------------------------------
    // Dispatcher slave-side cluster interfaces
    // ------------------------------
    logic [`DISP_CFG_CLST_N-1:0][`DISP_CFG_CU_N-1:0] cpt2disp_disp_qvld;
    logic [`DISP_CFG_CLST_N-1:0][`DISP_CFG_CU_N-1:0] cpt2disp_disp_qrdy;
    logic [`DISP_CFG_CLST_N-1:0][`DISP_CFG_CU_N-1:0][`DISP_CFG_CLST_QBID_W-1:0] cpt2disp_disp_qbid;

    logic [`DISP_CFG_CLST_N-1:0][`DISP_CFG_CU_N-1:0] cpt2disp_lkup_qvld;
    logic [`DISP_CFG_CLST_N-1:0][`DISP_CFG_CU_N-1:0] cpt2disp_lkup_qrdy;
    logic [`DISP_CFG_CLST_N-1:0][`DISP_CFG_CU_N-1:0][`DISP_CFG_CLST_QBID_W-1:0] cpt2disp_lkup_qbid;

    logic [`DISP_CFG_CLST_N-1:0][`DISP_CFG_CU_N-1:0] cpt2disp_sync_qvld;
    logic [`DISP_CFG_CLST_N-1:0][`DISP_CFG_CU_N-1:0] cpt2disp_sync_qrdy;
    logic [`DISP_CFG_CLST_N-1:0][`DISP_CFG_CU_N-1:0][`DISP_CFG_CLST_QBID_W-1:0] cpt2disp_sync_qbid;

    // ------------------------------
    // Interrupt related signals
    // ------------------------------
    logic [`DISP_CFG_CLST_N-1:0][`DISP_CFG_CU_SUBC_N-1:0][7:0] int_in_stcu;
    logic [`DISP_CFG_CLST_N-1:0][2:0]                         int_in_cache;
    logic [`DISP_CFG_CLST_N-1:0]                              int_in_smmu;
    logic [`DISP_CFG_CLST_N-1:0][4:0]                         int_out_oaiss;

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

        input rsp_tvalid;
        input rsp_tready;
        input rsp_tdata;
        input rsp_tstrb;
        input rsp_tkeep;
        input rsp_tlast;
        input rsp_tid;
        input rsp_tdest;
        input rsp_tuser;

        input core_cfg_qvalid;
        input core_cfg_qready;
        input core_cfg_qid;
        input core_cfg_qaddr;
        input core_cfg_qwen;
        input core_cfg_qwdata;
        input core_cfg_qwstrb;
        input core_cfg_pvalid;
        input core_cfg_pready;
        input core_cfg_pwen;
        input core_cfg_prdata;
        input core_cfg_perr;
        input core_cfg_pid;

        input cache_cfg_qvalid;
        input cache_cfg_qready;
        input cache_cfg_qid;
        input cache_cfg_qaddr;
        input cache_cfg_qwen;
        input cache_cfg_qwdata;
        input cache_cfg_qwstrb;
        input cache_cfg_pvalid;
        input cache_cfg_pready;
        input cache_cfg_pwen;
        input cache_cfg_prdata;
        input cache_cfg_perr;
        input cache_cfg_pid;

        input cctrl_cfg_qvalid;
        input cctrl_cfg_qready;
        input cctrl_cfg_qid;
        input cctrl_cfg_qaddr;
        input cctrl_cfg_qwen;
        input cctrl_cfg_qwdata;
        input cctrl_cfg_qwstrb;
        input cctrl_cfg_pvalid;
        input cctrl_cfg_pready;
        input cctrl_cfg_pwen;
        input cctrl_cfg_prdata;
        input cctrl_cfg_perr;
        input cctrl_cfg_pid;

        input smmu_cfg_qvalid;
        input smmu_cfg_qready;
        input smmu_cfg_qid;
        input smmu_cfg_qaddr;
        input smmu_cfg_qwen;
        input smmu_cfg_qwdata;
        input smmu_cfg_qwstrb;
        input smmu_cfg_pvalid;
        input smmu_cfg_pready;
        input smmu_cfg_pwen;
        input smmu_cfg_prdata;
        input smmu_cfg_perr;
        input smmu_cfg_pid;

        input clst_cfg_qvalid;
        input clst_cfg_qready;
        input clst_cfg_qid;
        input clst_cfg_qaddr;
        input clst_cfg_qwen;
        input clst_cfg_qwdata;
        input clst_cfg_qwstrb;
        input clst_cfg_pvalid;
        input clst_cfg_pready;
        input clst_cfg_pwen;
        input clst_cfg_prdata;
        input clst_cfg_perr;
        input clst_cfg_pid;

        input cpt2disp_disp_qvld;
        input cpt2disp_disp_qrdy;
        input cpt2disp_disp_qbid;
        input cpt2disp_lkup_qvld;
        input cpt2disp_lkup_qrdy;
        input cpt2disp_lkup_qbid;
        input cpt2disp_sync_qvld;
        input cpt2disp_sync_qrdy;
        input cpt2disp_sync_qbid;

        input int_in_stcu;
        input int_in_cache;
        input int_in_smmu;
        input int_out_oaiss;

        input kernel_ack;
        input kernel_rls;
    endclocking : mon_cb

endinterface : dispatcher_cfg_interface

`endif
