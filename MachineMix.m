function saida=MachineMix(input,victimInput,output,bSize)
	mus=wavread(input);  % Primeiro, lemos o arquivo de som do sistema.
	if min(size(mus))>1
		mus=mean(mus');  % Depois, reduzimos o arquivo estéreo para mono, ao menos em primeira instância - fazer testes com Joint Stereo depois.
	else
		mus=mus';
	end
	
	vim=wavread(victimInput);  % Depois, lemos o arquivo de som da vítima.
	if min(size(vim))>1
		vim=mean(vim');  % Depois, reduzimos o arquivo estéreo para mono, ao menos em primeira instância - fazer testes com Joint Stereo depois.
	else
		vim=vim';
	end
						  
	
	blocos=FFTDecomp(mus,bSize);  % Decompomos o arquivo em blocos.
	vitima=FFTDecomp(vim,bSize);  % E, emintemente, a vítima também!
	disp('Arquivo decomposto em blocos!');
	
				 
	% Preditor linear simples, para efeito de comparação.
	
	nBlocos=max(size(blocos));
	mat=zeros(nBlocos-1,max(size(blocos{1}))+1);
	for x=1:nBlocos-1
		mat(x,1)=1;
		mat(x,2:end)=blocos{x};
	end
	disp('Resolvendo sistema preditor...');
	
	matsol=zeros(size(mat)-[0 1]);
	disp(size(mat));
	disp(size(matsol));
	matsol((1:end-1),:)=mat((2:end),(2:end));
	matsol(end,:)=blocos{nBlocos};
	coefs=(mat'*mat)\(mat'*matsol);
	
	disp('Sistema resolvido! Criando a música.');
	
	sint=cell(size(vitima));
	ssize=max(size(vitima{1}));
	sint{1}=zeros(size(vitima{1}));
	
	for x=2:max(size(vitima));
		%smod=sint{x-1}+0.001*exp(-0.1*(1:ssize)).*randn(ssize);
		%smod=sint{x-1}+0.0001*randn(ssize);
		vec=[1 vitima{x-1}];
		sint{x}=(vec*coefs);
	end

	disp('Música terminada! Sintetizando...');
	
	% == Aqui entra a magia das redes neurais, que retorna os novos blocos criados em uma cell "sint[]", de mesmo tamanho e número dos originais ==
	
	
                 
	saida=FFTComp(sint);
	saida=saida-mean(saida);
	%vol=sqrt(dot(saida,saida)./(2*ssize));
	%saida=saida./vol;
	saida=saida./(max(abs(saida)));
	
	wavwrite(saida',44100,16,output);
end
