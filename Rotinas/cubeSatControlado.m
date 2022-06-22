%====================%
% Inicialização %
%====================%
clear all; close all; format longEng; clc
%====================%
% Definindo funções %
%====================%
function parametrosCubeSatUniforme
  global unidadePadraoCubeSat massaCubeSat comprimentoCubeSat larguraCubeSat alturaCubeSat matrizInercia
  if unidadePadraoCubeSat == 1
    massaCubeSat = 1; % kg
    comprimentoCubeSat = 0.1; % m -> x
    larguraCubeSat = 0.1; % m -> y
    alturaCubeSat = 0.1; % m -> z
  end
  if unidadePadraoCubeSat>1 && unidadePadraoCubeSat<6
    massaCubeSat = unidadePadraoCubeSat*1; % kg
    comprimentoCubeSat = 0.1; % m -> x
    larguraCubeSat = 0.1; % m -> y
    alturaCubeSat = unidadePadraoCubeSat*0.1; % m -> z
  end
  if unidadePadraoCubeSat == 6
    massaCubeSat = unidadePadraoCubeSat*1; % kg
    comprimentoCubeSat = 0.1; % m -> x
    larguraCubeSat = 0.2; % m -> y
    alturaCubeSat = 0.3; % m -> z
  end
  momentoInerciaEixoXCorpo = 1/12*massaCubeSat*((larguraCubeSat^2)+(alturaCubeSat^2)); % kg*m^2
  momentoInerciaEixoYCorpo = 1/12*massaCubeSat*((comprimentoCubeSat^2)+(alturaCubeSat^2)); % kg*m^2
  momentoInerciaEixoZCorpo = 1/12*massaCubeSat*((larguraCubeSat^2)+(comprimentoCubeSat^2)); % kg*m^2
  matrizInercia = [momentoInerciaEixoXCorpo 0 0; 0 momentoInerciaEixoYCorpo 0; 0, 0, momentoInerciaEixoZCorpo];
endfunction
function graficosTrajetoriaAtitude
  global tempo quaternions angulosEulerAngularSistemaCoordenadasFixoCorpoEmRelacaoSistemaCoordenadasGeocentricoInercialEscritoNoSistemaCoordenadasFixoCorpo velocidadeAngularSistemaCoordenadasFixoCorpoEmRelacaoSistemaCoordenadasGeocentricoInercialEscritoNoSistemaCoordenadasFixoCorpo
  % Plotagem angulos de Euler e velocidade Angular
  figure
  subplot (3, 2, 1)
  plot(tempo, angulosEulerAngularSistemaCoordenadasFixoCorpoEmRelacaoSistemaCoordenadasGeocentricoInercialEscritoNoSistemaCoordenadasFixoCorpo(1, :), '.-b')
  grid on
  title('Evolução temporal do ângulo de rolamento')
  xlabel('segundos')
  ylabel('graus');
  grid on
  subplot (3, 2, 3)
  plot(tempo, angulosEulerAngularSistemaCoordenadasFixoCorpoEmRelacaoSistemaCoordenadasGeocentricoInercialEscritoNoSistemaCoordenadasFixoCorpo(2, :), '.-r')
  grid on
  title('Evolução temporal do ângulo de arfagem')
  xlabel('segundos')
  ylabel('graus');
  grid on
  subplot (3, 2, 5)
  plot(tempo, angulosEulerAngularSistemaCoordenadasFixoCorpoEmRelacaoSistemaCoordenadasGeocentricoInercialEscritoNoSistemaCoordenadasFixoCorpo(3, :), '.-g')
  title('Evolução temporal do ângulo de guinada')
  xlabel('segundos');
  ylabel('graus');
  grid on
  subplot (3, 2, 2)
  plot(tempo, velocidadeAngularSistemaCoordenadasFixoCorpoEmRelacaoSistemaCoordenadasGeocentricoInercialEscritoNoSistemaCoordenadasFixoCorpo(1, :), '.-b')
  title('Velocidade angular no eixo-x')
  xlabel('segundos');
  ylabel('graus');
  grid on
  subplot (3, 2, 4)
  plot(tempo, velocidadeAngularSistemaCoordenadasFixoCorpoEmRelacaoSistemaCoordenadasGeocentricoInercialEscritoNoSistemaCoordenadasFixoCorpo(2, :), '.-r')
  title('Velocidade angular no eixo-y')
  xlabel('segundos');
  ylabel('graus');
  grid on
  subplot (3, 2, 6)
  plot(tempo, velocidadeAngularSistemaCoordenadasFixoCorpoEmRelacaoSistemaCoordenadasGeocentricoInercialEscritoNoSistemaCoordenadasFixoCorpo(3, :), '.-g')
  title('Velocidade angular no eixo-z')
  xlabel('segundos');
  ylabel('graus');
  grid on
