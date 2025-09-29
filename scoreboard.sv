class scoreboard extends uvm_scoreboard;
  `uvm_component_utils(scoreboard)
  `uvm_analysis_imp_decl(_mon)
  `uvm_analysis_imp_decl(_rm)
  int sb_count=0;
  uvm_event Done;
  uvm_analysis_imp_mon#(transaction, scoreboard) from_mon;
  uvm_analysis_imp_rm#(transaction, scoreboard) from_rm ;
  transaction trans_rm[$], trans_mon[$];

  function new(string name, uvm_component parent) ;
    super.new(name, parent) ;
    from_mon=new("from_mon", this) ;
    from_rm=new("from_rm", this) ;
  endfunction

  function void build_phase(uvm_phase phase) ;
    super.build_phase(phase) ;
    Done = new("Done");
    uvm_config_db#(uvm_event)::set(null, "uvm_test_top", "Done", Done) ;
  endfunction

  function void write_mon(transaction t);
    trans_mon.push_back(t) ;
    // uvm_info("SCOREBOARD WRITE MON",$sformatf("trans_mon %d", trans_mon) , UVM_LOW) ;
  endfunction

  function void write_rm(transaction t);
  //`uvm_info("SCOREBOARD WRITE RM",$sformatf("trans_rm %p", t) , UVM_LoW);
    trans_rm.push_back(t) ;
  //`uvm_info("SCOREBOARD WRITE RM",$sformatf("trans_rm %p", trans_rm[0].pwdata) , UVM_LOW);

  endfunction

  task run_phase(uvm_phase phase) ;
    fork
      forever begin
        wait(trans_mon.size()>0 && trans_rm.size()>0)begin
          if(trans_rm[0].prdata == trans_mon[0].prdata) begin
            trans_mon.pop_front();
            trans_rm.pop_front();
            `uvm_info("SCOREBOARD", $sformatf(" EQUAL: sb_count :%d() ", sb_count++), UVM_LOW) ;
          end
          else begin
            `uvm_error("SCOREBOARD", $sformatf("NOT EQUAL/ *: rm :%p. .mon :%p", trans_rm[0] .prdata, trans_mon[0] .prdata) ) ;
            trans_mon.pop_front();
            trans_rm.pop_front();
          end
        end
      end
      
      wait(sb_count == (no_txn/2)) begin
        Done.trigger();
      end
    join_any
  endtask
endclass
