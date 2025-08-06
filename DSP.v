module DSP(
	A,
B,
C,
D,
CARRYIN,
CLK,
opmode,
CEA,
CEB,
CEC,
CECARRYIN,
CED,
CEM,
CEOPMODE,
CEP,
RSTA,
RSTB,
RSTC,
RSTCARRYIN,
RSTD,
RSTM,
RSTOPMODE,
RSTP,
PCIN,
PCOUT,
BCOUT,
M,
P,
CARRYOUT,
CARRYOUTF,
BCIN);
//define the number of pipeline registers in the A 
// and B input paths. 
parameter A0REG =0;
parameter  A1REG = 1;
parameter B0REG= 0;
parameter  B1REG= 1;
parameter CREG= 1;
parameter DREG= 1;
parameter  MREG = 1;
parameter PREG= 1;
parameter  CARRYINREG = 1;
parameter CARRYOUTREG= 1;
parameter OPMODEREG = 1;
parameter CARRYINSEL= "OPMODE5" ;//or "CARRYIN";
// Tie the output of the mux to 0 if none of these string 
// values exist. 
// either 
// the CARRYIN input will be considered or the value of opcode[5]
 parameter B_INPUT = "DIRECT"; // or "CASCADE";
parameter RSTTYPE="SYNC" ;// or "ASYNC";
input wire [17:0]A ;//optionally to post
// adder/subtracter depending on the value of OPMODE[1:0]. 
input wire [17:0]B ;  //to multiplier depending on 
// OPMODE[4], or to post-adder/subtracter depending on 
// OPMODE[1:0]. 
input wire [47:0]C ;//data input to post-adder/subtracter. 
input wire [17:0]D ; // input to pre-adder/subtracter. D[11:0] are concatenated 
// with A and B and optionally sent to post-adder/subtracter depending 
// on the value of OPMODE[1:0]. 
input wire CARRYIN ;
input wire CLK ;
input wire [7:0] opmode ;
input wire CEA ;
input wire CEB  ;
input wire CEC ;
input wire CECARRYIN ; 
input wire CED ;
input wire CEM ;
input wire CEOPMODE ;
input wire CEP;
input wire RSTA ;
input wire RSTB ;  
input wire RSTC ;
input wire RSTCARRYIN ;
input wire RSTD ;
input wire RSTM ;
input wire RSTOPMODE ;
input wire RSTP ;
input wire [47:0]PCIN ;
input wire [17:0]BCIN; 
output wire  [47:0]PCOUT; 
output wire  [17:0]BCOUT; 
output wire  [35:0]M ;
output wire  [47:0]P ;
output wire  CARRYOUT ;
//can be registered in (CARRYOUTREG = 1) or unregistered (CARRYOUTREG = 0).
output wire  CARRYOUTF ;

wire [17:0] D_mux ,B0_mux,A0_mux,B1_mux,A1_mux;
wire [47:0]C_mux,concatenated;
wire [17:0]B_wire;
wire [17:0]Pre_Add_Sub,Pre_Add_Sub_mux;
wire carry_post,CYI_mux;
wire [35:0] product;
wire CIN;
wire [47:0]Post_Add_Sub_mux;
reg [47:0] Z_mux,X_mux;
wire [35:0] M_mux;
wire [7:0] OPMODE;
assign M = ~ (~ M_mux); 
assign B_wire= (B_INPUT=="DIRECT")? B:(B_INPUT=="CASCADE")?BCIN:0;
assign Pre_Add_Sub= (OPMODE[6])? (D_mux-B0_mux) : (D_mux+B0_mux); 
assign Pre_Add_Sub_mux=(OPMODE[4])? Pre_Add_Sub:B0_mux;
assign product= B1_mux * A1_mux;
assign BCOUT = B1_mux;
assign concatenated = {D_mux[11:0],A0_mux,B0_mux};
assign PCOUT = P; 
assign {carry_post,Post_Add_Sub_mux}= (OPMODE[7])? (Z_mux-(X_mux+CIN)):(Z_mux+(X_mux+CIN));
assign CARRYOUTF=CARRYOUT;
assign CYI_mux= (CARRYINSEL=="OPMODE5")? OPMODE[5]:(CARRYINSEL=="CARRYIN")? CARRYIN:0;

//11 instantiation 
//parameter RSTTYPE = "SYNC"; 
// parameter REGSIZE= 18;
DSP_reg_MUX #(RSTTYPE,18) D_REG (.F(D), 
.rst(RSTD),
.clk(CLK),
.out(D_mux),
.sel(DREG),
.clk_enable(CED));
DSP_reg_MUX #(RSTTYPE,18) B0_REG (.F(B),
.rst(RSTB),
.clk(CLK),
.out(B0_mux),
.sel(B0REG),
.clk_enable(CEB));
DSP_reg_MUX #(RSTTYPE,18) A0_REG (.F(A),
.rst(RSTA),
.clk(CLK),
.out(A0_mux),
.sel(A0REG),
.clk_enable(CEA));
DSP_reg_MUX #(RSTTYPE,48) C_REG (.F(C),
.rst(RSTC),
.clk(CLK),
.out(C_mux),
.sel(CREG),
.clk_enable(CEC));
DSP_reg_MUX #(RSTTYPE,18) B1_REG (.F(Pre_Add_Sub_mux),
.rst(RSTB),
.clk(CLK),
.out(B1_mux),
.sel(B1REG),
.clk_enable(CEB));
DSP_reg_MUX #(RSTTYPE,18) A1_REG (.F(A0_mux),
.rst(RSTA),
.clk(CLK),
.out(A1_mux),
.sel(A1REG),
.clk_enable(CEA));
DSP_reg_MUX #(RSTTYPE,36) M_REG (.F(product),
.rst(RSTM),
.clk(CLK),
.out(M_mux),
.sel(MREG),
.clk_enable(CEM));
DSP_reg_MUX #(RSTTYPE,1) CYI (.F(CYI_mux),
.rst(RSTCARRYIN),
.clk(CLK),
.out(CIN),
.sel(CARRYINREG),
.clk_enable(CECARRYIN));
DSP_reg_MUX #(RSTTYPE,1) CARRYCASCADE (.F(carry_post),
.rst(RSTCARRYIN ),
.clk(CLK),
.out(CARRYOUT),
.sel(CARRYOUTREG),
.clk_enable(CECARRYIN));
DSP_reg_MUX #(RSTTYPE,48) P_REG (.F(Post_Add_Sub_mux),
.rst(RSTP),
.clk(CLK),
.out(P),
.sel(PREG),
.clk_enable(CEP));
DSP_reg_MUX #(RSTTYPE,8) OPMODE_REG (.F(opmode),
.rst(RSTOPMODE),
.clk(CLK),
.out(OPMODE),
.sel(OPMODEREG),
.clk_enable(CEOPMODE));
	always@(*) begin 
		case ({OPMODE[1],OPMODE[0]})
			2'b00: X_mux=0;
			2'b01: X_mux=M_mux;
			2'b10: X_mux=PCOUT;
			2'b11: X_mux=concatenated;
		endcase 
	end 		
	always@(*) begin 
		case ({OPMODE[3],OPMODE[2]})
			2'b00: Z_mux=0;
			2'b01: Z_mux=PCIN;
			2'b10: Z_mux=P;
			2'b11: Z_mux=C_mux;
		endcase 
	end 
endmodule 