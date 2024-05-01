## SimpleSend.xdc
## EE4490 
## modified from a previous version by Jerry Hamann
## XDC file for introductory GRB LED driver, assuming BASYS3
## with a Artix-7 FPGA (XC7A34T-1 CPG236C).
## Adapted from the Digilent-supplied file Basys3_Master.xdc

set_property ALLOW_COMBINATORIAL_LOOPS true [get_nets -of_objects [get_cells <cellname>]]

set_property SEVERITY {Warning}  [get_drc_checks LUTLP-1]

set_property SEVERITY {Warning} [get_drc_checks NSTD-1]

## Clock signal (Generated on-board the Artix-7) 10 ns period (100 MHz)
set_property PACKAGE_PIN W5 [get_ports clk]							
	set_property IOSTANDARD LVCMOS33 [get_ports clk]
	create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]

set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]

## Switches
# sw[0] for reset signal
set_property PACKAGE_PIN V17 [get_ports {reset}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {reset}]
set_property PACKAGE_PIN R2 [get_ports {Go}]					
    set_property IOSTANDARD LVCMOS33 [get_ports {Go}]
    
## Seven Segment LED controls
set_property PACKAGE_PIN W7 [get_ports {Leds[0]}]					
        set_property IOSTANDARD LVCMOS33 [get_ports {Leds[0]}]
set_property PACKAGE_PIN W6 [get_ports {Leds[1]}]                    
        set_property IOSTANDARD LVCMOS33 [get_ports {Leds[1]}]
set_property PACKAGE_PIN U8 [get_ports {Leds[2]}]                    
        set_property IOSTANDARD LVCMOS33 [get_ports {Leds[2]}]
set_property PACKAGE_PIN V8 [get_ports {Leds[3]}]                    
        set_property IOSTANDARD LVCMOS33 [get_ports {Leds[3]}]
set_property PACKAGE_PIN U5 [get_ports {Leds[4]}]                    
        set_property IOSTANDARD LVCMOS33 [get_ports {Leds[4]}]
set_property PACKAGE_PIN V5 [get_ports {Leds[5]}]                    
        set_property IOSTANDARD LVCMOS33 [get_ports {Leds[5]}]
set_property PACKAGE_PIN U7 [get_ports {Leds[6]}]                    
        set_property IOSTANDARD LVCMOS33 [get_ports {Leds[6]}]
       
## Anode selection controls
set_property PACKAGE_PIN U2 [get_ports {adrive[0]}]					
            set_property IOSTANDARD LVCMOS33 [get_ports {adrive[0]}]
set_property PACKAGE_PIN U4 [get_ports {adrive[1]}]                    
            set_property IOSTANDARD LVCMOS33 [get_ports {adrive[1]}]
set_property PACKAGE_PIN V4 [get_ports {adrive[2]}]                    
            set_property IOSTANDARD LVCMOS33 [get_ports {adrive[2]}]
set_property PACKAGE_PIN W4 [get_ports {adrive[3]}]                    
            set_property IOSTANDARD LVCMOS33 [get_ports {adrive[3]}]
    
set_property PACKAGE_PIN T18 [get_ports {up}]					
        set_property IOSTANDARD LVCMOS33 [get_ports {up}]
set_property PACKAGE_PIN U17 [get_ports {down}]                    
        set_property IOSTANDARD LVCMOS33 [get_ports {down}]
 
## LEDs
# led0, to signify when it's okay to press Go button
set_property PACKAGE_PIN U16 [get_ports {Ready2Go}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {Ready2Go}] 
	
#
###Pmod Header JA
##Sch name = JA1
# this is the data being sent to the LED strip
set_property PACKAGE_PIN J1 [get_ports {dataOut}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {dataOut}]
	
## End of file SimpleSend.xdc

