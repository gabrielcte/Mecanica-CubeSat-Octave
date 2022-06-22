## Copyright (matrizRotacao) 2022 Gabriel Alves Silva
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
## @deftypefn {} {@var{retval} =} angle2R (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: Gabriel Alves Silva <gabsilvalves@gabsilvalves-300E5EV-300E4EV-270E5EV-270E4EV-2470EV-2470EE>
## Created: 2022-04-26

function matrizRotacao = angulosEulerParaMatrizRotacao (anguloRotacao1, anguloRotacao2, anguloRotacao3)
  global sequenciadeRotacao
  angle = [anguloRotacao1 anguloRotacao2 anguloRotacao3];
  matrizRotacao = eye(3);
  for i=1:1:length(sequenciadeRotacao)
      if sequenciadeRotacao(i) == 'X'
          eixox = angle(i);
          rotacaoEixox = [1 0 0; 0 cos(eixox) sin(eixox); 0 -sin(eixox) cos(eixox)];
        matrizRotacao = matrizRotacao*rotacaoEixox;
    end
    if sequenciadeRotacao(i) == 'Y'
        eixoy = angle(i);
        rotacaoEixoy = [cos(eixoy) 0 -sin(eixoy); 0 1 0; sin(eixoy) 0 cos(eixoy)];
        matrizRotacao = matrizRotacao*rotacaoEixoy;
    end
    if sequenciadeRotacao(i) == 'Z'
        eixoz = angle(i);
        rotacaoEixoz = [cos(eixoz) sin(eixoz) 0; -sin(eixoz) cos(eixoz) 0; 0 0 1];
        matrizRotacao = matrizRotacao*rotacaoEixoz;
    end
end
endfunction
