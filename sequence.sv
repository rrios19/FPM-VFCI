// Tecnologico de Costa Rica
// Verificacion funcional de circuitos integrados
// S2 2022
// Project 2: Floating point multipliers
// Irene Prieto 
// Ronald Rios

// Specific sequence, used for test values and debug
class seq_specific extends uvm_sequence;
	`uvm_object_utils(seq_specific); // Register at the factory

	function new(string name = "seq_specific"); // Builder
		super.new(name);
	endfunction

	int num = 2;	// Number of items

	virtual task body();
		for(int i=0; i<num; i++)begin
			item myitem = item::type_id::create("myitem");
			myitem.fp_X = 32'hC645D861;
			myitem.fp_Y = 32'hF8C83837;
			myitem.r_mode = 3;
			start_item(myitem);
			`uvm_info("Sequence",$sformatf("New item: %s",myitem.print_item_in()),UVM_HIGH);
			finish_item(myitem);
		end	
		`uvm_info("Sequence",$sformatf("Creation of %d items",num),UVM_LOW);
	endtask	
endclass

// Random sequence with values between overflow and underflow
class seq_between extends uvm_sequence;
	`uvm_object_utils(seq_between); // Register at the factory

	function new(string name = "seq_between"); // Builder
		super.new(name);
	endfunction

	rand int num;	// Number of items

	virtual task body();
		for(int i=0; i<num; i++)begin
			item myitem = item::type_id::create("myitem");
			myitem.c_rounding.constraint_mode(1);
			myitem.c_between.constraint_mode(1);
			myitem.c_overflow.constraint_mode(0);
			myitem.c_underflow.constraint_mode(0);
			start_item(myitem);
			myitem.randomize();
			`uvm_info("Sequence",$sformatf("New item: %s",myitem.print_item_in()),UVM_HIGH);
			finish_item(myitem);
		end	
		`uvm_info("Sequence",$sformatf("Creation of %d items",num),UVM_LOW);
	endtask	
endclass

// Overflow sequence
class seq_over extends uvm_sequence;
	`uvm_object_utils(seq_over); // Register at the factory

	function new(string name = "seq_over"); // Builder
		super.new(name);
	endfunction

	rand int num;	// Number of items
	
	virtual task body();
		for(int i=0; i<num; i++)begin
			item myitem = item::type_id::create("myitem");
			myitem.c_rounding.constraint_mode(1);
			myitem.c_between.constraint_mode(0);
			myitem.c_overflow.constraint_mode(1);
			myitem.c_underflow.constraint_mode(0);
			start_item(myitem);
			myitem.randomize();
			`uvm_info("Sequence",$sformatf("New item: %s",myitem.print_item_in()),UVM_HIGH);
			finish_item(myitem);
		end	
		`uvm_info("Sequence",$sformatf("Creation of %d items",num),UVM_LOW);
	endtask	
endclass

// Underflow sequence
class seq_under extends uvm_sequence;
	`uvm_object_utils(seq_under); // Register at the factory

	function new(string name = "seq_under"); // Builder
		super.new(name);
	endfunction

	rand int num;	// Number of items
	
	virtual task body();
		for(int i=0; i<num; i++)begin
			item myitem = item::type_id::create("myitem");
			myitem.c_rounding.constraint_mode(1);
			myitem.c_between.constraint_mode(0);
			myitem.c_overflow.constraint_mode(0);
			myitem.c_underflow.constraint_mode(1);
			start_item(myitem);
			myitem.randomize();
			`uvm_info("Sequence",$sformatf("New item: %s",myitem.print_item_in()),UVM_HIGH);
			finish_item(myitem);
		end	
		`uvm_info("Sequence",$sformatf("Creation of %d items",num),UVM_LOW);
	endtask	
endclass
