class environment extends uvm_env;
  
  `uvm_component_utils(environment)
  agent agnt;
  scoreboard sb;
  reference rm;
  
  function new(string name, uvm_component parent);
    super.new(name, parent) ;
  endfunction
  
  function void build_phase(uvm_phase phase) ;
    super.build_phase(phase) ;
    agnt=agent::type_id::create("agnt", this) ;
    sb=scoreboard::type_id::create("scr", this) ;
    rm=reference::type_id::create("rm", this) ;
  endfunction
  
  function void connect_phase(uvm_phase phase) ;
    super.connect_phase(phase) ;
    agnt.to_sb.connect(sb.from_mon);
    agnt.to_rm.connect(rm.ref_ap);
    rm.ref_sb.connect(sb.from_rm);
  endfunction

endclass
