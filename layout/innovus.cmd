#######################################################
#                                                     
#  Innovus Command Logging File                     
#  Created on Sat Jul  9 16:20:19 2022                
#                                                     
#######################################################

#@(#)CDS: Innovus v17.11-s080_1 (64bit) 08/04/2017 11:13 (Linux 2.6.18-194.el5)
#@(#)CDS: NanoRoute 17.11-s080_1 NR170721-2155/17_11-UB (database version 2.30, 390.7.1) {superthreading v1.44}
#@(#)CDS: AAE 17.11-s034 (64bit) 08/04/2017 (Linux 2.6.18-194.el5)
#@(#)CDS: CTE 17.11-s053_1 () Aug  1 2017 23:31:41 ( )
#@(#)CDS: SYNTECH 17.11-s012_1 () Jul 21 2017 02:29:12 ( )
#@(#)CDS: CPE v17.11-s095
#@(#)CDS: IQRC/TQRC 16.1.1-s215 (64bit) Thu Jul  6 20:18:10 PDT 2017 (Linux 2.6.18-194.el5)

set_global _enable_mmmc_by_default_flow      $CTE::mmmc_default
suppressMessage ENCEXT-2799
getDrawView
loadWorkspace -name Physical
win
set defHierChar /
set delaycal_input_transition_delay 0.1ps
set fpIsMaxIoHeight 0
set init_gnd_net gnd
set init_mmmc_file Default.view
set init_oa_search_lib {}
set init_pwr_net vdd
set init_verilog DLX_netlist_verilog.v
set init_lef_file /software/dk/nangate45/lef/NangateOpenCellLibrary.lef
init_design
init_design
init_design
init_design
getIoFlowFlag
setIoFlowFlag 0
floorPlan -coreMarginsBy die -site FreePDK45_38x28_10R_NP_162NW_34O -r 1.0 0.6 5 5 5 5
uiSetTool select
getIoFlowFlag
fit
set sprCreateIeRingOffset 1.0
set sprCreateIeRingThreshold 1.0
set sprCreateIeRingJogDistance 1.0
set sprCreateIeRingLayers {}
set sprCreateIeRingOffset 1.0
set sprCreateIeRingThreshold 1.0
set sprCreateIeRingJogDistance 1.0
set sprCreateIeRingLayers {}
set sprCreateIeStripeWidth 10.0
set sprCreateIeStripeThreshold 1.0
set sprCreateIeStripeWidth 10.0
set sprCreateIeStripeThreshold 1.0
set sprCreateIeRingOffset 1.0
set sprCreateIeRingThreshold 1.0
set sprCreateIeRingJogDistance 1.0
set sprCreateIeRingLayers {}
set sprCreateIeStripeWidth 10.0
set sprCreateIeStripeThreshold 1.0
setAddRingMode -ring_target default -extend_over_row 0 -ignore_rows 0 -avoid_short 0 -skip_crossing_trunks none -stacked_via_top_layer metal10 -stacked_via_bottom_layer metal1 -via_using_exact_crossover_size 1 -orthogonal_only true -skip_via_on_pin {  standardcell } -skip_via_on_wire_shape {  noshape }
addRing -nets {gnd vdd} -type core_rings -follow core -layer {top metal9 bottom metal9 left metal10 right metal10} -width {top 0.8 bottom 0.8 left 0.8 right 0.8} -spacing {top 0.8 bottom 0.8 left 0.8 right 0.8} -offset {top 1.8 bottom 1.8 left 1.8 right 1.8} -center 1 -extend_corner {} -threshold 0 -jog_distance 0 -snap_wire_center_to_grid None
set sprCreateIeRingOffset 1.0
set sprCreateIeRingThreshold 1.0
set sprCreateIeRingJogDistance 1.0
set sprCreateIeRingLayers {}
set sprCreateIeRingOffset 1.0
set sprCreateIeRingThreshold 1.0
set sprCreateIeRingJogDistance 1.0
set sprCreateIeRingLayers {}
set sprCreateIeStripeWidth 10.0
set sprCreateIeStripeThreshold 1.0
set sprCreateIeStripeWidth 10.0
set sprCreateIeStripeThreshold 1.0
set sprCreateIeRingOffset 1.0
set sprCreateIeRingThreshold 1.0
set sprCreateIeRingJogDistance 1.0
set sprCreateIeRingLayers {}
set sprCreateIeStripeWidth 10.0
set sprCreateIeStripeThreshold 1.0
setAddStripeMode -ignore_block_check false -break_at none -route_over_rows_only false -rows_without_stripes_only false -extend_to_closest_target none -stop_at_last_wire_for_area false -partial_set_thru_domain false -ignore_nondefault_domains false -trim_antenna_back_to_shape none -spacing_type edge_to_edge -spacing_from_block 0 -stripe_min_length 0 -stacked_via_top_layer metal10 -stacked_via_bottom_layer metal1 -via_using_exact_crossover_size false -split_vias false -orthogonal_only true -allow_jog { padcore_ring  block_ring }
addStripe -nets {gnd vdd} -layer metal10 -direction vertical -width 0.8 -spacing 0.8 -set_to_set_distance 20 -start_from left -start_offset 15 -switch_layer_over_obs false -max_same_layer_jog_length 2 -padcore_ring_top_layer_limit metal10 -padcore_ring_bottom_layer_limit metal1 -block_ring_top_layer_limit metal10 -block_ring_bottom_layer_limit metal1 -use_wire_group 0 -snap_wire_center_to_grid None -skip_via_on_pin {  standardcell } -skip_via_on_wire_shape {  noshape }
setSrouteMode -viaConnectToShape { noshape }
sroute -connect { blockPin padPin padRing corePin floatingStripe } -layerChangeRange { metal1(1) metal10(10) } -blockPinTarget { nearestTarget } -padPinPortConnect { allPort oneGeom } -padPinTarget { nearestTarget } -corePinTarget { firstAfterRowEnd } -floatingStripeTarget { blockring padring ring stripe ringpin blockpin followpin } -allowJogging 1 -crossoverViaLayerRange { metal1(1) metal10(10) } -nets { gnd vdd } -allowLayerChange 1 -blockPin useLef -targetViaLayerRange { metal1(1) metal10(10) }
setPlaceMode -prerouteAsObs {1 2 3 4 5 6 7 8}
setPlaceMode -fp false
placeDesign
getPinAssignMode -pinEditInBatch -quiet
setPinAssignMode -pinEditInBatch true
editPin -fixOverlap 1 -spreadDirection clockwise -side Right -layer 1 -spreadType side -pin {{addr_IRAM[0]} {addr_IRAM[1]} {addr_IRAM[2]} {addr_IRAM[3]} {addr_IRAM[4]} {addr_IRAM[5]} {addr_IRAM[6]} {addr_IRAM[7]} {addr_IRAM[8]} {addr_IRAM[9]} {addr_IRAM[10]} {addr_IRAM[11]} {addr_IRAM[12]} {addr_IRAM[13]} {addr_IRAM[14]} {addr_IRAM[15]} {addr_IRAM[16]} {addr_IRAM[17]} {addr_IRAM[18]} {addr_IRAM[19]} {addr_IRAM[20]} {addr_IRAM[21]} {addr_IRAM[22]} {addr_IRAM[23]} {addr_IRAM[24]} {addr_IRAM[25]} {addr_IRAM[26]} {addr_IRAM[27]} {addr_IRAM[28]} {addr_IRAM[29]} {addr_IRAM[30]} {addr_IRAM[31]}}
setPinAssignMode -pinEditInBatch true
editPin -fixOverlap 1 -spreadDirection clockwise -side Right -layer 1 -spreadType side -pin {{addr_mem[0]} {addr_mem[1]} {addr_mem[2]} {addr_mem[3]} {addr_mem[4]} {addr_mem[5]} {addr_mem[6]} {addr_mem[7]} {addr_mem[8]} {addr_mem[9]} {addr_mem[10]} {addr_mem[11]} {addr_mem[12]} {addr_mem[13]} {addr_mem[14]} {addr_mem[15]} {addr_mem[16]} {addr_mem[17]} {addr_mem[18]} {addr_mem[19]} {addr_mem[20]} {addr_mem[21]} {addr_mem[22]} {addr_mem[23]} {addr_mem[24]} {addr_mem[25]} {addr_mem[26]} {addr_mem[27]} {addr_mem[28]} {addr_mem[29]} {addr_mem[30]} {addr_mem[31]}}
setPinAssignMode -pinEditInBatch true
editPin -fixOverlap 1 -spreadDirection clockwise -side Top -layer 1 -spreadType side -pin {{datain_mem[0]} {datain_mem[1]} {datain_mem[2]} {datain_mem[3]} {datain_mem[4]} {datain_mem[5]} {datain_mem[6]} {datain_mem[7]} {datain_mem[8]} {datain_mem[9]} {datain_mem[10]} {datain_mem[11]} {datain_mem[12]} {datain_mem[13]} {datain_mem[14]} {datain_mem[15]} {datain_mem[16]} {datain_mem[17]} {datain_mem[18]} {datain_mem[19]} {datain_mem[20]} {datain_mem[21]} {datain_mem[22]} {datain_mem[23]} {datain_mem[24]} {datain_mem[25]} {datain_mem[26]} {datain_mem[27]} {datain_mem[28]} {datain_mem[29]} {datain_mem[30]} {datain_mem[31]}}
setPinAssignMode -pinEditInBatch true
editPin -fixOverlap 1 -spreadDirection clockwise -side Left -layer 1 -spreadType side -pin {{dataout_from_mem[0]} {dataout_from_mem[1]} {dataout_from_mem[2]} {dataout_from_mem[3]} {dataout_from_mem[4]} {dataout_from_mem[5]} {dataout_from_mem[6]} {dataout_from_mem[7]} {dataout_from_mem[8]} {dataout_from_mem[9]} {dataout_from_mem[10]} {dataout_from_mem[11]} {dataout_from_mem[12]} {dataout_from_mem[13]} {dataout_from_mem[14]} {dataout_from_mem[15]} {dataout_from_mem[16]} {dataout_from_mem[17]} {dataout_from_mem[18]} {dataout_from_mem[19]} {dataout_from_mem[20]} {dataout_from_mem[21]} {dataout_from_mem[22]} {dataout_from_mem[23]} {dataout_from_mem[24]} {dataout_from_mem[25]} {dataout_from_mem[26]} {dataout_from_mem[27]} {dataout_from_mem[28]} {dataout_from_mem[29]} {dataout_from_mem[30]} {dataout_from_mem[31]}}
setPinAssignMode -pinEditInBatch true
editPin -fixOverlap 1 -spreadDirection clockwise -side Top -layer 1 -spreadType side -pin {{dlx_data_out[0]} {dlx_data_out[1]} {dlx_data_out[2]} {dlx_data_out[3]} {dlx_data_out[4]} {dlx_data_out[5]} {dlx_data_out[6]} {dlx_data_out[7]} {dlx_data_out[8]} {dlx_data_out[9]} {dlx_data_out[10]} {dlx_data_out[11]} {dlx_data_out[12]} {dlx_data_out[13]} {dlx_data_out[14]} {dlx_data_out[15]} {dlx_data_out[16]} {dlx_data_out[17]} {dlx_data_out[18]} {dlx_data_out[19]} {dlx_data_out[20]} {dlx_data_out[21]} {dlx_data_out[22]} {dlx_data_out[23]} {dlx_data_out[24]} {dlx_data_out[25]} {dlx_data_out[26]} {dlx_data_out[27]} {dlx_data_out[28]} {dlx_data_out[29]} {dlx_data_out[30]} {dlx_data_out[31]}}
setPinAssignMode -pinEditInBatch true
editPin -fixOverlap 1 -spreadDirection clockwise -side Left -layer 1 -spreadType side -pin {{dout_IRAM[0]} {dout_IRAM[1]} {dout_IRAM[2]} {dout_IRAM[3]} {dout_IRAM[4]} {dout_IRAM[5]} {dout_IRAM[6]} {dout_IRAM[7]} {dout_IRAM[8]} {dout_IRAM[9]} {dout_IRAM[10]} {dout_IRAM[11]} {dout_IRAM[12]} {dout_IRAM[13]} {dout_IRAM[14]} {dout_IRAM[15]} {dout_IRAM[16]} {dout_IRAM[17]} {dout_IRAM[18]} {dout_IRAM[19]} {dout_IRAM[20]} {dout_IRAM[21]} {dout_IRAM[22]} {dout_IRAM[23]} {dout_IRAM[24]} {dout_IRAM[25]} {dout_IRAM[26]} {dout_IRAM[27]} {dout_IRAM[28]} {dout_IRAM[29]} {dout_IRAM[30]} {dout_IRAM[31]}}
setPinAssignMode -pinEditInBatch true
editPin -fixOverlap 1 -unit MICRON -spreadDirection clockwise -side Bottom -layer 1 -spreadType center -spacing 0.14 -pin Clk
setPinAssignMode -pinEditInBatch true
editPin -fixOverlap 1 -unit MICRON -spreadDirection clockwise -side Bottom -layer 2 -spreadType center -spacing 0.14 -pin MEM_EN_MEM
setPinAssignMode -pinEditInBatch true
editPin -use TIELOW -fixOverlap 1 -unit MICRON -spreadDirection clockwise -side Bottom -layer 1 -spreadType center -spacing 0.14 -pin RD_MEM
setPinAssignMode -pinEditInBatch true
editPin -fixOverlap 1 -unit MICRON -spreadDirection clockwise -side Bottom -layer 1 -spreadType center -spacing 0.14 -pin Rst
setPinAssignMode -pinEditInBatch true
editPin -use TIELOW -fixOverlap 1 -unit MICRON -spreadDirection clockwise -side Bottom -layer 1 -spreadType center -spacing 0.14 -pin WR_MEM
setPinAssignMode -pinEditInBatch true
editPin -use TIELOW -pinWidth 0.07 -pinDepth 0.07 -fixOverlap 1 -unit MICRON -spreadDirection clockwise -side Bottom -layer 1 -spreadType center -spacing 0.14 -pin WR_MEM
setPinAssignMode -pinEditInBatch false
setOptMode -fixCap true -fixTran true -fixFanoutLoad false
optDesign -postCTS
optDesign -postCTS -hold
getFillerMode -quiet
addFiller -cell FILLCELL_X8 FILLCELL_X4 FILLCELL_X32 FILLCELL_X2 FILLCELL_X16 FILLCELL_X1 -prefix FILLER
setNanoRouteMode -quiet -timingEngine {}
setNanoRouteMode -quiet -routeWithSiPostRouteFix 0
setNanoRouteMode -quiet -drouteStartIteration default
setNanoRouteMode -quiet -routeTopRoutingLayer default
setNanoRouteMode -quiet -routeBottomRoutingLayer default
setNanoRouteMode -quiet -drouteEndIteration default
setNanoRouteMode -quiet -routeWithTimingDriven false
setNanoRouteMode -quiet -routeWithSiDriven false
routeDesign -globalDetail
setAnalysisMode -analysisType onChipVariation
setOptMode -fixCap true -fixTran true -fixFanoutLoad false
optDesign -postRoute
optDesign -postRoute -hold
saveDesign DLX_routed
win
set_analysis_view -setup {default} -hold {default}
reset_parasitics
extractRC
redirect -quiet {set honorDomain [getAnalysisMode -honorClockDomains]} > /dev/null
timeDesign -postRoute -pathReports -drvReports -slackReports -numPaths 50 -prefix DLX_nbit32_postRoute -outDir timingReports
redirect -quiet {set honorDomain [getAnalysisMode -honorClockDomains]} > /dev/null
timeDesign -postRoute -hold -pathReports -slackReports -numPaths 50 -prefix DLX_nbit32_postRoute -outDir timingReports
get_time_unit
report_timing -machine_readable -max_paths 10000 -max_slack 0.75 -path_exceptions all > top.mtarpt
load_timing_debug_report -name default_report top.mtarpt
verifyConnectivity -type all -error 1000 -warning 50
setVerifyGeometryMode -area { 0 0 0 0 } -minWidth true -minSpacing true -minArea true -sameNet true -short true -overlap true -offRGrid false -offMGrid true -mergedMGridCheck true -minHole true -implantCheck true -minimumCut true -minStep true -viaEnclosure true -antenna false -insuffMetalOverlap true -pinInBlkg false -diffCellViol true -sameCellViol false -padFillerCellsOverlap true -routingBlkgPinOverlap true -routingCellBlkgOverlap true -regRoutingOnly false -stackedViasOnRegNet false -wireExt true -useNonDefaultSpacing false -maxWidth true -maxNonPrefLength -1 -error 1000
verifyGeometry
setVerifyGeometryMode -area { 0 0 0 0 }
reportGateCount -level 5 -limit 100 -outfile DLX_nbit32.gateCount
saveNetlist DLX_nbit32.v
all_hold_analysis_views 
all_setup_analysis_views 
write_sdf  -ideal_clock_network DLX_nbit32.sdf
