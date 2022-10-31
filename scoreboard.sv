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
	
	bit 		x_sgn, y_sgn, z_sgn;  // Signs
	bit [8:0]	x_exp, y_exp, z_exp;  // Exponents
	bit [22:0]	x_frc, y_frc, z_mnt;  // Fractions 
	bit [31:0]	merge_out;	      // Merge out equal to the DUT out
	bit [47:0]	z_frc;		      // Fraction with all 48 bits
	bit [26:0]	z_nrm;		      // Fraction after the normalizer
	bit [24:0]	z_rnd;		      // Fraction after the rounder
	bit		round, guard, sticky; // Rounding bits 
	bit 		norm_n, norm_r, norm; // Normalizer bits
	bit [7:0]	bias;		      // Bias for the exponent

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
		// --------------------------------------------------------------------
		// For the exponent:	
		x_exp = (itm.fp_X & 32'h7F800000) >> 23; // Gets the X exponent
		y_exp = (itm.fp_Y & 32'h7F800000) >> 23; // Gets the Y exponent
		// --------------------------------------------------------------------
		// For the fraction:	
		x_frc = (itm.fp_X & 32'h007FFFFF); // Gets the X exponent
		y_frc = (itm.fp_Y & 32'h007FFFFF); // Gets the X exponent
		z_frc = ((x_frc + 24'h800000) * (y_frc + 24'h800000)); // Compute the multiplication
		norm_n = (z_frc >> 47) & 1; // Gets the norm
		z_frc = z_frc << !norm_n;
		sticky = |(z_frc & 22'h3FFFFF); // Gets the sticky bit
		z_nrm = ((z_frc >> 22) << 1) | sticky;	// Fraction after the normalizer
		round = (z_nrm & 27'h0000004) >> 2;	// Gets the round bit 
		guard = (z_nrm & 27'h0000002) >> 1;	// Gets the guard bit
		z_nrm = (z_nrm >> 3);			// Delete the rounding bits
		// Round to nearest, ties to even
		if (itm.r_mode == 3'b000) begin
			if (round == 0) z_rnd = z_nrm;
			if ((round & (guard | sticky)) == 1) z_rnd = z_nrm + 25'h000001;
			if ((round & ((guard | sticky) + 1)) == 1) begin
				if ((z_nrm & 25'h000001) == 0) z_rnd = z_nrm;
				else z_rnd = z_nrm + 25'h000001;
			end			
		end
		// Round to zero	
		if (itm.r_mode == 3'b001) z_rnd = z_nrm; 
		// Round towards negative infinity
		if (itm.r_mode == 3'b010) begin
			if (z_sgn == 0) z_rnd = z_nrm;
			else z_rnd = z_nrm + 25'h000001;
		end
		// Round towards positive infinity
		if (itm.r_mode == 3'b011) begin
			if (z_sgn == 1) z_rnd = z_nrm;
			else z_rnd = z_nrm + 25'h000001;
		end
		// Round to nearest, ties away from zero
		if (itm.r_mode == 3'b100) begin
			if (round == 0) z_rnd = z_nrm;
			else z_rnd = z_nrm + 25'h000001;
		end
		norm_r = z_rnd >> 24;
		z_mnt = norm_r ? (z_rnd >> 1) & 23'h7FFFFF : (z_rnd >> 0) & 23'h7FFFFF;
		// --------------------------------------------------------------------

		// Set sign: Sign is ready
		`uvm_info("Scoreboard",$sformatf("x_sgn=%0h, y_sgn=%0h, z_sgn=%0h"
		,x_sgn,y_sgn,z_sgn),UVM_HIGH);
		// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		// Set exponent:
		norm = norm_n | norm_r;
		bias = norm ? 8'h7E : 8'h7F;
		z_exp = x_exp + y_exp - bias; // OR for the output exponent
		`uvm_info("Scoreboard",$sformatf("x_exp=%0h, y_exp=%0h, z_exp=%0h"
		,x_exp,y_exp,z_exp),UVM_HIGH);
		// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		// Set fraction:
		`uvm_info("Scoreboard",$sformatf("x_frc=%0h, y_frc=%0h, z_frc=%0h",
		x_frc,y_frc,z_mnt),UVM_HIGH);
		// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

		//if ((z_exp >> 8) == 1) z_exp = 8'hFF;
		
		merge_out = (z_sgn << 31) | (z_exp << 23) | (z_mnt) ;

		if (merge_out == itm.fp_Z) begin
			`uvm_info("Scoreboard", $sformatf("PASS, dut_out=%0h, exp_out=%0h",
			itm.fp_Z, merge_out),UVM_MEDIUM)
		end else begin
			`uvm_error("Scoreboard", $sformatf("ERROR, dut_out=%0h, exp_out=%0h",
			itm.fp_Z, merge_out))
		end
	endfunction
endclass
