// Tecnologico de Costa Rica
// Verificacion funcional de circuitos integrados
// S2 2022
// Proyecto 2: Floating point multipliers
// Irene Prieto 
// Ronald Rios

// Interface que conecta el dUT
interface dut_if(input bit clk);
	logic [2:0]r_mode;               // Redondeo
	logic [31:0]fp_X, fp_Y, fp_Z;	 // Entradas X,Y. Resultado Z
	logic ovrf,undrf;		 // Overflow and onderflow flags

	clocking cb @(posedge clk);
		default input #1step output #3ns;
		input ovrf
		input undrf;
		input fp_Z;
		output fp_X;
		output fp_Y;
		output r_mode;
	endclocking
endinterface
