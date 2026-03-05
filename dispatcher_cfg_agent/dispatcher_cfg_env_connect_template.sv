// Dispatcher CFG agent integration template
// This file is a reference snippet for env/top integration.

`define DISPATCHER_CFG_SCOPE {`CU_CTRL_ENV_SCOPE, ".m_dispatcher_cfg_agent"}

// In cu_ctrl_intf_connect.sv
dispatcher_cfg_interface m_dispatcher_cfg_intf(`HDL_TOP.clk, `HDL_TOP.rst_n);

// Kernel packet boundary
always @(*) m_dispatcher_cfg_intf.kernel_ack = `HDL_TOP.kernel_ack;
always @(*) m_dispatcher_cfg_intf.kernel_rls = `HDL_TOP.kernel_rls;

// Example: cfg_if and rsp_if binding per cluster
generate
  for (gi = 0; gi < CLST_CH; gi++) begin : DISP_CFG_BIND
    always @(*) m_dispatcher_cfg_intf.cfg_aw_valid[gi] = `HDL_TOP.u_tb_cuctrl_disp_cpt.cfg_if[gi].aw_valid;
    always @(*) m_dispatcher_cfg_intf.cfg_aw_ready[gi] = `HDL_TOP.u_tb_cuctrl_disp_cpt.cfg_if[gi].aw_ready;
    always @(*) m_dispatcher_cfg_intf.cfg_aw_addr [gi] = `HDL_TOP.u_tb_cuctrl_disp_cpt.cfg_if[gi].aw_addr;

    always @(*) m_dispatcher_cfg_intf.cfg_w_valid[gi]  = `HDL_TOP.u_tb_cuctrl_disp_cpt.cfg_if[gi].w_valid;
    always @(*) m_dispatcher_cfg_intf.cfg_w_ready[gi]  = `HDL_TOP.u_tb_cuctrl_disp_cpt.cfg_if[gi].w_ready;
    always @(*) m_dispatcher_cfg_intf.cfg_w_data [gi]  = `HDL_TOP.u_tb_cuctrl_disp_cpt.cfg_if[gi].w_data;
    always @(*) m_dispatcher_cfg_intf.cfg_w_strb [gi]  = `HDL_TOP.u_tb_cuctrl_disp_cpt.cfg_if[gi].w_strb;

    always @(*) m_dispatcher_cfg_intf.rsp_tvalid[gi]   = `HDL_TOP.u_tb_cuctrl_disp_cpt.rsp_if[gi].tvalid;
    always @(*) m_dispatcher_cfg_intf.rsp_tready[gi]   = `HDL_TOP.u_tb_cuctrl_disp_cpt.rsp_if[gi].tready;
    always @(*) m_dispatcher_cfg_intf.rsp_tdata [gi]   = `HDL_TOP.u_tb_cuctrl_disp_cpt.rsp_if[gi].tdata;
  end
endgenerate

// IMPORTANT: bind dispatcher internal interfaces through CLUSTER scope
// Example Verdi path style:
// hdl_top.u_tb_cuctrl_disp_cpt.CLUSTER[0].u_tb_StcuDisp.u_StcuDispatcher.cache_cfg_if
// hdl_top.u_tb_cuctrl_disp_cpt.CLUSTER[0].u_tb_StcuDisp.u_StcuDispatcher.cpt2disp_disp_if

// config_db binding
initial begin
  uvm_config_db#(virtual dispatcher_cfg_interface)::set(
      null, `DISPATCHER_CFG_SCOPE, "m_vif", m_dispatcher_cfg_intf);
end

// In cu_ctrl_env_cfg.sv
// bit has_dispatcher_cfg_agent;
// dispatcher_cfg_cfg m_dispatcher_cfg_cfg;

// In cu_ctrl_vsqr.sv
// dispatcher_cfg_sequencer m_dispatcher_cfg_sqr;

// In cu_ctrl_env.sv build_phase
// if (m_cfg.has_dispatcher_cfg_agent) begin
//   m_dispatcher_cfg_agent = dispatcher_cfg_agent::type_id::create("m_dispatcher_cfg_agent", this);
//   uvm_config_db#(dispatcher_cfg_cfg)::set(this, "m_dispatcher_cfg_agent", "m_cfg", m_cfg.m_dispatcher_cfg_cfg);
// end

// In cu_ctrl_env.sv connect_phase
// if (m_dispatcher_cfg_agent != null && m_vsqr != null)
//   m_vsqr.m_dispatcher_cfg_sqr = m_dispatcher_cfg_agent.m_sqr;

// In cu_ctrl_env_pkg.sv
// import dispatcher_cfg_agent_pkg::*;