endfunction
%====================%
% Declarando e alocando variáveis %
%====================%
global parametroGravitacionalTerra unidadePadraoCubeSat massaCubeSat comprimentoCubeSat larguraCubeSat alturaCubeSat matrizInercia tempo angulosEulerAngularSistemaCoordenadasFixoCorpoEmRelacaoSistemaCoordenadasGeocentricoInercialEscritoNoSistemaCoordenadasFixoCorpo incrementoTempo velocidadeAngularSistemaCoordenadasFixoCorpoEmRelacaoSistemaCoordenadasGeocentricoInercialEscritoNoSistemaCoordenadasFixoCorpo incrementoTempo torqueCorpo
% Constantes %
raioTerra = 6.378136e+006; % m
parametroGravitacionalTerra = 3.98600441e+014; % m^3/s^2
% Parâmetros de órbita %
epoca = [19, 01, 2022, 13, 15, 00]; % UTC
distanciaInicialSistemaCoordenadasGeocentricoInercial = [2.25526213722520e+006; -3.00492371279401e+006; -5.84397331427593e+006]; % m
velocidadeInicialSistemaCoordenadasGeocentricoInercial = [-5.19923341417592e+003; 3.82519438208177e+003; -3.97333292224794e+003]; % m/s
subdivisoesOrbita = 2*360; % mínimo de 500 ou da instabilidade no integrador
% Alocando Variáveis %
tempo = zeros(subdivisoesOrbita, 1);
angulosEulerAngularSistemaCoordenadasFixoCorpoEmRelacaoSistemaCoordenadasGeocentricoInercialEscritoNoSistemaCoordenadasFixoCorpo = zeros(3,subdivisoesOrbita);
quaternions = zeros(4, subdivisoesOrbita);
velocidadeAngularSistemaCoordenadasFixoCorpoRelacaoSistemaOrbitalEscritoSistemaCoordenadasFixoCorpo = zeros(3, subdivisoesOrbita);
velocidadeAngularSistemaCoordenadasFixoCorpoEmRelacaoSistemaCoordenadasGeocentricoInercialEscritoNoSistemaCoordenadasFixoCorpo = zeros(3, subdivisoesOrbita);
% Parâmetros cubeSat %
unidadePadraoCubeSat = 6; % U
% Condições iniciais %
angulosEulerAngularSistemaCoordenadasFixoCorpoEmRelacaoSistemaCoordenadasGeocentricoInercialEscritoNoSistemaCoordenadasFixoCorpo(1, 1) = -pi/2; % rad
angulosEulerAngularSistemaCoordenadasFixoCorpoEmRelacaoSistemaCoordenadasGeocentricoInercialEscritoNoSistemaCoordenadasFixoCorpo(2, 1) = 0; % rad
angulosEulerAngularSistemaCoordenadasFixoCorpoEmRelacaoSistemaCoordenadasGeocentricoInercialEscritoNoSistemaCoordenadasFixoCorpo(3, 1) = pi/2; % rad
velocidadeAngularSistemaCoordenadasFixoCorpoRelacaoSistemaOrbitalEscritoSistemaCoordenadasFixoCorpo(1, 1) = -0.5; % rad/s
velocidadeAngularSistemaCoordenadasFixoCorpoRelacaoSistemaOrbitalEscritoSistemaCoordenadasFixoCorpo(2, 1) = 0.2; % rad/s
velocidadeAngularSistemaCoordenadasFixoCorpoRelacaoSistemaOrbitalEscritoSistemaCoordenadasFixoCorpo(3, 1) = 0.1; % rad/s
torqueCorpo = [0; 0; 0]; %N.m
% Controlador
referencia = [0; 0; 0]
ganhoProporcional = [0.6; 0.6; 0.6];
ganhoIntegral = [2; 2; 2];
ganhoDerivativo = [0.125; 0.125; 0.125];
%====================%
% Rotina %
%====================%
% Órbita Circular %
[semiEixoMaior] = vetoresEstadoOrbitalParaElementosOrbitaisKeplerianos(distanciaInicialSistemaCoordenadasGeocentricoInercial, velocidadeInicialSistemaCoordenadasGeocentricoInercial);
movimentoMedio = sqrt(parametroGravitacionalTerra/semiEixoMaior^3); % rad/s
periodoOrbital = 2*pi/movimentoMedio; % s
% Caracteristica Inercial %
parametrosCubeSatUniforme
% Análise de atitude %
sequenciadeRotacao = "XYZ";
quaternions(:, 1) = angulosEulerParaQuaternions(angulosEulerAngularSistemaCoordenadasFixoCorpoEmRelacaoSistemaCoordenadasGeocentricoInercialEscritoNoSistemaCoordenadasFixoCorpo(1, 1), angulosEulerAngularSistemaCoordenadasFixoCorpoEmRelacaoSistemaCoordenadasGeocentricoInercialEscritoNoSistemaCoordenadasFixoCorpo(2, 1), angulosEulerAngularSistemaCoordenadasFixoCorpoEmRelacaoSistemaCoordenadasGeocentricoInercialEscritoNoSistemaCoordenadasFixoCorpo(3, 1));
matrixRotacaoSistemaOrbitalemSistemaCoordenadasFixoCorpo = quaternionsParaMatrizRotacao(quaternions(:, 1));
velocidadeAngularSistemaCoordenadasOrbitalEmRelacaoSistemaCoordenadasGeocentricoInercialEscritoNoSistemaCoordenadasOrbital = [0; -movimentoMedio; 0]; % rad/s
velocidadeAngularSistemaCoordenadasFixoCorpoEmRelacaoSistemaCoordenadasGeocentricoInercialEscritoNoSistemaCoordenadasFixoCorpo(:, 1) = velocidadeAngularSistemaCoordenadasFixoCorpoRelacaoSistemaOrbitalEscritoSistemaCoordenadasFixoCorpo(:, 1)+matrixRotacaoSistemaOrbitalemSistemaCoordenadasFixoCorpo*velocidadeAngularSistemaCoordenadasOrbitalEmRelacaoSistemaCoordenadasGeocentricoInercialEscritoNoSistemaCoordenadasOrbital;
tempo(1) = 0.0; % s
incrementoTempo = periodoOrbital/subdivisoesOrbita;
numeroOrbitas = (1)*subdivisoesOrbita;
for contador = 1:numeroOrbitas;
  tempo(contador+1) = tempo(contador) + incrementoTempo;
  quaternions(:, contador+1) = integraQuaternions(quaternions(:, contador), velocidadeAngularSistemaCoordenadasFixoCorpoRelacaoSistemaOrbitalEscritoSistemaCoordenadasFixoCorpo(:, contador), tempo(contador));
  angulosEulerAngularSistemaCoordenadasFixoCorpoEmRelacaoSistemaCoordenadasGeocentricoInercialEscritoNoSistemaCoordenadasFixoCorpo(:, contador+1) = quaternionsParaAngulosEuler(quaternions(:, contador+1));
  matrixRotacaoSistemaOrbitalemSistemaCoordenadasFixoCorpo = quaternionsParaMatrizRotacao(quaternions(:,contador+1));
  velocidadeAngularSistemaCoordenadasFixoCorpoEmRelacaoSistemaCoordenadasGeocentricoInercialEscritoNoSistemaCoordenadasFixoCorpo(:,contador+1) = integraDinamica(velocidadeAngularSistemaCoordenadasFixoCorpoEmRelacaoSistemaCoordenadasGeocentricoInercialEscritoNoSistemaCoordenadasFixoCorpo(:,contador), tempo(contador));
  velocidadeAngularSistemaCoordenadasFixoCorpoRelacaoSistemaOrbitalEscritoSistemaCoordenadasFixoCorpo(:,contador+1) = velocidadeAngularSistemaCoordenadasFixoCorpoEmRelacaoSistemaCoordenadasGeocentricoInercialEscritoNoSistemaCoordenadasFixoCorpo(:,contador+1)-matrixRotacaoSistemaOrbitalemSistemaCoordenadasFixoCorpo*velocidadeAngularSistemaCoordenadasOrbitalEmRelacaoSistemaCoordenadasGeocentricoInercialEscritoNoSistemaCoordenadasOrbital;
% Controlador
erro(:,contador) = referencia-angulosEulerAngularSistemaCoordenadasFixoCorpoEmRelacaoSistemaCoordenadasGeocentricoInercialEscritoNoSistemaCoordenadasFixoCorpo(contador);
erro(:,contador+1) = referencia-angulosEulerAngularSistemaCoordenadasFixoCorpoEmRelacaoSistemaCoordenadasGeocentricoInercialEscritoNoSistemaCoordenadasFixoCorpo(:,contador+1);
diferencaErro = erro(:,contador+1)-erro(:,contador);
torqueControle = ganhoProporcional.*erro(:,contador+1)+ganhoIntegral.*(erro(:,contador+1)+diferencaErro)+ganhoDerivativo.*(diferencaErro)./(tempo(contador+1)-tempo(contador));
torqueCorpo = torqueControle;
endfor
tempo(numeroOrbitas+1) = tempo(numeroOrbitas)+incrementoTempo;
%%  Resultados
graficosTrajetoriaAtitude
