set ns [new Simulator]
set tf [open 3.tr w]
$ns trace-all $tf
set nf [open 3.nam w]
$ns namtrace-all $nf
set cwind [open win3.tr w] $ns rtproto DV
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
$ns duplex-link $n0 $n1 1Mb 10ms DropTail $ns duplex-link $n1 $n4 1Mb 10ms DropTail $ns duplex-link $n4 $n5 1Mb 10ms DropTail $ns duplex-link $n5 $n3 1Mb 10ms DropTail $ns duplex-link $n3 $n2 1Mb 10ms DropTail $ns duplex-link $n2 $n0 1Mb 10ms DropTail $ns queue-limit $n1 $n4 10
$ns queue-limit $n2 $n3 10
set tcp0 [new Agent/TCP]
$ns attach-agent $n0 $tcp0
set sink0 [new Agent/TCPSink] $ns attach-agent $n4 $sink0 $ns connect $tcp0 $sink0
set ftp0 [new Application/FTP] $ftp0 attach-agent $tcp0
$tcp0 set fid_ 1
$ns rtmodel-at 1.0 down $n1 $n4 $ns rtmodel-at 3.0 up $n1 $n4
 
$ns at 0.1 "$ftp0 start"
proc plotWindow {tcpSource file} {
global ns
set time 0.01
set now [$ns now]
set cwnd [$tcpSource set cwnd_]
puts $file "$now $cwnd"
$ns at [expr $now+$time] "plotWindow $tcpSource $file" } $ns at 1.0 "plotWindow $tcp0 $cwind"
proc finish {} {
global ns tf nf cwind
$ns flush-trace
close $tf
close $nf
puts "running nam..."
exec xgraph win3.tr &
exec nam 3.nam &
exit 0
}
$ns at 12.0 "finish"
$ns run
