interface intf (input logic pclk,preset);
  logic [31:0] pwdata;
  logic [7:0] paddr;
  logic psel, penable,pwrite, pready, pslverr;
  logic [31:0] prdata;
  logic [3:0] pstrb;
  logic reset;
  
  clocking driver_cb @(posedge pclk);
    output pwdata;
    output psel,penable, pwrite;
    output paddr;
    output pstrb;
    input prdata, pslverr, pready;
  endclocking
  
  clocking monitor_cb @(posedge pclk);
    input reset;
    input pwdata;
    input psel,penable,pwrite;
    input paddr;
    input pstrb;
    input prdata,pslverr,pready;
  endclocking
  
  modport dr(clocking driver_cb, input pclk, preset) ;
  modport mo(clocking monitor_cb, input pclk, preset);

endinterface
