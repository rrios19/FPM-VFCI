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

module tb
	reg clk
	always #10 clk =~ clk;
	dut_if _if(clk);
	
	top  u1(.clk(clk),
		.r_mode(_if.r_mode),
		.fp_X(_if.fp_X),
		.fp_Y(_if.fp_Y),
		.fp_Z(_if.fp_Z),
		.ovrf(_if.ovrf),
		.udrf(udrf));

	initial begin
		clk <= 0;
		uvm_config_db#(virtual dut_if)::set(null,"uvm_test_top","dut_vif",_if);
		run_test("test_name");
	end
	
endmodule
