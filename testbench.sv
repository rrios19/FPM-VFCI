// Tecnologico de Costa Rica
// Verificacion funcional de circuitos integrados
// S2 2022
// Project 2: Floating point multipliers
// Irene Prieto 
// Ronald Rios

//`timescale 1ns/1ps
`include "uvm_macros.svh"
import uvm_pkg::*;
`include "dut.sv"
`include "interface.sv"
`include "sequence_item.sv"
`include "sequence.sv"
`include "monitor.sv"
`include "driver.sv"
`include "scoreboard.sv"
`include "agent.sv"
`include "environment.sv"
`include "test.sv"

module tb;	
	import "DPI-C" context function int report();
	reg clk;
	always #10 clk =~ clk;
	dut_if _if(clk);
	
	top  u0(.clk(clk),
		.r_mode(_if.r_mode),
		.fp_X(_if.fp_X),
		.fp_Y(_if.fp_Y),
		.fp_Z(_if.fp_Z),
		.ovrf(_if.ovrf),
		.udrf(_if.udrf));

	initial begin
		clk <= 0;
		uvm_config_db#(virtual dut_if)::set(null,"uvm_test_top","dut_vif",_if);
		run_test("test_under");
	end
	
endmodule
