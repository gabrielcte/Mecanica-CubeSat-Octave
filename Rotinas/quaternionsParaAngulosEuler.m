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
## @deftypefn {} {@var{retval} =} quaterniontoAngle (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: Ubuntu 20.04 LTS <ubuntu@ubuntu-300E5EV-300E4EV-270E5EV-270E4EV-2470EV-2470EE>
## Created: 2022-05-10

function EulerAngles = quaternionsParaAngulosEuler(quaternions)
matrizRotacao = quaternionsParaMatrizRotacao (quaternions);
arfagem = -asin(matrizRotacao(1,3));
if ((arfagem>pi/2)||(arfagem<=-pi/2))
  arfagem = pi-arfagem;
endif
guinada = atan2(matrizRotacao(1,2),matrizRotacao(1,1));
rolamento = atan2(matrizRotacao(2,3),matrizRotacao(3,3));
EulerAngles = [rolamento; arfagem; guinada];
endfunction
