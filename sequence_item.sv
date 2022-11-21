// Tecnologico de Costa Rica
// Verificacion funcional de circuitos integrados
// S2 2022
// Project 2: Floating point multipliers
// Irene Prieto 
// Ronald Rios

class item extends uvm_sequence_item;
	`uvm_object_utils(item); // Register at the factory

	function new(string name = "item"); // Builder
		super.new(name);
	endfunction

	rand bit  [31:0]fp_X;  // Random X input
	rand bit  [31:0]fp_Y;  // Random Y input
	bit       [31:0]fp_Z;  // Output
	randc bit [2:0]r_mode; // Rounding mode
	bit       ovrf;	      // Overflow flag
	bit	  udrf;	      // Underflow flag
	
	virtual function string print_item_in(); // Prints the input item
		return $sformatf("fp_X=%0h, fp_Y=%0h, r_mode=%0d",
		fp_X,fp_Y,r_mode);
	endfunction

	virtual function string print_item_out(); // Prints the output item
		return $sformatf("fp_X=%0h, fp_Y=%0h, fp_Z=%0h, r_mode=%0d, ovrf=%0b, udrf=%0b",
		fp_X,fp_Y,fp_Z,r_mode,ovrf,udrf);
	endfunction
	
	// *************************************Constraints*************************************
	
	// Rounding mode	
	constraint c_rounding {r_mode inside{3'b000,3'b001,3'b010,3'b011,3'b100};}
	
	// Specific values
	constraint c_specific {
	fp_X inside {32'h00000000,32'h80000000,32'hFFFFFFFF,32'h7FFFFFFF,32'h7FC00000,32'hFFC00000,32'h55555555,32'hAAAAAAAA};
	fp_Y inside {32'h00000000,32'h80000000,32'hFFFFFFFF,32'h7FFFFFFF,32'h7FC00000,32'hFFC00000,32'h55555555,32'hAAAAAAAA};}
	
	// Constraint for overflow
	constraint c_overflow {fp_X[30:23] + fp_Y[30:23]  >= 382;}

	// Constraint for  underflow
	constraint c_underflow {fp_X[30:23]  + fp_Y[30:23] <= 126;}

	// Constraint for NaN
	constraint c_nan {(&fp_X[30:22])&(~|fp_X[21:0]) | (&fp_Y[30:22])&(~|fp_Y[21:0]);}
	
	// Constraint between overflow and underflow 
	constraint c_between {fp_X[30:23] + fp_Y[30:23] > 126; fp_X[30:23] + fp_Y[30:23] < 382;}
endclass
