BEGIN{ count=0; Rcount=0;}
{
	if($1=="r" && $5=="tcp")
	{
		count=count+1;
		if($6 >= 1000)
		{
			Rcount=Rcount+1;
		}
	}
}
END{
	printf("Total Packets in Transmission: %d\n",count);
	printf("Recieved: %d\n",Rcount);
	printf("Loss: %d\n",count-Rcount);
}
