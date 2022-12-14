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
	bit [7:0]	x_exp, y_exp, z_exp;  // Exponents
	bit [22:0]	x_frc, y_frc, z_mnt;  // Fractions 
	bit [31:0]	merge_out;	      // Merge out equal to the DUT out
	bit [47:0]	z_frc;		      // Fraction with all 48 bits
	bit [26:0]	z_nrm;		      // Fraction after the normalizer
	bit [24:0]	z_rnd;		      // Fraction after the rounder
	bit		round, guard, sticky; // Rounding bits 
	bit 		norm_n, norm_r, norm; // Normalizer bits
	bit [7:0]	bias;		      // Bias for the exponent
	int 		int_exp;	      // For overflow and underflow check
	bit 		udr_f, ovr_f, nan_f;  // Flags for checking
	string		str_x;		      // String for fp_X					      		     
	string		str_y;		      // String for fp_Y
	string		str_o;		      // String for ovrf
	string		str_u;		      // String for udrf
	string		str_r;		      // String for r_mode
	string		str_z;		      // String for fp_Z
	string		str_e;		      // String for z_exp
	string		line;		      // String for the whole line

	uvm_analysis_imp #(item,scoreboard) m_analysis_imp;
	
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		m_analysis_imp = new("m_analysis_imp",this);
	endfunction

	virtual function write(item itm);
		ovr_f = 0;
		udr_f = 0;
		nan_f = 0;
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
		int_exp = x_exp + y_exp - bias; // For the flags
		z_exp   = x_exp + y_exp - bias; // Output exponent
		`uvm_info("Scoreboard",$sformatf("x_exp=%0d, y_exp=%0d, z_exp=%0d"
		,x_exp,y_exp,int_exp),UVM_HIGH);
		// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		// Set fraction:
		`uvm_info("Scoreboard",$sformatf("x_frc=%0h, y_frc=%0h, z_frc=%0h",
		x_frc,y_frc,z_mnt),UVM_HIGH);
		// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	
		ovr_f = (( &x_exp)&(~|x_frc) | ( &y_exp)&(~|y_frc)) ? 1 : 0;
		udr_f = ((~|x_exp)&(~|x_frc) | (~|y_exp)&(~|y_frc)) ? 1 : 0;
		nan_f = (( &x_exp)&(~|x_frc) & (~|y_exp)&(~|y_frc)) ? 1 : 0;
		nan_f = (nan_f | (&y_exp)&(~|y_frc)&(~|x_exp)&(~|x_frc)) ? 1 : 0;
		nan_f = (nan_f | (&x_exp)&(&(x_frc ~^ 23'h400000))) ? 1 : 0;
		nan_f = (nan_f | (&y_exp)&(&(y_frc ~^ 23'h400000))) ? 1 : 0;

		if ((ovr_f) || (int_exp >= 255))begin // If X == inf or Y == inf or z_exp greater than 255
			z_exp = 8'hFF;
			z_mnt = 23'h000000;
			ovr_f = 1;
		end
		if ((udr_f) || (int_exp <= 0))begin // If X == 0 or Y == 0 or z_exp less than 0
			z_exp = 8'h00;
			z_mnt = 23'h000000;
			udr_f = 1;	
		end
		if (nan_f) begin // If NaN == 1
			z_exp = 8'hFF;
			z_mnt = 23'h400000;
			//ovr_f = 0;
			//udr_f = 0;
		end
		
		merge_out = (z_sgn << 31) | (z_exp << 23) | (z_mnt) ;

		if (merge_out == itm.fp_Z) begin
			`uvm_info("Scoreboard", $sformatf("PASS, dut_out=%0h, exp_out=%0h",
			itm.fp_Z, merge_out),UVM_MEDIUM)
		end else begin
			`uvm_error("Scoreboard", $sformatf("ERROR, dut_out=%0h, exp_out=%0h, z_exp=%0h",
			itm.fp_Z, merge_out,z_exp))
		end

		ovrf_assert: // Overflow assert
		assert (itm.ovrf ~^ ovr_f)
		else `uvm_error("Scoreboard",$sformatf("nan=%0d, ovrf=%0d, expected ovrf=%0d",nan_f,itm.ovrf,ovr_f))
		
		udrf_assert: // Underflow assert
		assert (itm.udrf ~^ udr_f)
		else `uvm_error("Scoreboard",$sformatf("udrf=%0d, expected udrf=%0d",itm.udrf,udr_f))
		
		nan_assert: // Not a number assert
		assert (nan_f ~^ ((&z_exp) & (&(z_mnt ~^ 23'h400000))))
		else `uvm_error("Scoreboard",$sformatf("expected NaN=%0d",nan_f))
		
		// Report
		str_x.hextoa(itm.fp_X);		// Get the string of X 
		str_y.hextoa(itm.fp_Y);		// Get the srring of Y
		str_r.hextoa(itm.r_mode);	// Get the string of the rounding mode
		str_o.hextoa(itm.ovrf);		// Get the string of the overflow
		str_u.hextoa(itm.udrf);		// Get the string of the underflow
		str_z.hextoa(itm.fp_Z);		// Get the string of Z
		str_e.hextoa(merge_out);	// Get the string of expected out
		line = {str_x,",",str_y,",",str_r,",",str_o,",",str_u,",",str_z,",",str_e};
		$system($sformatf("echo %0s >> report.csv",line));
	endfunction
endclass
