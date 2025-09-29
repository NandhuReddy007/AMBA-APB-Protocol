class basetest extends uvm_test;
  `uvm_component_utils(basetest)
  environment env;
  sequencet seq;
  uvm_event Done;
  
  function new(string name,uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env=environment::type_id::create("env", this);
  endfunction
  
  virtual function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    uvm_top.print_topology();
    if(!uvm_config_db#(uvm_event)::get(this, "", "Done", Done))
    `uvm_fatal ("EVENT-BT", "EVENT ACCESS FAILED");
  endfunction

  task run_phase(uvm_phase phase) ;
    phase.raise_objection(this);
    fork
      begin
        seq=sequencet::type_id::create("seq") ;
        seq.start(env.agnt.sqr) ;      
      end
      begin
        Done.wait_trigger();
        phase.drop_objection(this);
       end   
    join_any
  endtask
endclass
