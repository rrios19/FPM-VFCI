// Tecnologico de Costa Rica
// Verificacion funcional de circuitos integrados
// S2 2022
// Project 2: Floating point multipliers
// Irene Prieto 
// Ronald Rios

class environment extends uvm_environment;
	`uvm_object_utils(environment); // Register at the factory

	function new(string name = "environment", uvm_component parent=null); // Builder
		super.new(name,parent);
	endfunction
	
	agent 		agn_inst;
	scoreboard 	scb_inst;

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		agn_inst = agent::type_id::create("agn_inst",this);
		scb_inst = scoreboard::type_id::create("scb_inst",this);
	endfunction
	
	virtual function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		agn_inst.mnt_inst.mon_analysis_port.connect(scb_inst.m_analysis_imp);
endclass
