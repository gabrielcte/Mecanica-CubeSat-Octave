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
## @deftypefn {} {@var{retval} =} orbitalStatesVectorstoKeplerianOrbitalElements (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: Ubuntu 20.04 LTS <ubuntu@ubuntu-300E5EV-300E4EV-270E5EV-270E4EV-2470EV-2470EE>
## Created: 2022-05-16

function [semiEixoMaior, excentricidade, inclinacao, ascensaoRetaNodoAscendente, argumentoPerigeu, anomaliaVerdadeira] = vetoresEstadoOrbitalParaElementosOrbitaisKeplerianos(distanciaInicialSistemaCoordenadasGeocentricoInercial, velocidadeInicialSistemaCoordenadasGeocentricoInercial);
global parametroGravitacionalTerra
% versores sistema de coordenadas inercial centrado na terra J2000
vetorUnitariok = [0; 0; 1];
vetorUnitarioi = [1; 0; 0];
% Elementos orbitais clássicos
momentoAngularEspecifico = cross(distanciaInicialSistemaCoordenadasGeocentricoInercial, velocidadeInicialSistemaCoordenadasGeocentricoInercial); % m^2/s
semiLatusRectum = dot(momentoAngularEspecifico, momentoAngularEspecifico)/parametroGravitacionalTerra; % m
vetorLaplaceRungeLenz = (cross(velocidadeInicialSistemaCoordenadasGeocentricoInercial, momentoAngularEspecifico) - parametroGravitacionalTerra*distanciaInicialSistemaCoordenadasGeocentricoInercial/norm(distanciaInicialSistemaCoordenadasGeocentricoInercial)); % m^3/s^2
excentricidade = vetorLaplaceRungeLenz/parametroGravitacionalTerra;
semiEixoMaior = semiLatusRectum/(1-dot(excentricidade, excentricidade)); %m
vetorNodal = cross(vetorUnitariok, momentoAngularEspecifico); % m^2/s
inclinacao = acos(dot(vetorUnitariok, momentoAngularEspecifico)/norm(momentoAngularEspecifico));
ascensaoRetaNodoAscendente = acos(dot(vetorUnitarioi, vetorNodal)/norm(vetorNodal));
argumentoPerigeu = acos(dot(excentricidade, vetorNodal)/(norm(excentricidade)*norm(vetorNodal)));
anomaliaVerdadeira = real(acos(dot(distanciaInicialSistemaCoordenadasGeocentricoInercial, excentricidade)/(norm(excentricidade)*norm(distanciaInicialSistemaCoordenadasGeocentricoInercial)))); %rad
endfunction
