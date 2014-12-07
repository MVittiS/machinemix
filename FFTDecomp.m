function blocks=FFTDecomp(music,blockSize)
	mLen=max(size(music));
	nBlocks=ceil(2*mLen/blockSize)-1;
	blocks=cell(1,nBlocks);
	
	offset=(nBlocks*blockSize)-mLen;
	if(offset>0)
		music=[music zeros(1,offset)];
	end
	
	wind=sin((pi/(2*blockSize)):(pi/blockSize):(pi-(pi/(2*blockSize))));
	
	for x=1:nBlocks
		lb=1+(x-1)*(blockSize/2);
		ub=lb+blockSize-1;
		blocky=mdct(music(lb:ub).*wind);
		blocks{x}=blocky;
	end
end
