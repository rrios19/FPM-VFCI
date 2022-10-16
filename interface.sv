// Tecnologico de Costa Rica
// Verificacion funcional de circuitos integrados
// S2 2022
// Project 2: Floating point multipliers
// Irene Prieto 
// Ronald Rios

// Interface to connect the DUT
interface dut_if(input bit clk);
	logic [2:0]r_mode;               // Rounding
	logic [31:0]fp_X, fp_Y, fp_Z;	 // Inputs X,Y. Result Z
	logic ovrf,udrf;		 // Overflow and underflow flags

	clocking cb @(posedge clk);
		default input #1step output #3ns;
		input  ovrf
		input  udrf;
		input  fp_Z;
		output fp_X;
		output fp_Y;
		output r_mode;
	endclocking
endinterface
