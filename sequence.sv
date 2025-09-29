class sequencet extends uvm_sequence #(transaction);
  `uvm_object_utils(sequencet)
  transaction tr;
  int gen_count=16;
  int count=0;
  
  function new(string name="sequencet");
    super.new(name) ;
  endfunction
  
  task body();
  if(starting_phase != null) begin
    uvm_objection objection = starting_phase.get_objection();
   end
   
   tr=transaction::type_id::create("tr");
   forever begin   
      start_item(tr);
      assert(tr.randomize());
      //$display($time, "[GEN = %d] pwdata = %0h | pwrite = %0h | paddr = %0h, psel=%0h, penable=0h, prdata=%0h", count++, tr.pwdata, tr.pwrite, tr.paddr, tr.psel, tr.penable, tr. prdata);
      finish_item(tr);

      if(starting_phase != null) begin
        starting_phase.drop_objection(this);
      end
    end
  endtask
endclass
