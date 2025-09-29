class transaction extends uvm_sequence_item;
  `uvm_object_utils(transaction)
  rand bit [31:0] pwdata;
  randc bit [7:0] paddr;
  rand bit pwrite;
  bit psel, penable;
  bit pready,pslverr, reset;
  bit [31:0] prdata;
  static int count=0;
  rand bit [3:0] pstrb;
  
  function new(string name="transaction");
  super.new(name) ;
  endfunction

  constraint c_l{if(count < 8){
  pwrite == 1;
  paddr == count%8;
  }
  else if(count >= 8 && count < 16){
  pwrite == 0;
  paddr == count%8;
  }
  }
    
  constraint c_2{if(pwrite == 1){
  pwdata inside {[1:10]};
  }
  else {
    pwdata == 0;
  }
  }

    constraint c_3 { pwrite dist {1:= 50, 0:= 50};}
    
  constraint c_4 {if(pwrite) pstrb dist {4'b1111 := 60 ,4'b0111 := 30 , 4'b0011 := 10 }; else pstrb == 0;}
    
  function void post_randomize();
  count++;
  endfunction
                
  virtual function void do_copy(uvm_object rhs);
    transaction tr;
    $cast(tr,rhs);
    super.do_copy(rhs) ;
    pwdata=tr.pwdata;
    paddr=tr.paddr;
    pwrite=tr.pwrite;
    psel=tr.psel;
    pstrb = tr.pstrb;
    penable=tr.penable;
    pready=tr.pready ;
    pslverr=tr.pslverr;
    prdata=tr.prdata;
    reset=tr.reset;
  endfunction
endclass
