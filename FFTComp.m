function music=FFTComp(blocks)
	blockSize=max(size(blocks{1}));
	mLen=(max(size(blocks))+2)*blockSize;
	music=zeros(1,mLen);
	
	wind=sin((pi/(4*blockSize)):(pi/(2*blockSize)):(pi-(pi/(4*blockSize))));
	
	for x=1:max(size(blocks))
		lb=1+(x-1)*(blockSize);
		ub=lb+(2*blockSize)-1;
		blocky=imdct(blocks{x}).*wind;
		music(lb:ub)=music(lb:ub)+blocky;
	end
end
