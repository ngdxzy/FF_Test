set origin_dir "."
if { [info exists ::origin_dir_loc] } {
  set origin_dir $::origin_dir_loc
}

set _xil_proj_name_ FF_Test
if { [info exists ::user_project_name] } {
  set _xil_proj_name_ $::user_project_name
}
variable script_file
set script_file "create_prj.tcl"
set orig_proj_dir "[file normalize "$origin_dir/../Work"]"
create_project FF_Test ../Work
if {[string equal [get_filesets -quiet sources_1] ""]} {
  create_fileset -srcset sources_1
}
set obj [get_filesets sources_1]
set_property IP_REPO_PATHS ./../Src/IPs [current_project]
update_ip_catalog
