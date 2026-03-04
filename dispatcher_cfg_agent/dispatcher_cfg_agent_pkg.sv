`ifndef DISPATCHER_CFG_AGENT_PKG__SV
`define DISPATCHER_CFG_AGENT_PKG__SV

package dispatcher_cfg_agent_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    `include "dispatcher_cfg_parameter.sv"
    `include "dispatcher_cfg_cfg.sv"
    `include "dispatcher_cfg_transaction.sv"
    `include "dispatcher_cfg_sequencer.sv"
    `include "dispatcher_cfg_driver.sv"
    `include "dispatcher_cfg_monitor.sv"
    `include "dispatcher_cfg_slave.sv"
    `include "dispatcher_cfg_scb.sv"
    `include "dispatcher_cfg_sequence.sv"
    `include "dispatcher_cfg_agent.sv"

endpackage : dispatcher_cfg_agent_pkg

`include "dispatcher_cfg_interface.sv"

`endif
