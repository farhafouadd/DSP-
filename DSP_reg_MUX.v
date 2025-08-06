module DSP_reg_MUX (F,
rst,
clk,
out,
sel,
clk_enable);
parameter RSTTYPE = "SYNC"; 
parameter REGSIZE= 18;
input wire [REGSIZE-1:0]F;
input wire rst;
input wire clk;
output wire [REGSIZE-1:0] out;
input wire clk_enable;
reg [REGSIZE-1:0] out_reg;
input wire sel;
generate
if (RSTTYPE == "SYNC")begin 
always @(posedge clk) begin
if (rst)
out_reg<=0;
else if (clk_enable )  
out_reg <=F;
end
end
if (RSTTYPE == "ASYNC")begin 
always @(posedge clk or posedge rst) begin
if (rst)
out_reg<=0;
else if (clk_enable) 
out_reg <=F;
end
end
endgenerate 
assign out = (sel)? out_reg:F; 
endmodule  