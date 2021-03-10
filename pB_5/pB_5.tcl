set ns [new Simulator]

set nf [open pB_5.nam w]
$ns namtrace-all $nf

set nt [open pB_5.tr w]
$ns trace-all $nt

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]

$ns duplex-link $n0 $n2 1Mb 10ms DropTail
$ns duplex-link $n1 $n2 1Mb 10ms DropTail
$ns duplex-link $n2 $n3 1Mb 10ms DropTail

$ns queue-limit $n0 $n2 50
$ns queue-limit $n1 $n2 50
$ns queue-limit $n2 $n3 50

set tcp0 [new Agent/TCP]
$ns attach-agent $n0 $tcp0

set sink0 [new Agent/TCPSink]
$ns attach-agent $n3 $sink0

$ns connect $tcp0 $sink0

set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0
Agent/TCP set packetSize_ 1000

set tcp1 [new Agent/TCP]
$ns attach-agent $n1 $tcp1

set sink1 [new Agent/TCPSink]
$ns attach-agent $n3 $sink1

$ns connect $tcp1 $sink1

set telnet0 [new Application/Telnet]
$telnet0 set interval_ 0.005
$telnet0 attach-agent $tcp1

proc finish { } {
global ns nf nt
$ns flush-trace
close $nf
close $nt
exec nam pB_5.nam &
exec awk -f pB_5.awk pB_5.tr &
exit 0
}

$ns at 0.5 "$telnet0 start"
$ns at 0.75 "$ftp0 start"
$ns at 4.5 "$telnet0 stop"
$ns at 4.75 "$ftp0 stop"
$ns at 5.0 "finish"
$ns run
