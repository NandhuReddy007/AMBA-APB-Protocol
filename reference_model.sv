class reference extends uvm_subscriber#(transaction);
  `uvm_component_utils(reference)
  uvm_analysis_imp#(transaction, reference) ref_ap;
  uvm_analysis_port#(transaction) ref_sb;
  transaction exp_tr;
  transaction trans;

  function new(string name, uvm_component parent);
    super.new(name, parent) ;
    ref_ap = new("ref_ap", this);
    ref_sb = new("ref_sb", this);
  endfunction
  
  function void build_phase(uvm_phase phase) ;
    super.build_phase(phase) ;
  endfunction
  
  function void write(transaction t);
  //'uvm_info("REFERENCE t",$sformatf ("%p", t), UVM_LOW) ;
    exp_tr=sb_calc_exp(t);
  //'uvm_info("REFERENCE exp_tr",$sformatf("ref packet: %d", exp_tr.prdata) , UVM_LOW) ;
    if(!t.pwrite) begin
  //'uvm_info("REFERENCE",$sformatf("ref packet: %p", exp_tr) , UVM_LOW);
      ref_sb.write(exp_tr);
  //`uvm_info("REFERENCE", $sformatf("ref packet: %p", exp_tr) , UVM_LOW);
  	 end
  endfunction
  
  extern function transaction sb_calc_exp(transaction t);
    
  endclass
    
  function transaction reference::sb_calc_exp(transaction t);
    static bit [31:0] ram [0:2 ** 8];
    static int data_out;
    trans = transaction::type_id::create("trans") ;
    trans.copy(t);
    if ( !trans. reset) begin
      if(trans.psel) begin
        if(trans .penable)begin
          if(trans.pwrite) begin
            for(int i=0;i<4;i++)begin
              if(trans.pstrb[i] ) begin
      			ram[trans.paddr] [i*8 +: 8]=trans.pwdata[i*8 +: 8];
              end
            end
    		//'uvm_info("INSIDE FN", $sformatf("pstrb: %d, pdata :%d", trans.pstrb, ram[trans.paddr]), UVM_LOW);
          end
          else begin
            trans.prdata = ram[trans.paddr] ;
   		 //'uvm_info("[prdata]", $sformatf("prdata=%d", trans.prdata) , UVM_LOW) ;
          end
        end
      end
    end
    return trans;
endfunction
