// Tecnologico de Costa Rica
// Verificacion funcional de circuitos integrados
// S2 2022
// Project 2: Floating point multipliers
// Irene Prieto 
// Ronald Rios

class scoreboard extends uvm_example_something;
	`uvm_object_utils(scoreboard); // Register at the factory

	function new(string name = "scoreboard", uvm_component parent=null); // Builder
		super.new(name,parent);
	endfunction
	
	bit [31:0] fp_x, fp_y, aux_out, exp_out;
	bit sig_out; // Output sign
	bit [7:0] exp_X, exp_Y, exp_Z; // Exponent

	uvm_analysis_imp #(item,scoreboard) m_analysis_imp;
	
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	virtual function write(item itm);
		sig_out = itm.fp_X[31]^itm.fp_Y[31]; // XOR fot the output sign
		

		//fp_x = itm.fp_X;
		//fp_y = itm.fp_Y;
		//aux_out = fp_x*fp_y;
	endfunction
endclass
