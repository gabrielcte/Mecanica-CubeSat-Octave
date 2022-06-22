%====================%
% Inicialização %
%====================%
clear all; close all; format longEng; clc
%====================%
% Carregando Pacotes %
%====================%
%====================%
% Definindo funções %
%====================%
function [fracaoDeTrabalho] = cicloDeTrabalho(corrente)
  global correnteMinima correnteOciosa correnteRotacaoMinima correntePicoReduzido correntePicoReal
  picoDeTrabalho = 1;
  contador=1;
  fracaoDeTrabalho = zeros(1,length(corrente));
  for contador = 1:1:length(corrente)
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
    endfor
endfunction
%{
Modelo para Roda de Reação pelo WERTZ por Gabriel Alves Silva
m -> massaRodaDeReacao
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
%====================%
% Declarando e alocando variáveis %
%====================%
global correnteMinima = 0; % A
global correnteOciosa = 9 * 10^-3; % A
global correnteRotacaoMinima = 30 * 10^-3; % A
global correntePicoReduzido = 300 * 10^-3; % A
global correntePicoReal = 650 * 10^-3; % A
tensao = 5; % V
massaRodaDeReacao = 0.137; % kg
raioRodaDeReacao = 43.5*10^-3; % m
momentoInerciaEixoAxial = (massaRodaDeReacao*raioRodaDeReacao^2)/2; % kg*m^2
matrizInerciaRodaDeReacao = eye(3)*momentoInerciaEixoAxial;
rotacoesPorMinutoRodaDeReacaoMaxima = 6500; %RPM;
coeficienteCoulomb = 7.06*10^-4; %N*m
coeficienteAtritoViscoso = 0.00000455/9.54929; %N*m/RPM
magnitudeMaximaTorqueEletromagnatico = 0.03; %N*m
melhorTorqueEletromagneticoParaRazaoVelocidadeAtualEVelocidadeMaxima = 1-(rotacoesPorMinutoRodaDeReacaoMaxima/3)/rotacoesPorMinutoRodaDeReacaoMaxima; %
% Modelo WERTZ Analítico %
corrente = linspace(0,650 * 10^-3,1/0.1e-003);
rotacoesPorMinutoRodaDeReacao = linspace(0,6500,length(corrente));
fracaoDeTrabalho = cicloDeTrabalho(corrente);
vetorCorrente = [correnteMinima; correnteOciosa; correnteOciosa+0.1e-003; correnteRotacaoMinima; correntePicoReduzido; correntePicoReal];
vetorVelocidade = [0; 0; 100; 500; 1000; 6500];
relacaoVelocidadeCorrente = polyfit(vetorVelocidade,vetorCorrente,2);

for contador = 1:1:length(corrente);
  correnteAtual = polyval(relacaoVelocidadeCorrente,1000)
  torqueAtritoRolamento(contador) = coeficienteCoulomb*sign(rotacoesPorMinutoRodaDeReacao(contador))+coeficienteAtritoViscoso.*rotacoesPorMinutoRodaDeReacao(contador);
  razaoDiferencaVelocidadeAtualVelocidadeMaximaPorVelocidadeMaxima(contador) = 1-rotacoesPorMinutoRodaDeReacao(contador)/rotacoesPorMinutoRodaDeReacaoMaxima;
  torqueEletromagnetico(contador) = 2.*magnitudeMaximaTorqueEletromagnatico.*melhorTorqueEletromagneticoParaRazaoVelocidadeAtualEVelocidadeMaxima.*razaoDiferencaVelocidadeAtualVelocidadeMaximaPorVelocidadeMaxima(contador).*((melhorTorqueEletromagneticoParaRazaoVelocidadeAtualEVelocidadeMaxima.^2)+(razaoDiferencaVelocidadeAtualVelocidadeMaximaPorVelocidadeMaxima(contador).^2)).^-1;
  torqueAplicado(contador) = sign(tensao).*fracaoDeTrabalho(contador).*torqueEletromagnetico(contador)-torqueAtritoRolamento(contador);
endfor
%====================%
% Rotina %
%====================%
% Entrada
torqueControle = [-11.689188838616035e+00; -2.574984807953079e+00; -100.836957692956446e-03]; % N.m
%====================%
% Resultado %
%====================%
 plot(rotacoesPorMinutoRodaDeReacao,torqueAplicado)
