// Tecnologico de Costa Rica
// Verificacion funcional de circuitos integrados
// S2 2022
// Project 2: Floating point multipliers
// Irene Prieto 
// Ronald Rios

class test_name extends uvm_test;
	`uvm_object_utils(test_name); // Register at the factory

	function new(string name = "test_name", uvm_component parent=null); // Builder
		super.new(name,parent);
	endfunction
	
	environment env_inst;

	mysequence	seq;
	virtual dut_if  vif;

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		env_inst = environment::type_id::create("env_inst",this);
	
		if(!uvm_config_db#(virtual dut_if)::get(this,"","dut_vif",vif))
			`uvm_fatal("Test","Could not get vif")
		uvm_config_db#(virtual dut_if)::set(this,"env_inst.agn_inst.*","dut_vif",vif);
		
		seq = mysequence::type_id::create("seq");
		seq.randomize() with {num inside{[10:20]};}
	endfunction

	virtual task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		seq.start(env_inst.agn_inst.seq_inst);
		phase.drop_objection(this);
	endtask
endclass
