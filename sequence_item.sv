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

	bit [31:0]fp_X = 32'h732B7DE6;  // Random X input
	bit [31:0]fp_Y = 32'h47A4E38F;  // Random Y input
	bit      [31:0]fp_Z;  // Output
	rand bit [2:0]r_mode; // Rounding mode
	bit      ovrf;	      // Overflow flag
	bit	 udrf;	      // Underflow flag
	
	virtual function string print_item_in(); // Prints the input item
		return $sformatf("fp_X=%0h, fp_Y=%0h, r_mode=%0b",
		fp_X,fp_Y,r_mode);
	endfunction

	virtual function string print_item_out(); // Prints the output item
		return $sformatf("fp_X=%0h, fp_Y=%0h, fp_Z=%0h, r_mode=%0b, ovrf=%0b, udrf=%0b",
		fp_X,fp_Y,fp_Z,r_mode,ovrf,udrf);
	endfunction

	// Constraints
	constraint cnstr_rounding {r_mode < 3'b001;}
endclass
