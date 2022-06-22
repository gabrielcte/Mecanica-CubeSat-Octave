clear all; close all; format longEng; clc
%
iteracoes = 1000;
massa = 1; % kg
constanteMola = 1; % kg/s^2
tempoFinal = 20; % s
tempoInicial = 0; % s
incrementoTempo = (tempoFinal-tempoInicial)/iteracoes; % s
% Integral Metodo de Riemann
tempo(1)= 0;
distancia(1) = 1; %m
velocidade(1) = 0;
for contador = 1:1:iteracoes
  aceleracao(contador) = (-constanteMola*distancia(contador))/massa;
  tempo(contador+1) = tempo(contador)+incrementoTempo;
  velocidade(contador+1) = velocidade(contador)+aceleracao(contador)*(tempo(contador+1)-tempo(contador));
  distancia(contador+1) = distancia(contador)+velocidade(contador+1)*(tempo(contador+1)-tempo(contador));
endfor
figure
hold on
plot(tempo,distancia,':b')
% Controle
clear tempo distancia velocidade
tempo(1)= 0;
distancia(1) = -1; %m
velocidade(1) = 0;
torqueControle = 0;
referencia = 0;
ganhoProporcional = 1*0.6;
ganhoIntegral = 2*6;
ganhoDerivativo = 0.125*6;
for contador = 1:1:iteracoes
  % Planta
  aceleracao(contador) = (-constanteMola*distancia(contador)+torqueControle)/massa;
  tempo(contador+1) = tempo(contador)+incrementoTempo;
  velocidade(contador+1) = velocidade(contador)+aceleracao(contador)*(tempo(contador+1)-tempo(contador));
  distancia(contador+1) = distancia(contador)+velocidade(contador+1)*(tempo(contador+1)-tempo(contador));
  % Controlador
  erro(contador) = referencia-distancia(contador);
  erro(contador+1) = referencia-distancia(contador+1);
  diferencaErro = erro(contador+1)-erro(contador);
  torqueControle = ganhoProporcional*erro(contador+1)+ganhoIntegral*(erro(contador+1)+diferencaErro)+ganhoDerivativo*(diferencaErro)/(tempo(contador+1)-tempo(contador));
endfor
plot(tempo, distancia, '.-k')
hold off
