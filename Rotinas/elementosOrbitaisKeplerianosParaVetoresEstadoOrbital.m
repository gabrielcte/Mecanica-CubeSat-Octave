## Copyright (C) 2022 Gabriel Alves Silva
##
## This program is free software; you can redistribute it and/or modify it
## under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 3 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program.  If not, see <http://www.gnu.org/licenses/>.

## -*- texinfo -*-
## @deftypefn {} {@var{retval} =} coe2rv (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: Gabriel Alves Silva <gabsilvalves@gabsilvalves-300E5EV-300E4EV-270E5EV-270E4EV-2470EV-2470EE>
## Created: 2022-04-28

function [distanciaInicialSistemaCoordenadasGeocentricoInercial, velocidadeInicialSistemaCoordenadasGeocentricoInercial] = elementosOrbitaisKeplerianosParaVetoresEstadoOrbital
global parametroGravitacionalTerra semiLatusRectum semiEixoMaior excentricidade inclinacao ascensaoRetaNodoAscendente argumentoPerigeu anomaliaVerdadeira
anomaliaExcentrica = anomaliaVerdadeira+argumentoPerigeu;
matrizTransformacao(1,1) = cosd(ascensaoRetaNodoAscendente)*cosd(anomaliaExcentrica)-sind(ascensaoRetaNodoAscendente)*sind(anomaliaExcentrica)*cosd(inclinacao);
matrizTransformacao(1,2) = sind(ascensaoRetaNodoAscendente)*cosd(anomaliaExcentrica)+cosd(ascensaoRetaNodoAscendente)*sind(anomaliaExcentrica)*cosd(inclinacao);
matrizTransformacao(1,3) = sind(anomaliaExcentrica)*sind(inclinacao);
matrizTransformacao(2,1) = -cosd(ascensaoRetaNodoAscendente)*sind(anomaliaExcentrica)-sind(ascensaoRetaNodoAscendente)*cosd(anomaliaExcentrica)*cosd(inclinacao);
matrizTransformacao(2,2) = -sind(ascensaoRetaNodoAscendente)*sind(anomaliaExcentrica)+cosd(ascensaoRetaNodoAscendente)*cosd(anomaliaExcentrica)*cosd(inclinacao);
matrizTransformacao(2,3) = cosd(anomaliaExcentrica)*sind(inclinacao);
matrizTransformacao(3,1) = sind(ascensaoRetaNodoAscendente)*sind(inclinacao);
matrizTransformacao(3,2) = -cosd(ascensaoRetaNodoAscendente)*sind(inclinacao);
matrizTransformacao(3,3) = cosd(inclinacao);
distanciaInicialSistemaCoordenadasGeocentricoInercial = transpose(matrizTransformacao)*[semiLatusRectum/(1+excentricidade*cosd(anomaliaVerdadeira));0;0];
velocidadeInicialSistemaCoordenadasGeocentricoInercial = sqrt(parametroGravitacionalTerra/semiLatusRectum)*transpose(matrizTransformacao)*[excentricidade*sind(anomaliaVerdadeira);(1+excentricidade*cosd(anomaliaVerdadeira));0];
endfunction
