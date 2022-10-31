// Tecnologico de Costa Rica
// Verificacion funcional de circuitos integrados
// S2 2022
// Project 2: Floating point multipliers
// Irene Prieto 
// Ronald Rios

class driver extends uvm_driver #(item);
	`uvm_component_utils(driver); // Register at the factory

	function new(string name = "driver", uvm_component parent=null); // Builder
		super.new(name,parent);
	endfunction
	
	virtual dut_if vif; // Virtual interface for the DUT

	virtual function void build_phase(uvm_phase phase); // Build phase
		super.build_phase(phase);
		if (!uvm_config_db #(virtual dut_if)::get(this,"","dut_vif",vif))
			`uvm_fatal("Driver","Could not get vif")
	endfunction

	virtual task run_phase(uvm_phase phase);
		super.run_phase(phase);
		forever begin
			item itm; // New pointer myitem of type item
			seq_item_port.get_next_item(itm); // It gets the item from the sequence port
			driver_item(itm); 	          // It calls the task to process the item
			`uvm_info("Driver",$sformatf("Item %s",itm.print_item_in()),UVM_MEDIUM)
			seq_item_port.item_done();        // It allows the port to get a new item when the item is done
			#10;
		end
	endtask

	virtual task driver_item(item itm);
		@(posedge vif.clk);begin // On a positive edge of the "cb"  clock
			vif.fp_X   <= itm.fp_X; 	// Puts the value "X" of the item, in the out "X" of the interface
			vif.fp_Y   <= itm.fp_Y;	// Puts the value "Y" of the item, in the out "Y" of the interface
			vif.r_mode <= itm.r_mode; 	// Puts the value "r" of the item, in the out "r" of the interface
		end
	endtask
endclass
