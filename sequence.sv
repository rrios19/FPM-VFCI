// Tecnologico de Costa Rica
// Verificacion funcional de circuitos integrados
// S2 2022
// Project 2: Floating point multipliers
// Irene Prieto 
// Ronald Rios

class seq_specific extends uvm_sequence;
	`uvm_object_utils(seq_specific); // Register at the factory

	function new(string name = "seq_specific"); // Builder
		super.new(name);
	endfunction

	int num = 2;	// Number of items
	//constraint cnstr_num {soft num inside {[100:200]};}  // Constraint for the number of items

	virtual task body();
		for(int i=0; i<num; i++)begin
			item myitem = item::type_id::create("myitem");
			myitem.fp_X = 32'h823A9FCC;
			myitem.fp_Y = 32'hBD47B261;
			myitem.r_mode = 1;
			start_item(myitem);
			`uvm_info("Sequence",$sformatf("New item: %s",myitem.print_item_in()),UVM_HIGH);
			finish_item(myitem);
		end	
		`uvm_info("Sequence",$sformatf("Creation of %d items",num),UVM_MEDIUM);
	endtask	
endclass

class seq_random extends uvm_sequence;
	`uvm_object_utils(seq_random); // Register at the factory

	function new(string name = "seq_random"); // Builder
		super.new(name);
	endfunction

	rand int num;	// Number of items
	//constraint cnstr_num {soft num inside {[100:200]};}  // Constraint for the number of items

	virtual task body();
		for(int i=0; i<num; i++)begin
			item myitem = item::type_id::create("myitem");
			myitem.c_rounding.constraint_mode(1);
			myitem.c_random.constraint_mode(1);
			myitem.c_overflow.constraint_mode(0);
			myitem.c_underflow.constraint_mode(0);
			start_item(myitem);
			myitem.randomize();
			`uvm_info("Sequence",$sformatf("New item: %s",myitem.print_item_in()),UVM_HIGH);
			finish_item(myitem);
		end	
		`uvm_info("Sequence",$sformatf("Creation of %d items",num),UVM_MEDIUM);
	endtask	
endclass

class seq_over extends uvm_sequence;
	`uvm_object_utils(seq_over); // Register at the factory

	function new(string name = "seq_over"); // Builder
		super.new(name);
	endfunction

	rand int num;	// Number of items
	//constraint cnstr_num {soft num inside {[100:200]};}  // Constraint for the number of items
	
	virtual task body();
		for(int i=0; i<num; i++)begin
			item myitem = item::type_id::create("myitem");
			myitem.c_rounding.constraint_mode(1);
			myitem.c_random.constraint_mode(0);
			myitem.c_overflow.constraint_mode(1);
			myitem.c_underflow.constraint_mode(0);
			start_item(myitem);
			myitem.randomize();
			`uvm_info("Sequence",$sformatf("New item: %s",myitem.print_item_in()),UVM_HIGH);
			finish_item(myitem);
		end	
		`uvm_info("Sequence",$sformatf("Creation of %d items",num),UVM_MEDIUM);
	endtask	
endclass

class seq_under extends uvm_sequence;
	`uvm_object_utils(seq_under); // Register at the factory

	function new(string name = "seq_under"); // Builder
		super.new(name);
	endfunction

	rand int num;	// Number of items
	//constraint cnstr_num {soft num inside {[100:200]};}  // Constraint for the number of items
	
	virtual task body();
		for(int i=0; i<num; i++)begin
			item myitem = item::type_id::create("myitem");
			myitem.c_rounding.constraint_mode(1);
			myitem.c_random.constraint_mode(0);
			myitem.c_overflow.constraint_mode(0);
			myitem.c_underflow.constraint_mode(1);
			start_item(myitem);
			myitem.randomize();
			`uvm_info("Sequence",$sformatf("New item: %s",myitem.print_item_in()),UVM_HIGH);
			finish_item(myitem);
		end	
		`uvm_info("Sequence",$sformatf("Creation of %d items",num),UVM_MEDIUM);
	endtask	
endclass
