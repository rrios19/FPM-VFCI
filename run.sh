source synopsys_tools.sh;
#rm -rfv `ls |grep -v ".*\.sv\|.*\.sh"`;
rm -r log_test ucli.key verdi_config_file csrc/ salida salida.daidir/ salida.vdb/ vc_hdrs.h .fsm.sch.verilog.xml;

vcs -Mupdate report.cpp testbench.sv -o salida -full64 -debug_acc+all -debug_region+cell+encrypt -sverilog -l log_test -ntb_opts uvm +lint=TFIPC-L -kdb -cm line+tgl+cond+fsm+branch+assert;

./salida +UVM_VERBOSITY=UVM_LOW +UVM_TESTNAME=test_under +ntb_random_seed=1;
./salida +UVM_VERBOSITY=UVM_LOW +UVM_TESTNAME=test_under +ntb_random_seed=2;
./salida +UVM_VERBOSITY=UVM_LOW +UVM_TESTNAME=test_under +ntb_random_seed=3;





#./salida +UVM_VERBOSITY=UVM_MEDIUM +UVM_TESTNAME=test_under +ntb_random_seed=1;

#./salida +UVM_VERBOSITY=UVM_HIGH +UVM_TESTNAME=mytest +ntb_random_seed=1 -gui;
#./salida +UVM_VERBOSITY=UVM_HIGH +UVM_TESTNAME=mytest +ntb_random_seed=2 > deleteme_log_2;

#./salida -cm line+tgl+cond+fsm+branch+assert;
#dve -full64 -covdir salida.vdb &;
#Verdi -cov -covdir salida.vdb
