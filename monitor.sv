// Tecnologico de Costa Rica
// Verificacion funcional de circuitos integrados
// S2 2022
// Project 2: Floating point multipliers
// Irene Prieto 
// Ronald Rios

class monitor extends uvm_monitor;
	`uvm_component_utils(monitor); // Register at the factory

	function new(string name = "monitor", uvm_component parent=null); // Builder
		super.new(name,parent);
	endfunction
	
	virtual dut_if vif; // Virtual interface for the DUT
	uvm_analysis_port #(item) mon_analysis_port; // New pointer for the analysis port of type item

	virtual function void build_phase(uvm_phase phase); // Build phase
		super.build_phase(phase);
		if (!uvm_config_db #(virtual dut_if)::get(this,"","dut_vif",vif))
			`uvm_fatal("Monitor","Could not get vif")
		mon_analysis_port = new("mon_analysis_port",this); // It creates the port with the pointer
	endfunction

	virtual task run_phase(uvm_phase phase);
		super.run_phase(phase);
		 forever @(negedge vif.clk)begin // Forever on a positive edge of the "cb"  clock
			item itm = item::type_id::create("itm"); // New pointer itm of type item
			itm.r_mode = vif.r_mode;  // Gets the value "r" from the interface
			itm.fp_X   = vif.fp_X;    // Gets the value "X" from the interface
			itm.fp_Y   = vif.fp_Y;    // Gets the value "Y" from the interface
			itm.fp_Z   = vif.fp_Z; // Gets the value "Z" from the input "Z" of the interface
			itm.ovrf   = vif.ovrf; // Gets the value "ovrf" from the input "ovrf" of the interface
			itm.udrf   = vif.udrf; // Gets the value "udrf" from the input "udrf" of the interface				
			`uvm_info("Monitor",$sformatf("Item %s",itm.print_item_out()),UVM_HIGH)
			mon_analysis_port.write(itm);
		end
	endtask
endclass
