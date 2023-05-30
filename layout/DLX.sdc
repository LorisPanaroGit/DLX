###################################################################

# Created by write_sdc on Sat Jul  9 16:15:28 2022

###################################################################
set sdc_version 1.9

set_units -time ns -resistance MOhm -capacitance fF -voltage V -current mA
create_clock [get_ports Clk]  -period 1.5  -waveform {0 0.75}
