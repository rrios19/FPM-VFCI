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

	seq_default	s_def;
	seq_specific	s_spe;
	seq_over	s_ove;
	seq_under	s_und;
	seq_nan		s_nan;
	seq_between	s_bet;

	virtual dut_if  vif;

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		env_inst = environment::type_id::create("env_inst",this);
	
		if(!uvm_config_db#(virtual dut_if)::get(this,"","dut_vif",vif))
			`uvm_fatal("Test","Could not get vif")
		uvm_config_db#(virtual dut_if)::set(this,"env_inst.agn_inst.*","dut_vif",vif);
		
		s_def = seq_default::type_id::create("s_def");
		s_spe = seq_specific::type_id::create("s_spe");
		s_ove = seq_over::type_id::create("s_ove");
		s_und = seq_under::type_id::create("s_und");
		s_nan = seq_nan::type_id::create("s_nan");
		s_bet = seq_between::type_id::create("s_bet");
		s_def.randomize() with {num inside{[50:60]};};
		s_spe.randomize() with {num inside{[50:60]};};
		s_ove.randomize() with {num inside{[50:60]};};
		s_und.randomize() with {num inside{[50:60]};};
		s_nan.randomize() with {num inside{[50:60]};};
		s_bet.randomize() with {num inside{[50:60]};};
	endfunction

	virtual task run_phase(uvm_phase phase);
		report();
		phase.raise_objection(this);
		s_def.start(env_inst.agn_inst.seq_inst);
		s_spe.start(env_inst.agn_inst.seq_inst);
		s_ove.start(env_inst.agn_inst.seq_inst);
		s_und.start(env_inst.agn_inst.seq_inst);
		s_nan.start(env_inst.agn_inst.seq_inst);
		s_bet.start(env_inst.agn_inst.seq_inst);
		phase.drop_objection(this);
	endtask
endclass

// One specific test, used for test values and debug
class test_debug extends test;
	`uvm_component_utils(test_debug); // Register at the factory

	function new(string name = "test_debug", uvm_component parent=null); // Builder
		super.new(name,parent);
	endfunction
	
	seq_debug 	seq;
	
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		seq = seq_debug::type_id::create("seq");
	endfunction

	virtual task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		seq.start(env_inst.agn_inst.seq_inst);
		phase.drop_objection(this);
	endtask
endclass

// Specific test, used for alternate values and corner values
class test_specific extends test;
	`uvm_component_utils(test_specific); // Register at the factory

	function new(string name = "test_specific", uvm_component parent=null); // Builder
		super.new(name,parent);
	endfunction
	
	seq_specific 	seq;

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		seq = seq_specific::type_id::create("seq");
		seq.randomize() with {num inside{[50:60]};};
	endfunction

	virtual task run_phase(uvm_phase phase);
		report();
		phase.raise_objection(this);
		seq.start(env_inst.agn_inst.seq_inst);
		phase.drop_objection(this);
	endtask
endclass

// Overflow test, using any value X or Y that result is greater than 255+bias
class test_over extends test;
	`uvm_component_utils(test_over); // Register at the factory

	function new(string name = "test_over", uvm_component parent=null); // Builder
		super.new(name,parent);
	endfunction
	
	seq_over 	seq;

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		seq = seq_over::type_id::create("seq");
		seq.randomize() with {num inside{[50:60]};};
	endfunction

	virtual task run_phase(uvm_phase phase);
		report();
		phase.raise_objection(this);
		seq.start(env_inst.agn_inst.seq_inst);
		phase.drop_objection(this);
	endtask
endclass

// Underflow test, using any value X or Y that result is less than bias
class test_under extends test;
	`uvm_component_utils(test_under); // Register at the factory

	function new(string name = "test_under", uvm_component parent=null); // Builder
		super.new(name,parent);
	endfunction
	
	seq_under 	seq;

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		seq = seq_under::type_id::create("seq");
		seq.randomize() with {num inside{[50:60]};};
	endfunction

	virtual task run_phase(uvm_phase phase);
		report();
		phase.raise_objection(this);
		seq.start(env_inst.agn_inst.seq_inst);
		phase.drop_objection(this);
	endtask
endclass

// Not a number test, X is NaN or Y is NaN or both
class test_nan extends test;
	`uvm_component_utils(test_nan); // Register at the factory

	function new(string name = "test_nan", uvm_component parent=null); // Builder
		super.new(name,parent);
	endfunction
	
	seq_nan 	seq;

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		seq = seq_nan::type_id::create("seq");
		seq.randomize() with {num inside{[50:60]};};
	endfunction

	virtual task run_phase(uvm_phase phase);
		report();
		phase.raise_objection(this);
		seq.start(env_inst.agn_inst.seq_inst);
		phase.drop_objection(this);
	endtask
endclass

// Between test
class test_between extends test;
	`uvm_component_utils(test_between); // Register at the factory

	function new(string name = "test_between", uvm_component parent=null); // Builder
		super.new(name,parent);
	endfunction
	
	seq_between 	seq;

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		seq = seq_between::type_id::create("seq");
		seq.randomize() with {num inside{[50:60]};};
	endfunction

	virtual task run_phase(uvm_phase phase);
		report();
		phase.raise_objection(this);
		seq.start(env_inst.agn_inst.seq_inst);
		phase.drop_objection(this);
	endtask
endclass
