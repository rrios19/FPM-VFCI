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
	
	//bit [31:0]	fp_x, fp_y;	      // Ins of the DUT and expected out
	bit 		x_sgn, y_sgn, z_sgn;  // Signs
	bit [7:0]	x_exp, y_exp, z_exp;  // Exponents
	bit [22:0]	x_frc, y_frc, z_rnd;  // Fractions 
	bit [31:0]	merge_out;	      // Merge out equal to the DUT out
	bit [45:0]	z_frc;		      // Fraction with 3 extra rounding bits
	bit		round, guard, sticky; // Rounding bits 

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
		z_frc = ((x_frc + 24'h800000) * (y_frc + 24'h800000)) >> 20;
		//z_frc = (x_frc * y_frc) & 32'hFFFFFE00 >> 23;
		`uvm_info("Scoreboard",$sformatf("x_frc=%0h, y_frc=%0h, z_frc=%0b",x_frc,y_frc,z_frc),UVM_HIGH)
		round = (z_frc & 26'h0000004) >> 2;	// First MSB after the MSBs of the fraction 
		guard = (z_frc & 26'h0000002) >> 1;	// MSB after the round bit
		sticky = (z_frc & 26'h0000001);		// MSB after the guard bit
		`uvm_info("Scoreboard",$sformatf("round=%0b, guard=%0b, sticky=%0b",round,guard,sticky),UVM_HIGH);		
		z_frc = z_frc >> 3;
		// Round to nearest, ties to even
		if (itm.r_mode == 3'b000) begin
			if (round == 0) z_rnd = z_frc;
			if ((round & (guard | sticky)) == 1) z_rnd = z_frc + 23'h000001;
			if ((round & ((guard | sticky) + 1)) == 1) begin
				if ((z_frc & 23'h000001) == 0) z_rnd = z_frc;
				else z_rnd = z_frc + 23'h000001;
			end			
		end

		// Round to zero	
		if (itm.r_mode == 3'b001) z_rnd = z_frc; 
		
		// Round towards negative infinity
		if (itm.r_mode == 3'b010) begin
			if (z_sgn == 0) z_rnd = z_frc;
			else z_rnd = z_frc + 23'h000001;
		end

		// Round towards positive infinity
		if (itm.r_mode == 3'b011) begin
			if (z_sgn == 1) z_rnd = z_frc;
			else z_rnd = z_frc + 23'h000001;
		end

		// Round to nearest, ties away from zero
		if (itm.r_mode == 3'b100) begin
			if (round == 0) z_rnd = z_frc;
			else z_rnd = z_frc + 23'h000001;
		end
		`uvm_info("Scoreboard",$sformatf("z_rnd=%0b",z_rnd),UVM_HIGH);
		merge_out = (z_sgn << 31) | (z_exp << 23) | (z_rnd) ;
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
