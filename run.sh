source synopsys_tools.sh;
rm -rfv `ls |grep -v ".*\.sv\|.*\.sh\|.*\.cpp\|.*\.csv\|.*\.md\|.*\.png"`;

vcs -Mupdate report.cpp testbench.sv -o salida -full64 -debug_acc+all -debug_region+cell+encrypt -sverilog -l log_test -ntb_opts uvm +lint=TFIPC-L -kdb -cm line+tgl+cond+fsm+branch+assert;

######### FOR DEBUG ###############################################################
#./salida +UVM_VERBOSITY=UVM_HIGH +UVM_TESTNAME=test_debug +ntb_random_seed=1 -gui;

######### Default test ############################################################
./salida +UVM_VERBOSITY=UVM_LOW +UVM_TESTNAME=test +ntb_random_seed=16;
######### Specific test ###########################################################
./salida +UVM_VERBOSITY=UVM_LOW +UVM_TESTNAME=test_specific +ntb_random_seed=1;
./salida +UVM_VERBOSITY=UVM_LOW +UVM_TESTNAME=test_specific +ntb_random_seed=2;
./salida +UVM_VERBOSITY=UVM_LOW +UVM_TESTNAME=test_specific +ntb_random_seed=3;
######### Overflow test ###########################################################
./salida +UVM_VERBOSITY=UVM_LOW +UVM_TESTNAME=test_over +ntb_random_seed=4;
./salida +UVM_VERBOSITY=UVM_LOW +UVM_TESTNAME=test_over +ntb_random_seed=5;
./salida +UVM_VERBOSITY=UVM_LOW +UVM_TESTNAME=test_over +ntb_random_seed=6;
#########  Underflow test #########################################################
./salida +UVM_VERBOSITY=UVM_LOW +UVM_TESTNAME=test_under +ntb_random_seed=7;
./salida +UVM_VERBOSITY=UVM_LOW +UVM_TESTNAME=test_under +ntb_random_seed=8;
./salida +UVM_VERBOSITY=UVM_LOW +UVM_TESTNAME=test_under +ntb_random_seed=9;
######### Not a number test #######################################################
./salida +UVM_VERBOSITY=UVM_LOW +UVM_TESTNAME=test_nan +ntb_random_seed=10;
./salida +UVM_VERBOSITY=UVM_LOW +UVM_TESTNAME=test_nan +ntb_random_seed=11;
./salida +UVM_VERBOSITY=UVM_LOW +UVM_TESTNAME=test_nan +ntb_random_seed=12;
######### Between test ############################################################
./salida +UVM_VERBOSITY=UVM_LOW +UVM_TESTNAME=test_between +ntb_random_seed=13;
./salida +UVM_VERBOSITY=UVM_LOW +UVM_TESTNAME=test_between +ntb_random_seed=14;
./salida +UVM_VERBOSITY=UVM_LOW +UVM_TESTNAME=test_between +ntb_random_seed=15;

./salida -cm line+tgl+cond+fsm+branch+assert;
#dve -full64 -covdir salida.vdb &
Verdi -cov -covdir salida.vdb;
