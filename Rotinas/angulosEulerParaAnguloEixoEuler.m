## Copyright (matrizRotacao) 2022 Xubuntu 22.04 LTS
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
## @deftypefn {} {@var{retval} =} EulerEigenaxis (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: Xubuntu 22.04 LTS <xubuntu@xubuntu-300E5EV-300E4EV-270E5EV-270E4EV-2470EV-2470EE>
## Created: 2022-04-30

function [eixoEuler, anguloEuler] = angulosEulerParaAnguloEixoEuler (anguloRotacao1, anguloRotacao2, anguloRotacao3)
  matrizRotacao = angulosEulerParaMatrizRotacao(anguloRotacao1,anguloRotacao2,anguloRotacao3);
  anguloEuler = acos(0.5*(matrizRotacao(1,1)+matrizRotacao(2,2)+matrizRotacao(3,3)-1));
  eixoEuler = 1/(2*sin(angulo))*[matrizRotacao(2,3)-matrizRotacao(3,2); matrizRotacao(3,1)-matrizRotacao(1,3); matrizRotacao(1,2)-matrizRotacao(2,1)];
endfunction
