BEGIN{
	udp=0;
	tcp=0;
}
{
	if($1=="r" && $5=="cbr")
	{
		udp++;
	}
	else if($1=="r" && $5=="tcp")
	{
		tcp++;
	}
}
END{
	printf("Number of packets sent by TCP: %d\n",tcp);
	printf("Number of packets sent by UDP: %d\n",udp);
}
