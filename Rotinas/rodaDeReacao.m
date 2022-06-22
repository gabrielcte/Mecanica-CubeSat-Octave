%====================%
% Inicialização %
%====================%
clear all; close all; format longEng; clc
%====================%
% Definindo funções %
%====================%
%{Amperagem minima fornecida 0mA
%corrente Ociosa, minima de funcionamento sem rotação 9 mA
%correnteRotacaoMinima -> Amperagem para rotação de 1000 RPM 30 mA
%correntePicoReduzido -> Pico com corrente reduzida 300 mA
%correntePicoReal -> Pico real 650 mA
%A = Ao:1*10^-3:correntePicoReal; Vetor de correntes
%O ciclo de atuação ocorre com a mudança de corrente pois a tensão de
%trabalho é entre 4.75 a 5.25 V, valor normal de funcionamento de 5V
%}
function [fracaoDeTrabalho] = cicloDeTrabalho(correnteMinima,correnteOciosa,correnteRotacaoMinima,correntePicoReduzido,correntePicoReal)
  picoDeTrabalho = 1;
  contador=1;
  for corrente = correnteMinima:1*10^-3:correntePicoReal;
    if  corrente <= correnteOciosa && corrente >= correnteMinima
      fracaoDeTrabalho(contador) = 0;
    endif
    if  corrente <= correntePicoReduzido && corrente >= correnteRotacaoMinima
      cicloTrabalhoMinimo = 0.1;
      coeficienteAngular = (picoDeTrabalho-cicloTrabalhoMinimo)/(correntePicoReduzido-correnteRotacaoMinima);
      coeficienteLinear = picoDeTrabalho -(correntePicoReduzido*(coeficienteAngular));
      fracaoDeTrabalho(contador) = (coeficienteAngular).*corrente+(coeficienteLinear);
    endif
    if  corrente >= correntePicoReduzido
      fracaoDeTrabalho(contador) = 1;
    endif
    contador = contador+1;
  endfor
endfunction
%{
Modelo para Roda de Reação pelo WERTZ por Gabriel Alves Silva
m -> massa
R-> raio
I -> momento de inercia
rpm -> rotações por minuto
rotacoesPorMinutoRodaDeReacaoMaxima -> maior rotação atinginda pelo motor
N -> Torque Líquido
torqueEletromagnetico -> Torque eletromagnético
torqueAtritoRolamento -> Torque de atrito de rolamento
magnitudeMaximaTorqueEletromagnatico -> Magnitude Máxima
smax -> Velocidade de Sincronização
rpm -> Velocidade em RPM
coeficienteCoulomb -> Coeficiente de Coulomb
f -> Coeficiente de atrito viscoso
melhorTorqueEletromagneticoParaRazaoVelocidadeAtualEVelocidadeMaxima = r quando torqueEletromagnetico max
A->corrente
s=h/I h-> momento necessário.
%}
function torqueAplicadoPorVelocidadeRotacaoRodaDeReacao(coeficienteCoulomb,rotacoesPorMinutoRodaDeReacao,coeficienteAtritoViscoso,rotacoesPorMinutoRodaDeReacaoMaxima,magnitudeMaximaTorqueEletromagnatico,melhorTorqueEletromagneticoParaRazaoVelocidadeAtualEVelocidadeMaxima,tensao,fracaoDeTrabalhoAtual)
  razaoDiferencaVelocidadeAtualVelocidadeMaximaPorVelocidadeMaxima = 1 - rotacoesPorMinutoRodaDeReacao/rotacoesPorMinutoRodaDeReacaoMaxima;
  torqueAtritoRolamento = coeficienteCoulomb*sign(rotacoesPorMinutoRodaDeReacao)*coeficienteAtritoViscoso.*rotacoesPorMinutoRodaDeReacao;
  torqueEletromagnetico = 2.*magnitudeMaximaTorqueEletromagnatico.*melhorTorqueEletromagneticoParaRazaoVelocidadeAtualEVelocidadeMaxima.*razaoDiferencaVelocidadeAtualVelocidadeMaximaPorVelocidadeMaxima.*((melhorTorqueEletromagneticoParaRazaoVelocidadeAtualEVelocidadeMaxima.^2)+(razaoDiferencaVelocidadeAtualVelocidadeMaximaPorVelocidadeMaxima.^2)).^-1;
  torqueAplicado = sign(tensao).*fracaoDeTrabalhoAtual.*torqueEletromagnetico - torqueAtritoRolamento;
  figure
  hold on
  plot (rotacoesPorMinutoRodaDeReacao,torqueAplicado,'b')
  plot (rotacoesPorMinutoRodaDeReacao,torqueEletromagnetico,':b')
  plot (rotacoesPorMinutoRodaDeReacao,torqueAtritoRolamento,'--b')
  grid
  title('Modelo Wertz Tração Total de uma roda de reação')
  xlabel('Velocidade de rotação [rpm]')
  ylabel('Tração Total [N*m]')
  axis square
  hold off
