class agent extends uvm_agent;

  `uvm_component_utils (agent)
  uvm_analysis_export#(transaction) to_sb;
  uvm_analysis_export#(transaction) to_rm;
  monitor mon;
  driver drv;
  sequencer sqr;

  function new(string name, uvm_component parent);
    super . new(name, parent) ;
    to_sb = new("to_sb", this);
    to_rm = new("to_rm", this) ;
  endfunction

  function void build_phase(uvm_phase phase) ;
    super.build_phase (phase) ;
    mon=monitor::type_id::create("mon", this) ;
    drv=driver::type_id::create("drv", this) ;
    sqr=sequencer::type_id::create("sqr", this) ;
  endfunction

  function void connect_phase(uvm_phase phase) ;
    super.connect_phase (phase) ;
    drv.seq_item_port.connect(sqr.seq_item_export);
    mon.mon_ap_sb.connect(to_sb);
    mon.mon_ap_ref.connect(to_rm);
  endfunction
  
endclass
