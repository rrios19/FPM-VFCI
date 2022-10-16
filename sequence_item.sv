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

	rand bit [31:0]fp_X;  // Random X input
	rand bit [31:0]fp_Y;  // Random Y input
	bit      [31:0]fp_Z;  // Output
	rand bit [2:0]r_mode; // Rounding mode
	bit      ovrf;	      // Overflow flag
	bit	 udrf;	      // Underflow flag

	virtual function string convert2str();
		return $sformatf("fp_X=%0d, fp_Y=%0d, fp_Z=%0d, r_mode=%0d, ovrf=%0d, udrf=%0d",
		fp_X,fp_Y,fp_Z,r_mode,ovrf,udrf);
	endfunction

	// Constraints
	//constraint constraintname{condition}
endclass
