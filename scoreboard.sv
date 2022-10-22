// Tecnologico de Costa Rica
// Verificacion funcional de circuitos integrados
// S2 2022
// Project 2: Floating point multipliers
// Irene Prieto 
// Ronald Rios

class scoreboard extends uvm_scoreboard;
	`uvm_component_utils(scoreboard); // Register at the factory

	function new(string name = "scoreboard", uvm_component parent=null); // Builder
		super.new(name,parent);
	endfunction
	
	bit [31:0] fp_x, fp_y, aux_out, exp_out;
	bit 		x_sgn, y_sgn, z_sgn; // Signs
	bit [7:0]	x_exp, y_exp, z_exp; // Exponents
	bit [22:0]	x_frc, y_frc; // Fractions 
	bit [31:0]	merge_out;
	bit [45:0]	z_frc;

	uvm_analysis_imp #(item,scoreboard) m_analysis_imp;
	
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		m_analysis_imp = new("m_analysis_imp",this);
	endfunction

	virtual function write(item itm);
		// For the sign:
		x_sgn = (itm.fp_X & 32'h80000000) >> 31; // Gets the X sign
		y_sgn = (itm.fp_Y & 32'h80000000) >> 31; // Gets the Y sign
		z_sgn = x_sgn ^ y_sgn; // XOR for the output sign
		`uvm_info("Scoreboard",$sformatf("x_sgn=%0h, y_sgn=%0h, z_sgn=%0h",x_sgn,y_sgn,z_sgn),UVM_HIGH);
		// For the exponent:	
		x_exp = (itm.fp_X & 32'h7F800000) >> 23; // Gets the X exponent
		y_exp = (itm.fp_Y & 32'h7F800000) >> 23; // Gets the Y exponent
		z_exp = x_exp + y_exp - 8'h7F; // OR for the output exponent
		`uvm_info("Scoreboard",$sformatf("x_exp=%0h, y_exp=%0h, z_exp=%0h",x_exp,y_exp,z_exp),UVM_HIGH);
		// For the fraction	
		x_frc = (itm.fp_X & 32'h007FFFFF); // Gets the X exponent
		y_frc = (itm.fp_Y & 32'h007FFFFF); // Gets the X exponent
		z_frc = ((x_frc + 24'h800000) * (y_frc + 24'h800000)) >> 23;
		//z_frc = (x_frc * y_frc) & 32'hFFFFFE00 >> 23;
		`uvm_info("Scoreboard",$sformatf("x_frc=%0h, y_frc=%0h, z_frc=%0b",x_frc,y_frc,z_frc),UVM_HIGH);

		merge_out = (z_sgn << 31) | (z_exp << 23) | (z_frc) ;
		`uvm_info("Scoreboard",$sformatf("merge_out=%0b",merge_out),UVM_HIGH);

		if (merge_out == itm.fp_Z) begin
			`uvm_info("Scoreboard", $sformatf("Pass, dut_out=%0h, exp_out=%0h",
			itm.fp_Z, merge_out),UVM_HIGH)
		end else begin
			`uvm_error("Scoreboard", $sformatf("Error, dut_out=%0h, exp_out=%0h",
			itm.fp_Z, merge_out))
		end
	endfunction
endclass
