## Copyright (C) 2022 Ubuntu 20.04 LTS
##
## This program is free software: you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program.  If not, see <https://www.gnu.org/licenses/>.

## -*- texinfo -*-
## @deftypefn {} {@var{retval} =} blabo (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: Ubuntu 20.04 LTS <ubuntu@ubuntu-300E5EV-300E4EV-270E5EV-270E4EV-2470EV-2470EE>
## Created: 2022-05-17

function [distanciaEixoXSistemaCoordenadasGeocentricoInercial, distanciaEixoYSistemaCoordenadasGeocentricoInercial, distanciaEixoZSistemaCoordenadasGeocentricoInercial, latitude, longitude] = posicaoVeiculoEspacialOrbitaCircularReferenciaInercial(numeroOrbitas ,incrementoTempo)
global   excentricidade semiEixoMaior semiLatusRectum inclinacao ascensaoRetaNodoAscendente argumentoPerigeu anomaliaVerdadeira sequenciadeRotacao
distanciaEixoXSistemaCoordenadasGeocentricoInercial = zeros(numeroOrbitas, 1);
distanciaEixoYSistemaCoordenadasGeocentricoInercial = zeros(numeroOrbitas, 1);
distanciaEixoZSistemaCoordenadasGeocentricoInercial = zeros(numeroOrbitas, 1);
latitude = zeros(numeroOrbitas, 1);
longitude = zeros(numeroOrbitas, 1);
matrizRotacao = angulosEulerParaMatrizRotacao (-ascensaoRetaNodoAscendente, -inclinacao, -argumentoPerigeu);
for contador = 1:numeroOrbitas
    anomaliaExcentrica = argumentoPerigeu+anomaliaVerdadeira;
    distanciaEixoXSistemaCoordenadasGeocentricoInercial(contador) = (semiLatusRectum/(1+norm(excentricidade)*cos(anomaliaVerdadeira)))*(cos(norm(ascensaoRetaNodoAscendente))*cos(anomaliaExcentrica)-sin(norm(ascensaoRetaNodoAscendente))*sin(anomaliaExcentrica)*cos(norm(inclinacao)));
    distanciaEixoYSistemaCoordenadasGeocentricoInercial(contador) = (semiLatusRectum/(1+norm(excentricidade)*cos(anomaliaVerdadeira)))*(sin(norm(ascensaoRetaNodoAscendente))*cos(anomaliaExcentrica)+cos(norm(ascensaoRetaNodoAscendente))*sin(anomaliaExcentrica)*cos(norm(inclinacao)));
    distanciaEixoZSistemaCoordenadasGeocentricoInercial(contador) = (semiLatusRectum/(1+norm(excentricidade)*cos(anomaliaVerdadeira)))*(sin(anomaliaExcentrica)*sin(norm(inclinacao)));
    anomaliaVerdadeira = anomaliaVerdadeira+incrementoTempo;
% Trajetória Polar
  auxiliar(contador) =(anomaliaVerdadeira);
  raioCoordenadaPolar(contador) = semiEixoMaior*(1-dot(excentricidade,excentricidade))/(1+norm(excentricidade)*cos(auxiliar(contador)));
  eixoXpolar(contador) = raioCoordenadaPolar(contador)*cos(anomaliaVerdadeira);
  eixoYpolar(contador) = raioCoordenadaPolar(contador)*sin(anomaliaVerdadeira);
  eixoZpolar(contador) = 0;
  anomaliaVerdadeira = anomaliaVerdadeira+incrementoTempo;
% Trajetória SGI
    velocidadePolar(1,1) = eixoXpolar(contador);
    velocidadePolar(2,1) = eixoYpolar(contador);
    velocidadePolar(3,1) = eixoZpolar(contador);
    velocidadeSistemaGeocentricoInercial = matrizRotacao*velocidadePolar;
    eixoXSistemaGeocentricoInercial(contador) = velocidadeSistemaGeocentricoInercial(1,1);
    eixoYSistemaGeocentricoInercial(contador) = velocidadeSistemaGeocentricoInercial(2,1);
    eixoZSistemaGeocentricoInercial(contador) = velocidadeSistemaGeocentricoInercial(3,1);
%Ground Track
  latitude(contador) = rad2deg(atan2(eixoZSistemaGeocentricoInercial(contador),sqrt(eixoXSistemaGeocentricoInercial(contador)^2+eixoYSistemaGeocentricoInercial(contador)^2)));
  longitude(contador) = rad2deg(atan2(eixoYSistemaGeocentricoInercial(contador),eixoXSistemaGeocentricoInercial(contador)));
  if longitude(contador) < 0;
    longitude(contador) = longitude(contador);
    endif
endfor
endfunction
