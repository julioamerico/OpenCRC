quietly set ACTELLIBNAME SmartFusion
quietly set PROJECT_DIR "E:/Julio/Projetos/IPs/CRC/src/SoC/crc_ahb_ip"
source "${PROJECT_DIR}/simulation/CompileDssBfm.tcl";source "${PROJECT_DIR}/simulation/bfmtovec_compile.tcl";

if {[file exists presynth/_info]} {
   echo "INFO: Simulation library presynth already exists"
} else {
   file delete -force presynth 
   vlib presynth
}
vmap presynth presynth
vmap smartfusion "C:/Microsemi/Libero_v11.6/Designer/lib/modelsim/precompiled/vlog/smartfusion"
vmap MSS_BFM_LIB "../component/Actel/SmartFusionMSS/MSS/2.5.106/mti/user_verilog/MSS_BFM_LIB"
vcom -work MSS_BFM_LIB -force_refresh
vlog -work MSS_BFM_LIB -force_refresh
vmap COREAHBLITE_LIB "../component/Actel/DirectCore/CoreAHBLite/5.0.100/mti/user_vlog/COREAHBLITE_LIB"
vcom -work COREAHBLITE_LIB -force_refresh
vlog -work COREAHBLITE_LIB -force_refresh

vlog -vlog01compat -work presynth "${PROJECT_DIR}/component/work/crc_ahb_ip_MSS/MSS_CCC_0/crc_ahb_ip_MSS_tmp_MSS_CCC_0_MSS_CCC.v"
vlog -vlog01compat -work presynth "${PROJECT_DIR}/component/work/crc_ahb_ip_MSS/crc_ahb_ip_MSS.v"
vlog -vlog01compat -work presynth "${PROJECT_DIR}/hdl/crc_control_unit.v"
vlog -vlog01compat -work presynth "${PROJECT_DIR}/hdl/bit_reversal.v"
vlog -vlog01compat -work presynth "${PROJECT_DIR}/hdl/crc_comb.v"
vlog -vlog01compat -work presynth "${PROJECT_DIR}/hdl/crc_parrallel.v"
vlog -vlog01compat -work presynth "${PROJECT_DIR}/hdl/crc_datapath.v"
vlog -vlog01compat -work presynth "${PROJECT_DIR}/hdl/crc_unit.v"
vlog -vlog01compat -work presynth "${PROJECT_DIR}/hdl/host_interface.v"
vlog -vlog01compat -work presynth "${PROJECT_DIR}/hdl/crc_ip.v"
vlog -vlog01compat -work COREAHBLITE_LIB "${PROJECT_DIR}/component/Actel/DirectCore/CoreAHBLite/5.0.100/rtl/vlog/core/coreahblite_addrdec.v"
vlog -vlog01compat -work COREAHBLITE_LIB "${PROJECT_DIR}/component/Actel/DirectCore/CoreAHBLite/5.0.100/rtl/vlog/core/coreahblite_defaultslavesm.v"
vlog -vlog01compat -work COREAHBLITE_LIB "${PROJECT_DIR}/component/Actel/DirectCore/CoreAHBLite/5.0.100/rtl/vlog/core/coreahblite_masterstage.v"
vlog -vlog01compat -work COREAHBLITE_LIB "${PROJECT_DIR}/component/Actel/DirectCore/CoreAHBLite/5.0.100/rtl/vlog/core/coreahblite_slavearbiter.v"
vlog -vlog01compat -work COREAHBLITE_LIB "${PROJECT_DIR}/component/Actel/DirectCore/CoreAHBLite/5.0.100/rtl/vlog/core/coreahblite_slavestage.v"
vlog -vlog01compat -work COREAHBLITE_LIB "${PROJECT_DIR}/component/Actel/DirectCore/CoreAHBLite/5.0.100/rtl/vlog/core/coreahblite_matrix4x16.v"
vlog -vlog01compat -work COREAHBLITE_LIB "${PROJECT_DIR}/component/Actel/DirectCore/CoreAHBLite/5.0.100/rtl/vlog/core/coreahblite.v"
vlog -vlog01compat -work presynth "${PROJECT_DIR}/component/work/crc_ahb_ip/crc_ahb_ip.v"
vlog "+incdir+${PROJECT_DIR}/stimulus" -vlog01compat -work presynth "${PROJECT_DIR}/stimulus/teste.v"

vsim -L smartfusion -L presynth -L MSS_BFM_LIB -L COREAHBLITE_LIB  -t 1ps presynth.teste
add wave /teste/*
add log -r /*
vcd file power.vcd
vcd add -r /teste/CRC_IP/*
run 1000ns
vcd flush
echo "VCD file power.vcd was successfully exported under the project simulation/ directory"
