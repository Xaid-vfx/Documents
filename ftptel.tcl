set ns [new Simulator]
set nf [open 2.nam w]
set tf [open 2.tr w]
set cwind [open win2.tr w] $ns color 1 Blue
  
 $ns color 2 Red
$ns namtrace-all $nf
$ns trace-all $tf
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
$ns duplex-link $n0 $n2 2Mb 2ms DropTail
$ns duplex-link $n2 $n3 0.4Mb 5ms DropTail
$ns duplex-link $n1 $n2 2Mb 2ms DropTail
$ns duplex-link $n3 $n4 2Mb 2ms DropTail
$ns duplex-link $n3 $n5 2Mb 2ms DropTail
$ns queue-limit $n2 $n3 10
set tcp1 [new Agent/TCP]
set sink1 [new Agent/TCPSink]
set ftp1 [new Application/FTP]
$ns attach-agent $n0 $tcp1
$ns attach-agent $n5 $sink1
$ns connect $tcp1 $sink1
$ftp1 attach-agent $tcp1
$ns at 1.2 "$ftp1 start"
set tcp2 [new Agent/TCP]
set sink2 [new Agent/TCPSink]
set telnet1 [new Application/Telnet]
$ns attach-agent $n1 $tcp2
$ns attach-agent $n4 $sink2
$ns connect $tcp2 $sink2
$telnet1 attach-agent $tcp2
$ns at 5.1 "$telnet1 start"
$ns at 5.0 "$ftp1 stop"
$ns at 10.0 "finish"
proc plotWindow {tcpSource file} {
global ns
set time 0.01
set now [$ns now]
set cwnd [$tcpSource set cwnd_]
puts $file "$now $cwnd"
$ns at [expr $now+$time] "plotWindow $tcpSource $file" }
$ns at 2.0 "plotWindow $tcp1 $cwind"
$ns at 5.5 "plotWindow $tcp2 $cwind"

proc finish {} {
global ns tf nf cwind $ns flush-trace
close $tf
close $nf
#close $cwind
puts "running nam..." exec nam 2.nam & exec xgraph win2.tr & exit 0
}
$ns run
