module DSP_tb(
	);
 reg  [17:0]A ;//optionally to post
// adder/subtracter depending on the value of OPMODE[1:0]. 
 reg  [17:0]B ;  //to multiplier depending on 
// OPMODE[4], or to post-adder/subtracter depending on 
// OPMODE[1:0]. 
 reg  [47:0]C ;//data input to post-adder/subtracter. 
 reg  [17:0]D ; // input to pre-adder/subtracter. D[11:0] are concatenated 
// with A and B and optionally sent to post-adder/subtracter depending 
// on the value of OPMODE[1:0]. 
 reg  CARRYIN ;
 reg  CLK ;
 reg  [7:0] opmode ;
 reg  CEA ;
 reg  CEB  ;
 reg  CEC ;
reg  CECARRYIN ; 
 reg  CED ;
 reg  CEM ;
 reg  CEOPMODE ;
 reg  CEP;
 reg  RSTA ;
reg  RSTB ;  
 reg  RSTC ;
reg  RSTCARRYIN ;
reg RSTD ;
reg  RSTM ;
reg  RSTOPMODE ;
reg  RSTP ;
reg [47:0]PCIN ;
reg [17:0]BCIN; 

//can be registered in (CARRYOUTREG = 1) or unregistered (CARRYOUTREG = 0).
 wire  CARRYOUTF_dut ;
 	   	 wire  [17:0] BCOUT_dut ;
	   wire [35:0]  M_dut  ;
wire [47:0] P_dut ,PCOUT_dut ;
  wire CARRYOUT_dut  ;



DSP  #(0,
1,
0,
1,
1,
1,
1,
1,
1,
1,
1,
"OPMODE5",
"DIRECT",
"SYNC") dut (	A,
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
PCOUT_dut,
BCOUT_dut,
M_dut,
P_dut,
CARRYOUT_dut,
CARRYOUTF_dut,
BCIN);




initial begin 
CLK =0;
forever 
#1 CLK=~CLK;
end
integer i;
initial begin 
  RSTA=1 ;
  RSTB=1 ;  
 RSTC =1;
  RSTCARRYIN =1;
 RSTD =1;
  RSTM =1;
  RSTOPMODE =1;
 RSTP =1;
 for (i=0;i<100;i=i+1) begin 
 A=$random; 
B=$random; 
C=$random; 
D=$random; 
CARRYIN=$random; 
opmode=$random; 
CEA=$random; 
CEB=$random; 
CEC=$random; 
CECARRYIN=$random; 
CED=$random; 
CEM=$random; 
CEOPMODE=$random; 
CEP=$random; 
PCIN=$random; 
BCIN=$random; 
@(negedge CLK);
if (
P_dut!=0||
CARRYOUT_dut!=0||
dut.D_mux!=0||dut.B1_mux!=0||dut.A1_mux!=0||
dut.C_mux!=0||
dut.CYI_mux!=0||
dut.M_mux!=0||
dut.OPMODE!=0
) begin
$display ("error");
$stop; 
end
 end 
//
  RSTA=0 ;
  RSTB=0 ;  
 RSTC =0;
  RSTCARRYIN =0;
 RSTD =0;
  RSTM =0;
  RSTOPMODE =0;
 RSTP =0;
CEA=1; 
CEB=1; 
CEC=1; 
CECARRYIN=1; 
CED=1; 
CEM=1; 
CEOPMODE=1; 
CEP=1; 
opmode = 8'b11011101;
A = 20; B = 10; C = 350;  D = 25;
for (i=0;i<1000;i=i+1) begin
	BCIN=$random;
	 PCIN=$random;
	   CARRYIN=$random;
	   	  
	   repeat (4) @(negedge CLK);
if (  CARRYOUTF_dut!= 0 || BCOUT_dut != 'hf || M_dut != 'h12c|| P_dut!='h32 || PCOUT_dut != 'h32 ||CARRYOUT_dut!=0) begin 
$display("error");
$stop;
end
end
//
opmode = 8'b00010000;
A = 20; B = 10; C = 350; D = 25;
for (i=0;i<1000;i=i+1) begin 
BCIN=$random;
 PCIN=$random; 
CARRYIN=$random;

	   repeat (3) @(negedge CLK);
if (  CARRYOUTF_dut!= 0 || BCOUT_dut != 'h23 || M_dut != 'h2bc|| P_dut!=0 || PCOUT_dut != 0 ||CARRYOUT_dut!=0) begin 
$display("error");
$stop;
end
end
//

opmode = 8'b00001010;
A = 20;
 B = 10;
  C = 350;
D = 25;
for (i=0;i<1000;i=i+1) begin 
BCIN=$random;
 PCIN=$random;
 CARRYIN =$random;
  	   repeat (3) @(negedge CLK);
if ( BCOUT_dut != 'ha || M_dut != 'hc8 || CARRYOUTF_dut!= 0 ||
P_dut!=0 || PCOUT_dut != 0 ||CARRYOUT_dut!=0) begin 
$display("error");
$stop;
end
end
opmode = 8'b10100111;
A = 5;
 B = 6;
  C = 350;
   D = 25 ;
    PCIN = 3000 ;
    for(i=0;i<1000;i=i+1) begin 
     BCIN=$random; 
     CARRYIN=$random; 

	   repeat (3) @(negedge CLK);
if (  CARRYOUTF_dut!= 1 || BCOUT_dut != 'h6 || M_dut !='h1e|| P_dut!='hfe6fffec0bb1 || PCOUT_dut != 'hfe6fffec0bb1 ||CARRYOUT_dut!=1) begin 
$display("error");
$stop;
end
    end
end
// initial begin
// $monitor (" A=%b,
// B=%b,
// C=%b,
// D=%b,
// CARRYIN=%b,
// CLK=%b,
// opmode=%b,
// CEA=%b,
// CEB=%b,
// CEC=%b,
// CECARRYIN=%b,
// CED=%b,
// CEM=%b,
// CEOPMODE=%b,
// CEP=%b,
// RSTA=%b,
// RSTB=%b,
// RSTC=%b,
// RSTCARRYIN=%b,
// RSTD=%b,
// RSTM=%b,
// RSTOPMODE=%b,
// RSTP=%b,
// PCIN=%b,
// PCOUT_dut=%b,
// BCOUT_dut=%b,
// M_dut=%b,
// P_dut=%b,
// CARRYOUT_dut=%b,
// CARRYOUTF_dut=%b,
// BCIN=%b",   A,
// B,
// C,
// D,
// CARRYIN,
// CLK,
// opmode,
// CEA,
// CEB,
// CEC,
// CECARRYIN,
// CED,
// CEM,
// CEOPMODE,
// CEP,
// RSTA,
// RSTB,
// RSTC,
// RSTCARRYIN,
// RSTD,
// RSTM,
// RSTOPMODE,
// RSTP,
// PCIN,
// PCOUT_dut,
// BCOUT_dut,
// M_dut,
// P_dut,
// CARRYOUT_dut,
// CARRYOUTF_dut,
// BCIN) ;
// end 
 
endmodule 