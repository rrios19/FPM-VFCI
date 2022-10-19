// Tecnologico de Costa Rica
// Verificacion funcional de circuitos integrados
// S2 2022
// Project 2: Floating point multipliers
// Irene Prieto 
// Ronald Rios

class agent extends uvm_agent;
	`uvm_object_utils(agent); // Register at the factory

	function new(string name = "agent", uvm_component parent=null); // Builder
		super.new(name,parent);
	endfunction

	driver 			drv_inst;
	monitor 	        mnt_inst;
	uvm_sequencer #(item) 	seq_inst;
	
	virtual function void build_phase(uvm_phase phase)
endclass