endfunction
function [vetorTorqueAplicadoPolinomio] = polinomioTorqueAplicadoPorVelocidadeRotacaoRodaDeReacao(coeficienteCoulomb,rotacoesPorMinutoRodaDeReacao,coeficienteAtritoViscoso,rotacoesPorMinutoRodaDeReacaoMaxima,magnitudeMaximaTorqueEletromagnatico,melhorTorqueEletromagneticoParaRazaoVelocidadeAtualEVelocidadeMaxima,tensao,fracaoDeTrabalhoAtual)
  torqueAtritoRolamento = coeficienteCoulomb*coeficienteAtritoViscoso.*rotacoesPorMinutoRodaDeReacao;
  razaoDiferencaVelocidadeAtualVelocidadeMaximaPorVelocidadeMaxima = 1 - rotacoesPorMinutoRodaDeReacao/rotacoesPorMinutoRodaDeReacaoMaxima;
  torqueEletromagnetico = 2.*magnitudeMaximaTorqueEletromagnatico.*melhorTorqueEletromagneticoParaRazaoVelocidadeAtualEVelocidadeMaxima.*razaoDiferencaVelocidadeAtualVelocidadeMaximaPorVelocidadeMaxima.*((melhorTorqueEletromagneticoParaRazaoVelocidadeAtualEVelocidadeMaxima.^2)+(razaoDiferencaVelocidadeAtualVelocidadeMaximaPorVelocidadeMaxima.^2)).^-1;
  torqueAplicado = torqueEletromagnetico - torqueAtritoRolamento;
  polinomio = polyfit(rotacoesPorMinutoRodaDeReacao,torqueAplicado,3);
  vetorTorqueAplicadoPolinomio = polyval(polinomio,rotacoesPorMinutoRodaDeReacao);
endfunction
function [plantaSimbolica] = LaplaceSym(rotacoesPorMinutoRodaDeReacao,torqueAplicado)
  polinomio = polyfit(rotacoesPorMinutoRodaDeReacao,torqueAplicado,3);
  syms vetorTorqueAplicadoPolinomio rotacoesPorMinutoRodaDeReacao rotacaoRodaReacao
  vetorTorqueAplicadoPolinomio = poly2sym(polinomio,rotacoesPorMinutoRodaDeReacao);
  variavel = [rotacoesPorMinutoRodaDeReacao];
  plantaSimbolica = laplace(vetorTorqueAplicadoPolinomio,variavel,rotacaoRodaReacao);
endfunction
function TunningPID(numeradorPlantaAberta,denominadorPlantaAberta)
  t = 0:0.01:20;
  S = tf({[1,0]},{[0 1]});
  planta = tf(numeradorPlantaAberta,denominadorPlantaAberta); %malha aberta
  GF = (planta/(1+planta));
  %===========================Desenvolvimento Controlador====================
  i=1;
  for T = 15.5:0.1:16;
    for L = 0.1:0.1:1;
      Kp = 1.2*T/L;
      Ti = 2*L;
      Td = 0.5*L;
      Gc = tf([Kp*Ti*Td Kp*Ti Kp],[0 Td 0]); % controlador
      GC = Gc*planta/(1 + Gc*planta); % Função de transferência em malha fechada
      y = step(GC,t);
      m = max(y);
      if abs(m-1) <= 0.1
        TL(i,1) = T;
        TL(i,2) = L;
        TL(i,3) = Kp;
        TL(i,4) = Ti;
        TL(i,5) = Td;
        TL;
        i=i+1;
      endif
    endfor
  endfor
  %===========================Resposta ao degrau unitário====================
  figure
  step(GF,t,'b');
  grid on
  hold on
  step((GC),t,'r');
  title('Resposta ao degrau unitária do sistema compensado')
  xlabel('t (s)')
  ylabel('Entrada e saída degrau unitária')
  text(10.8,8,'Sistema compensado')
  hold off
  %===========================Resposta à rampa unitária======================
  figure
  plot(t,t,'--k')
  grid on
  hold on
  GFramp = step((GF/S),t);
  plot(t,GFramp,'b')
  GCramp = step((GC/S),t);
  plot(t,GCramp,'r')
  title('Resposta a rampa unitária do sistema compensado')
  xlabel('t (s)')
  ylabel('Entrada e saída em rampa unitária')
  text(10.8,8,'Sistema compensado')
  hold off
  %===========================Diagrama de BODE===============================
  figure
  bode(GF,'b',GC,'r')
  hold on
  grid on
  title('Diagrama de Bode')
  text(10.8,8,'Sistema compensado')
  hold off
