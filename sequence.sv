// Tecnologico de Costa Rica
// Verificacion funcional de circuitos integrados
// S2 2022
// Project 2: Floating point multipliers
// Irene Prieto 
// Ronald Rios

class mysequence extends uvm_sequence;
	`uvm_object_utils(mysequence); // Register at the factory

	function new(string name = "mysequence"); // Builder
		super.new(name);
	endfunction

	rand int num; 					  // Number of items
	constraint cnstr_num {soft num inside {[1:10]};}  // Constraint for the number of items

	virtual task body();
		for(int i=0; i<num; i++)begin
			item myitem = item::type_id::create("myitem");
			start_item(myitem);
			myitem.randomize();
			`uvm_info("Sequence",$sformatf("New item: %s",myitem.convert2str()),UVM_HIGH);
			finish_item(myitem);
		end	
		`uvm_info("Sequence",$sformatf("Creation of %d items",num),UVM_LOW);
	endtask	
endclass
