class driver extends uvm_driver#(transaction);
  `uvm_component_utils(driver)
  virtual intf if_f;
  transaction tr;
  int drv_count=0;
  
  function new(string name, uvm_component parent);
    super.new(name, parent) ;
  endfunction
  
  virtual function void build_phase(uvm_phase phase) ;
  super.build_phase(phase) ;
  if(!uvm_config_db#(virtual intf) :: get(this, "", "if_f",if_f))
  `uvm_fatal(get_type_name(), "vif is not set")
  endfunction
    
  virtual task run_phase(uvm_phase phase);
    repeat(no_txn) begin
      drive();
    end
  endtask
    
  task drive();
    wait(!if_f.preset) begin
      seq_item_port.get_next_item(tr);
      @(if_f.driver_cb) ;
      if_f.dr.driver_cb.psel <= 1;
      if_f.dr.driver_cb.pwrite <= tr.pwrite;
      if_f.dr.driver_cb.pwdata <= tr.pwdata;
      if_f.dr.driver_cb.paddr <= tr.paddr;
      if_f.dr.driver_cb.pstrb <= tr.pstrb;
      if_f.dr.driver_cb.penable <= 0;
      
      @( if_f.driver_cb);
      if_f.dr.driver_cb.penable <= 1;

      @( if_f.driver_cb);
      if_f.dr.driver_cb.penable <= 0;
      // $display($time, "[DRV=%0d] psel=%0h | penable=%0h | pwrite=%0h | pwdata=%0h | paddr=%0h | prdata=%0h", drv_count, if_f.psel, if_f.penable, if_f.pwrite, if_f.pwdata, if_f.paddr,if_f.prdata);
      
      drv_count++;
      
      seq_item_port.item_done();
    end
    @(if_f.driver_cb);
    
  endtask
endclass
    
    
