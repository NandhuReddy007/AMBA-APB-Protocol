// Code your testbench here
// or browse Examples
`include "package.svh"
`include "apb_slave.v"
`include "interface.sv"
module tb_top();
  import uvm_pkg ::*;
  import tb_pkg ::*;
  bit pclk, preset;
  intf if_f(.pclk(pclk), .preset (preset) ) ;
  apb dut(.pclk(pclk), .preset(preset) , .pwdata(if_f.pwdata), .pwrite(if_f.pwrite), .paddr(if_f.paddr), .psel(if_f.psel), .penable(if_f.penable), .prdata(if_f.prdata) , .pready(if_f.pready), .pslverr(if_f.pslverr), .pstrb(if_f.pstrb));
  always #5 pclk =~ pclk;
  
  initial begin
    uvm_config_db#(virtual intf)::set(uvm_root::get(),"*", "if_f",if_f);
    preset=1;
    pclk=0;
    #15 preset=0;
  end
  
  property p1;
    @(posedge pclk) disable iff(preset)
    (( if_f.psel && !if_f.penable)) ##[1:3] (if_f.psel && if_f.penable) |=> if_f.pready;
  endproperty
  assert property(p1)begin
    `uvm_info("ASSERTION PASSED", $sformatf("pl ASSERTION PASSED") , UVM_HIGH) ;
  end
  else begin
    `uvm_info("ASSERTION1 FAILED", $sformatf("pl ASSERTION FAILED") ,UVM_HIGH);
  end
    
  property p2;
    @(posedge pclk) disable iff(preset)
    $rose(if_f.penable) |-> $stable(if_f.paddr) ##0 $stable(if_f.pwdata || if_f.prdata) ##0 $stable(if_f.pwrite)##0 $stable(if_f.psel);
  endproperty
  assert property(p2)begin
    `uvm_info("ASSERTION2", $sformatf("p2 ASSERTION PASSED"), UVM_HIGH);
  end
  else
    $error("data is not stable");
    
  property p3;
    @(posedge pclk) disable iff(preset)
  	(if_f.psel && if_f.penable && !if_f.pwrite) |-> $isunknown(if_f.prdata) == 0;
  endproperty
  assert property(p3)begin
    `uvm_info("ASSERTION", $sformatf("p3 ASSERTION PASSED") , UVM_HIGH);
  end
  else
    $error("unknown prdata");

  initial begin
    run_test("basetest"); 
  end

endmodule
