// Code your design here
module apb(pclk, preset, pstrb, penable, pwrite, pwdata, prdata, pready, paddr, psel, pslverr);
  input wire pwrite, penable,pclk, preset, psel;
  input [7:0] paddr;
  input [3:0] pstrb;
  input wire[31 : 0]pwdata;
  output reg [31:0]prdata;
  output reg pready, pslverr;

  reg [31:0] mem [0:2 ** 8];
  typedef enum{idle, setup, access}state;
  state current_state,next_state;
  integer i=0;
  integer j=0;

  always @(posedge pclk, posedge preset)begin
    if(preset) begin
      pready <= 0;
      prdata <= 0;
      pslverr <= 0;
      current_state <= idle;
      for(j=0;j<2 ** 8; j++)begin
        mem[j]=0;
      end
    end
    else
    current_state <= next_state;
    end
  
  always @(*)begin
    case(current_state)
      idle:begin
        pready=0;
        if(psel)
          next_state=setup;
        else
          next_state=idle;
      end
      
      setup : begin
        pready=0;
        if(psel)
          next_state=access;
        else
          next_state=idle;
        end
      access : begin
        pready=1;
        if(psel)begin
          if(penable)begin
            if(pwrite) begin
              for(i=0;i<4; i++) begin
                if(pstrb[i] ) begin
          			mem[paddr] [i*8 +: 8]=pwdata[i*8 +: 8];
                end
              end
              pslverr = 0;
            end
            else begin
              prdata=mem[paddr] ;
              pslverr = 0;
          	end
          end
          else
            next_state=setup;
        end
        else
        next_state=idle;
      end
  endcase
    end
endmodule