endfunction
% Ciclo de Trabalho %
correnteMinima = 0;
correnteOciosa = 9 * 10^-3;
correnteRotacaoMinima = 30 * 10^-3;
correntePicoReduzido = 300 * 10^-3;
correntePicoReal = 650 * 10^-3;
corrente = correnteMinima:1*10^-3:correntePicoReal;
figure
fracaoDeTrabalho = cicloDeTrabalho(correnteMinima,correnteOciosa,correnteRotacaoMinima,correntePicoReduzido,correntePicoReal);
plot (corrente,fracaoDeTrabalho)
axis square
grid
title('Ciclo de Trabalho')
xlabel('Corrente A')
ylabel('Xdc')
% Modelo WERTZ Analítico %
massa = 0.137; % kg
raioRodaDeReacao = 43.5*10^-3; % m
momentoInerciaEixoAxial = (massa*raioRodaDeReacao^2)/2; % kg*m^2
rotacoesPorMinutoRodaDeReacao = 0:1:6500; %RPM;
rotacoesPorMinutoRodaDeReacaoMaxima = 6500; %RPM;
coeficienteCoulomb = 7.06*10^-4; %N*m
coeficienteAtritoViscoso = 0.00000455/9.54929; %N*m/RPM
magnitudeMaximaTorqueEletromagnatico = 0.03; %N*m
melhorTorqueEletromagneticoParaRazaoVelocidadeAtualEVelocidadeMaxima = 1-(rotacoesPorMinutoRodaDeReacaoMaxima/3)/rotacoesPorMinutoRodaDeReacaoMaxima; %
tensao = 5; % Retirado da datasheet
correnteAtual = 650 * 10^-3; %%% relacao torque corrente %%
localizaIndice = find(corrente == correnteAtual);
fracaoDeTrabalhoAtual = fracaoDeTrabalho(localizaIndice);
torqueAplicadoPorVelocidadeRotacaoRodaDeReacao(coeficienteCoulomb,rotacoesPorMinutoRodaDeReacao,coeficienteAtritoViscoso,rotacoesPorMinutoRodaDeReacaoMaxima,magnitudeMaximaTorqueEletromagnatico,melhorTorqueEletromagneticoParaRazaoVelocidadeAtualEVelocidadeMaxima,tensao,fracaoDeTrabalhoAtual)
% Modelo WERTZ Numérico %
torqueAtritoRolamento = coeficienteCoulomb*coeficienteAtritoViscoso.*rotacoesPorMinutoRodaDeReacao;
razaoDiferencaVelocidadeAtualVelocidadeMaximaPorVelocidadeMaxima = 1 - rotacoesPorMinutoRodaDeReacao/rotacoesPorMinutoRodaDeReacaoMaxima;
torqueEletromagnetico = 2.*magnitudeMaximaTorqueEletromagnatico.*melhorTorqueEletromagneticoParaRazaoVelocidadeAtualEVelocidadeMaxima.*razaoDiferencaVelocidadeAtualVelocidadeMaximaPorVelocidadeMaxima.*((melhorTorqueEletromagneticoParaRazaoVelocidadeAtualEVelocidadeMaxima.^2)+(razaoDiferencaVelocidadeAtualVelocidadeMaximaPorVelocidadeMaxima.^2)).^-1;
torqueAplicado = torqueEletromagnetico - torqueAtritoRolamento;
vetorTorqueAplicadoPolinomio = polinomioTorqueAplicadoPorVelocidadeRotacaoRodaDeReacao(coeficienteCoulomb,rotacoesPorMinutoRodaDeReacao,coeficienteAtritoViscoso,rotacoesPorMinutoRodaDeReacaoMaxima,magnitudeMaximaTorqueEletromagnatico,melhorTorqueEletromagneticoParaRazaoVelocidadeAtualEVelocidadeMaxima,tensao,fracaoDeTrabalhoAtual); % Aproximei a curva para um polinomio de grau 3
figure
plot (rotacoesPorMinutoRodaDeReacao,torqueAplicado,':k')
hold on
plot (rotacoesPorMinutoRodaDeReacao,vetorTorqueAplicadoPolinomio,'c')
grid
title('Modelo Wertz Tração Total de uma roda de reação')
xlabel('Velocidade de rotação [rpm]')
ylabel('Tração Total [N*m]')
axis square
hold off
% Laplace Simbolico %
plantaSimbolica = LaplaceSym(rotacoesPorMinutoRodaDeReacao,torqueAplicado);
[numeradorSimbolico, denominadorSimbolico] = numden(plantaSimbolica);
numeradorPlantaAberta = sym2poly(numeradorSimbolico);
denominadorPlantaAberta = sym2poly(denominadorSimbolico);
% Desenvolvimento Controlador %
sys = tf (numeradorPlantaAberta, denominadorPlantaAberta);
TunningPID(numeradorPlantaAberta,denominadorPlantaAberta);


