class monitor extends uvm_monitor;
  `uvm_component_utils (monitor)
  virtual intf if_f;
  transaction tr;
  int mon_count=0;
  uvm_analysis_port#(transaction)mon_ap_sb;
  uvm_analysis_port#(transaction)mon_ap_ref;
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase) ;
    super.build_phase(phase) ;
    mon_ap_sb=new("mon_ap_sb", this);
    mon_ap_ref=new("mon_ap_ref", this);
    if(!uvm_config_db#(virtual intf) :: get(this, "", "if_f",if_f))
    `uvm_fatal(get_type_name(), "vif is not set")
  endfunction
    
  virtual task run_phase(uvm_phase phase);
    forever begin
      tr=transaction::type_id::create("tr") ;
      
      wait(!if_f.preset && if_f.mo.monitor_cb.penable && if_f.mo.monitor_cb.psel);
      @(if_f.monitor_cb);
      tr.paddr=if_f.mo.monitor_cb.paddr;
      tr.pstrb = if_f.mo.monitor_cb.pstrb;
      if(if_f.mo.monitor_cb.pwrite) begin
        tr.pwdata=if_f.mo.monitor_cb.pwdata;
        tr.pwrite=if_f.mo.monitor_cb.pwrite;
        mon_ap_ref.write(tr);
        //$display($time, "[MON=%0d] psel=%0h | penable=%0h | pwrite=%0h | pwdata=%0h | paddr=%0h | prdata=%0h", mon_count, tr.psel, tr.penable, tr. pwrite, tr.pwdata, tr.paddr, tr.rdata);
      end
      else begin
        @(if_f.monitor_cb);
        tr.prdata = if_f.mo.monitor_cb.prdata;
        tr.pwrite=if_f.mo.monitor_cb.pwrite;
        mon_ap_sb.write(tr);
        mon_ap_ref.write(tr);
        //$display($time, "[MON=%0d] psel=%0h | penable=%0h | pwrite=%0h | pwdata=%0h | paddr=%0h | prdata=%0h", mon_count, tr.psel, tr.penable, tr.pwrite, tr.pwdata, tr.paddr, tr.prdata) ;
         
      end
      @(if_f.monitor_cb);
      //$display($time, "[MON=%0d] psel=%0h | penable=%0h | pwrite=%0h | pwdata=%0h | paddr=%0h | prdata=%0h", mon_count, tr.psel, tr. penable, tr. pwrite, tr. pwdata, tr. paddr, tr.prdata);

       mon_count++;

     end
  endtask
endclass
