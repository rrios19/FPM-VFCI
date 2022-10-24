// Tecnologico de Costa Rica
// Verificacion funcional de circuitos integrados
// S2 2022
// Project 2: Floating point multipliers
// Irene Prieto 
// Ronald Rios

class test extends uvm_test;
	`uvm_component_utils(test); // Register at the factory

	function new(string name = "test", uvm_component parent=null); // Builder
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
		seq.randomize() with {num inside{[1:10]};};
	endfunction

	virtual task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		seq.start(env_inst.agn_inst.seq_inst);
		phase.drop_objection(this);
	endtask
endclass

class test_1 extends test;
	`uvm_component_utils(test_1); // Register at the factory

	function new(string name = "test_1", uvm_component parent=null); // Builder
		super.new(name,parent);
	endfunction
	
	mysequence 	seq;
	
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		seq = mysequence::type_id::create("seq");
		seq.randomize() with {num inside{[1:10]};};
	endfunction

	virtual task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		seq.start(env_inst.agn_inst.seq_inst);
		#50
		phase.drop_objection(this);
	endtask
endclass
