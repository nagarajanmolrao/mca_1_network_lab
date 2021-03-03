set ns [new Simulator]

set nf [open pB_2.nam w]
$ns namtrace-all $nf
set tf [open pB_2.tr w]
$ns trace-all $tf

proc finish { } {
global ns tf nf
$ns flush-trace
close $nf
close $tf
exec nam pB_2.nam &
exit 0
}

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]

$ns duplex-link $n0 $n2 10Mb 1ms DropTail
$ns duplex-link $n1 $n2 10Mb 1ms DropTail
$ns duplex-link $n2 $n3 10Mb 1ms DropTail

set tcp0 [new Agent/TCP]
$ns attach-agent $n0 $tcp0

set udp0 [new Agent/UDP]
$ns attach-agent $n1 $udp0

set null0 [new Agent/Null]
$ns attach-agent $n3 $null0

set sink0 [new Agent/TCPSink]
$ns attach-agent $n3 $sink0

set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0

set cbr1 [new Application/Traffic/CBR]
$cbr1 attach-agent $udp0
$ns connect $tcp0 $sink0
$ns connect $udp0 $null0
$ns at 0.1 "$cbr1 start"
$ns at 0.2 "$ftp0 start"
$ns at 0.5 "finish"

$ns run
