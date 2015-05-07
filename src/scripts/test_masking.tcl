
set datapath_type {
	"CASCATED"
	"PARALLEL"
	"FIXED"
}

set crc_size {
	2
	4
	8
	16
	32
}
set_option -max_parallel_jobs 3

list result_area
list result_timing

foreach dp_type $datapath_type {
 set_option -hdl_param -set $dp_type
 foreach size $crc_size {
  set_option -hdl_param -set CRC_SIZE $size
  project -run
  lappend result_area [regexp -inline -linestop {[0-9]+} [status_report -name area_report]]
  lappend result_timing [regexp -inline {[0-9]+} [status_report -name timing_report -parameter est_freq]]
 }
}


puts $result_area
puts $result_timing
puts "End of Synthesis"