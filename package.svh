package tb_pkg;

  import uvm_pkg::*;
  `include "uvm_macros.svh"
  int no_txn = 16;
  `include "transaction.sv"
  `include "sequence.sv"
  `include "sequencer.sv"
  `include "driver.sv"
  `include "monitor.sv"
  `include "scoreboard.sv"
  `include "reference_model.sv"
  `include "agent.sv"
  `include "environment.sv"
  `include "basetest.sv"

endpackage
