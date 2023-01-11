002.tcl
#Setting the Default Parameters
set val(chan) Channel/WirelessChannel set val(prop) Propagation/TwoRayGround set val(netif) Phy/WirelessPhy
set val(mac) Mac/802_11
#set val(ifq) CMUPriQueue
set val(ifq) Queue/DropTail/PriQueue set val(ll) LL
set val(ant) Antenna/OmniAntenna set val(x) 500
 
 set val(y) 400
set val(ifqlen) 50 set val(nn) 3
set val(stop) 60.0
set val(rp) AODV
set ns_ [new Simulator]
set tracefd [open 002.tr w] $ns_ trace-all $tracefd
set namtrace [open 002.nam w]
$ns_ namtrace-all-wireless $namtrace $val(x) $val(y)
set prop [new $val(prop)]
set topo [new Topography]
$topo load_flatgrid $val(x) $val(y)
create-god $val(nn) #Node Configuration
$ns_ node-config -adhocRouting $val(rp) \ -llType $val(ll) \
-macType $val(mac) \ -ifqType $val(ifq) \ -ifqLen $val(ifqlen) \ -antType $val(ant) \ -propType $val(prop) \
-phyType $val(netif) \ -channelType $val(chan) \
-topoInstance $topo \ -agentTrace ON \ -routerTrace ON \ -macTrace ON
#Creating Nodes
for {set i 0} {$i < $val(nn) } {incr i} {
set node_($i) [$ns_ node]
$node_($i) random-motion 0 }
#Initial Positions of Nodes $node_(0) set x_ 5.0 $node_(0) set y_ 5.0

 $node_(0) set z_ 0.0
$node_(1) set x_ 490.0 $node_(1) set y_ 285.0 $node_(1) set z_ 0.0
$node_(2) set x_ 150.0 $node_(2) set y_ 240.0 $node_(2) set z_ 0.0
for {set i 0} {$i < $val(nn)} {incr i} {
$ns_ initial_node_pos $node_($i) 40
}
#Topology Design
$ns_ at 0.0 "$node_(0) setdest 450.0 285.0 30.0" $ns_ at 0.0 "$node_(1) setdest 200.0 285.0 30.0" $ns_ at 0.0 "$node_(2) setdest 1.0 285.0 30.0"
$ns_ at 25.0 "$node_(0) setdest 300.0 285.0 10.0" $ns_ at 25.0 "$node_(2) setdest 100.0 285.0 10.0"
$ns_ at 40.0 "$node_(0) setdest 490.0 285.0 5.0" $ns_ at 40.0 "$node_(2) setdest 1.0 285.0 5.0"
#Generating Traffic
set tcp0 [new Agent/TCP]
set sink0 [new Agent/TCPSink] $ns_ attach-agent $node_(0) $tcp0 $ns_ attach-agent $node_(2) $sink0 $ns_ connect $tcp0 $sink0
set ftp0 [new Application/FTP] $ftp0 attach-agent $tcp0
$ns_ at 10.0 "$ftp0 start"
#Simulation Termination
for {set i 0} {$i < $val(nn) } {incr i} { $ns_ at $val(stop) "$node_($i) reset";
}
$ns_ at $val(stop) "puts \"NS EXITING...\" ; $ns_ halt"

puts "Starting Simulation..." $ns_ run
