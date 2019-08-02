clc
clear
close all 

% Igor Martins Rocha
% Simulação de desvanecimento nakagami-m

m = 1;      % Controla o formato, quanto maior o m, menos severo o desvanecimento.
w = 1;      % Controla o espalhamento
snr = 20;

% --------- Plotar FDP --------------------------- %
x = 0:0.01:5;
f = (2*(m^m)*x.^(2*m-1).*exp((-m/w)*x.^2))/(gamma(m)*(w^m)); % FDP
plot (x,f)
axis([0 3 0 1.5])
title('Função Densidade de Probabilidade')

% --------- Distribuição Nakagami-m --------------%
fs = 100;                                   %Frequência do sinal
fa = 20*fs;                               %Frequência de amostragem
t = 0:1/fa:100;
y1 = sin (2*pi*fs*t);                       % Sinal de saída transmissor
y2 = awgn (y1, snr, 'measured');            % Sinal com ruído

pd = makedist('Nakagami','mu',m,'omega',w); % Gera distribuição nakagami-m
r = random(pd,length(t),1)';                % Gera variável aleatória com distribuição nakagami      

y3  = r.*y1;                                % Sinal com desvanecimento
y4 = awgn (y3, snr,'measured');             % Sinal com desvanecimento e ruído

% ---------- Constelação --------------------%
M = 4;
sym = 1000; % Numero de symbolos
data = randi([0 M-1],sym,1);  % Gera os simbolos
txSig = pskmod(data,M,pi/M);  % Modula o sinal

r = random (pd, sym,1);      % Gera variável aleatória nakagami-m

rxd = r.*txSig;                       % Adiciona desvanecimento
rxn = awgn (txSig, snr, 'measured');   % Adiciona ruído
rxdn = awgn(rxd, snr, 'measured');     % Ruído e desvanecimento

scatterplot(txSig)
title('Constelação pura')

scatterplot(rxn)
title('Constelação com ruído')

scatterplot(rxd)
title('Constelação com desvanecimento')

scatterplot(rxdn)
title('Constelação com ruído e desvanecimento')


% --------- Plotagem dos gráficos ---------- %
figure();
subplot (2,2,1)
plot (t,y1);
title('Sinal puro')
axis([0 5/fs -2 2])

subplot (2,2,2)
plot (t,y2);
title('Sinal com ruído')
axis([0 5/fs -2 2])

subplot (2,2,3)
plot (t,y3);
title('Sinal com desvanecimento')
axis([0 5/fs -2 2])

subplot(2,2,4)
plot (t,y4);
title('Sinal com desvanecimento e ruído')
axis([0 5/fs -2 2])
