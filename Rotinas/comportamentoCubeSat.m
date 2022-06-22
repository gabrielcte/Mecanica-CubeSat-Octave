%====================%
% Inicialização %
%====================%
clear all; close all; format longEng; clc
%====================%
% Definindo funções %
%====================%
function exibirParametrosOrbita
  global epoca semiEixoMaior excentricidade inclinacao ascensaoRetaNodoAscendente argumentoPerigeu anomaliaVerdadeira periodoOrbital
  disp('======================================')
  disp('Parâmetros de órbita:')
  disp('======================================')
  disp(['UTC: ', num2str(epoca)])
  disp('J2000')
  disp(['Semi eixo maior: ', num2str(semiEixoMaior), ' metros'])
  disp(['Excentricidade: ', num2str(norm(excentricidade))])
  disp(['Inclinação: ', num2str(inclinacao),'°'])
  disp(['Ascensão reta do nodo ascendente: ', num2str(ascensaoRetaNodoAscendente),'°'])
  disp(['Argumento do perigeu: ', num2str(argumentoPerigeu),'°'])
  disp(['Anomalia verdadeira: ', num2str(anomaliaVerdadeira),'°'])
  disp(['Período Órbital: ', num2str(periodoOrbital), ' segundos'])
  disp('======================================')
endfunction
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
function exibirParametrosCubeSat
  global unidadePadraoCubeSat massaCubeSat comprimentoCubeSat larguraCubeSat alturaCubeSat matrizInercia
  disp('Parâmetros do CubeSat: ')
  disp('======================================')
  disp(['Unidade: ', num2str(unidadePadraoCubeSat), ' U'])
  disp(['Massa: ', num2str(massaCubeSat), ' kg'])
  disp(['Comprimento: ', num2str(comprimentoCubeSat), ' m'])
  disp(['Largura: ', num2str(larguraCubeSat), ' m'])
  disp(['Altura: ', num2str(alturaCubeSat), ' m'])
  disp('Matriz de inércia: ')
  disp(num2str(matrizInercia))
  disp(' kg.m.s^2')
  disp('======================================')
endfunction
function graficosTrajetoriaAtitude
  global tempo quaternions angulosEulerAngularSistemaCoordenadasFixoCorpoEmRelacaoSistemaCoordenadasGeocentricoInercialEscritoNoSistemaCoordenadasFixoCorpo velocidadeAngularSistemaCoordenadasFixoCorpoEmRelacaoSistemaCoordenadasGeocentricoInercialEscritoNoSistemaCoordenadasFixoCorpo distanciaEixoXSistemaCoordenadasGeocentricoInercial distanciaEixoYSistemaCoordenadasGeocentricoInercial distanciaEixoZSistemaCoordenadasGeocentricoInercial latitude longitude
  % Plotagem de Órbita em 3 dimenções
  figure
  subplot (1, 2, 1)
  hold on
  plot3(distanciaEixoXSistemaCoordenadasGeocentricoInercial, distanciaEixoYSistemaCoordenadasGeocentricoInercial, distanciaEixoZSistemaCoordenadasGeocentricoInercial,'.k')
  GRS80
  title('Visualização 3D da Órbita')
  view([-165 15])
  axis equal
  grid on
  hold off
  % Plotagem do rastreio da Órbita em solo
  subplot (1, 2, 2)
  hold on
  mapaContornoTerra
  title('Rastreio em solo da Órbita')
  plot(longitude,latitude,'.k')
  hold off
  % Plotagem dos Parametros de Euler (Quaternions)
  figure
  subplot (2, 2, 1)
  plot(tempo,quaternions(1, :), '.-b'),
  title('Evolução temporal q1')
  xlabel('segundos');
  grid on
  subplot (2, 2, 2)
  plot(tempo,quaternions(2, :), '.-g'),
  title('Evolução temporal q2')
  xlabel('segundos');
  grid on
  subplot (2, 2, 3)
  plot(tempo,quaternions(3, :), '.-r'),
  title('Evolução temporal q3')
  xlabel('segundos');
  grid on
  subplot (2, 2, 4)
  plot(tempo,quaternions(4, :), '.-k'),
  title('Evolução temporal q4')
  xlabel('segundos');
  grid on
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
global parametroGravitacionalTerra epoca semiEixoMaior semiLatusRectum excentricidade inclinacao ascensaoRetaNodoAscendente argumentoPerigeu anomaliaVerdadeira anomaliaMediaEpoca movimentoMedio periodoOrbital sequenciadeRotacao distanciaEixoXSistemaCoordenadasGeocentricoInercial distanciaEixoYSistemaCoordenadasGeocentricoInercial distanciaEixoZSistemaCoordenadasGeocentricoInercial latitude longitude matrizInercia unidadePadraoCubeSat massaCubeSat comprimentoCubeSat larguraCubeSat alturaCubeSat angulosEulerAngularSistemaCoordenadasFixoCorpoEmRelacaoSistemaCoordenadasGeocentricoInercialEscritoNoSistemaCoordenadasFixoCorpo tempo subdivisoesOrbita quaternions velocidadeAngularSistemaCoordenadasFixoCorpoEmRelacaoSistemaCoordenadasGeocentricoInercialEscritoNoSistemaCoordenadasFixoCorpo tempoComeco incrementoTempo torqueCorpo velocidadeAngularSistemaCoordenadasOrbitalEmRelacaoSistemaCoordenadasGeocentricoInercialEscritoNoSistemaCoordenadasOrbital
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
torqueCorpo = [0; 0; 0];
%====================%
% Rotina %
%====================%
% Órbita Circular %
[semiEixoMaior, excentricidade, inclinacao, ascensaoRetaNodoAscendente, argumentoPerigeu, anomaliaVerdadeira] = vetoresEstadoOrbitalParaElementosOrbitaisKeplerianos(distanciaInicialSistemaCoordenadasGeocentricoInercial, velocidadeInicialSistemaCoordenadasGeocentricoInercial);
altitudeOrbita = semiEixoMaior-raioTerra; % altitude da �rbita (m)
movimentoMedio = sqrt(parametroGravitacionalTerra/semiEixoMaior^3); % rad/s
periodoOrbital = 2*pi/movimentoMedio; % s
momentoAngularEspecifico = cross(distanciaInicialSistemaCoordenadasGeocentricoInercial, velocidadeInicialSistemaCoordenadasGeocentricoInercial); % m^2/s
semiLatusRectum = dot(momentoAngularEspecifico, momentoAngularEspecifico)/parametroGravitacionalTerra; % m
exibirParametrosOrbita
% Análise de trajetória 3D e 2D %
incrementoTempo = periodoOrbital/subdivisoesOrbita;
numeroOrbitas = (1)*subdivisoesOrbita;
sequenciadeRotacao = "ZXZ";
[distanciaEixoXSistemaCoordenadasGeocentricoInercial, distanciaEixoYSistemaCoordenadasGeocentricoInercial, distanciaEixoZSistemaCoordenadasGeocentricoInercial, latitude, longitude] = posicaoVeiculoEspacialOrbitaCircularReferenciaInercial(numeroOrbitas, incrementoTempo);
% Caracteristica Inercial %
parametrosCubeSatUniforme
exibirParametrosCubeSat
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
endfor
tempo(numeroOrbitas+1) = tempo(numeroOrbitas)+incrementoTempo;
%%  Resultados
graficosTrajetoriaAtitude
