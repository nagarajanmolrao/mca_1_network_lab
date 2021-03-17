set ns [new Simulator -multicast on];

set trace [open pB_4.tr w]
$ns trace-all $trace

set namtrace [open pB_4.nam w]
$ns namtrace-all $namtrace

set group [Node allocaddr];

set n0 [$ns node];
set n1 [$ns node]
set n2 [$ns node]

$ns duplex-link $n0 $n1 1.5Mb 10ms DropTail
$ns duplex-link $n0 $n2 1.5Mb 10ms DropTail

set mproto DM;
set mrthandle [$ns mrtproto $mproto];

set udp [new Agent/UDP]
$ns attach-agent $n0 $udp

set src [ new Application/Traffic/CBR]
$src attach-agent $udp

$udp set dst_addr_ $group
$udp set dst_port_ 0

set rcvr1 [new Agent/LossMonitor]
$ns attach-agent $n1 $rcvr1

set rcvr2 [new Agent/LossMonitor]
$ns attach-agent $n2 $rcvr2

$ns at 0.3 "$n2 join-group $rcvr2 $group"
$ns at 2.0 "$src start"
$ns at 3.3 "$n2 leave-group $rcvr2 $group"
$ns at 5.0 "$src stop"

proc finish { } {
global ns namtrace trace
$ns flush-trace
close $namtrace
close $trace
exec nam pB_4.nam &
exit 0
}

$ns at 10.0 "finish"
$ns run

