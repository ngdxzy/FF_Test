# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "DELAY_ELEMENTS" -parent ${Page_0}
  ipgui::add_param $IPINST -name "MODE" -parent ${Page_0} -widget comboBox
  ipgui::add_param $IPINST -name "REFCLK_FREQUENCY" -parent ${Page_0}
  ipgui::add_param $IPINST -name "S_AXI_ADDR_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "S_AXI_DATA_WIDTH" -parent ${Page_0}

  ipgui::add_param $IPINST -name "NATIVE_ADDR_WDITH"
  ipgui::add_param $IPINST -name "VTC" -widget comboBox

}

proc update_PARAM_VALUE.DELAY_ELEMENTS { PARAM_VALUE.DELAY_ELEMENTS } {
	# Procedure called to update DELAY_ELEMENTS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DELAY_ELEMENTS { PARAM_VALUE.DELAY_ELEMENTS } {
	# Procedure called to validate DELAY_ELEMENTS
	return true
}

proc update_PARAM_VALUE.MODE { PARAM_VALUE.MODE } {
	# Procedure called to update MODE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MODE { PARAM_VALUE.MODE } {
	# Procedure called to validate MODE
	return true
}

proc update_PARAM_VALUE.NATIVE_ADDR_WDITH { PARAM_VALUE.NATIVE_ADDR_WDITH } {
	# Procedure called to update NATIVE_ADDR_WDITH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.NATIVE_ADDR_WDITH { PARAM_VALUE.NATIVE_ADDR_WDITH } {
	# Procedure called to validate NATIVE_ADDR_WDITH
	return true
}

proc update_PARAM_VALUE.NATIVE_DATA_WIDTH { PARAM_VALUE.NATIVE_DATA_WIDTH } {
	# Procedure called to update NATIVE_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.NATIVE_DATA_WIDTH { PARAM_VALUE.NATIVE_DATA_WIDTH } {
	# Procedure called to validate NATIVE_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.REFCLK_FREQUENCY { PARAM_VALUE.REFCLK_FREQUENCY } {
	# Procedure called to update REFCLK_FREQUENCY when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.REFCLK_FREQUENCY { PARAM_VALUE.REFCLK_FREQUENCY } {
	# Procedure called to validate REFCLK_FREQUENCY
	return true
}

proc update_PARAM_VALUE.S_AXI_ADDR_WIDTH { PARAM_VALUE.S_AXI_ADDR_WIDTH } {
	# Procedure called to update S_AXI_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.S_AXI_ADDR_WIDTH { PARAM_VALUE.S_AXI_ADDR_WIDTH } {
	# Procedure called to validate S_AXI_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.S_AXI_DATA_WIDTH { PARAM_VALUE.S_AXI_DATA_WIDTH } {
	# Procedure called to update S_AXI_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.S_AXI_DATA_WIDTH { PARAM_VALUE.S_AXI_DATA_WIDTH } {
	# Procedure called to validate S_AXI_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.VTC { PARAM_VALUE.VTC } {
	# Procedure called to update VTC when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.VTC { PARAM_VALUE.VTC } {
	# Procedure called to validate VTC
	return true
}


proc update_MODELPARAM_VALUE.S_AXI_DATA_WIDTH { MODELPARAM_VALUE.S_AXI_DATA_WIDTH PARAM_VALUE.S_AXI_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.S_AXI_DATA_WIDTH}] ${MODELPARAM_VALUE.S_AXI_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.REFCLK_FREQUENCY { MODELPARAM_VALUE.REFCLK_FREQUENCY PARAM_VALUE.REFCLK_FREQUENCY } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.REFCLK_FREQUENCY}] ${MODELPARAM_VALUE.REFCLK_FREQUENCY}
}

proc update_MODELPARAM_VALUE.MODE { MODELPARAM_VALUE.MODE PARAM_VALUE.MODE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MODE}] ${MODELPARAM_VALUE.MODE}
}

proc update_MODELPARAM_VALUE.DELAY_ELEMENTS { MODELPARAM_VALUE.DELAY_ELEMENTS PARAM_VALUE.DELAY_ELEMENTS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DELAY_ELEMENTS}] ${MODELPARAM_VALUE.DELAY_ELEMENTS}
}

proc update_MODELPARAM_VALUE.NATIVE_ADDR_WDITH { MODELPARAM_VALUE.NATIVE_ADDR_WDITH PARAM_VALUE.NATIVE_ADDR_WDITH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.NATIVE_ADDR_WDITH}] ${MODELPARAM_VALUE.NATIVE_ADDR_WDITH}
}

proc update_MODELPARAM_VALUE.NATIVE_DATA_WIDTH { MODELPARAM_VALUE.NATIVE_DATA_WIDTH PARAM_VALUE.NATIVE_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.NATIVE_DATA_WIDTH}] ${MODELPARAM_VALUE.NATIVE_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.S_AXI_ADDR_WIDTH { MODELPARAM_VALUE.S_AXI_ADDR_WIDTH PARAM_VALUE.S_AXI_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.S_AXI_ADDR_WIDTH}] ${MODELPARAM_VALUE.S_AXI_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.VTC { MODELPARAM_VALUE.VTC PARAM_VALUE.VTC } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.VTC}] ${MODELPARAM_VALUE.VTC}
}

