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
## @deftypefn {} {@var{retval} =} matrizRotacaotoQuaternions (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: Ubuntu 20.04 LTS <ubuntu@ubuntu-300E5EV-300E4EV-270E5EV-270E4EV-2470EV-2470EE>
## Created: 2022-05-24

function quaternions = matrizRotacaoParaQuaternions(matrizRotacao)

auxiliar(1) = 0.5 * sqrt((1 + matrizRotacao(1, 1) + matrizRotacao(2, 2) + matrizRotacao(3, 3)));
auxiliar(2) = 0.5 * sqrt((1 + matrizRotacao(1, 1) - matrizRotacao(2, 2) - matrizRotacao(3, 3)));
auxiliar(3) = 0.5 * sqrt((1 - matrizRotacao(1, 1) + matrizRotacao(2, 2) - matrizRotacao(3, 3)));
auxiliar(4) = 0.5 * sqrt((1 - matrizRotacao(1, 1) - matrizRotacao(2, 2) + matrizRotacao(3, 3)));

[maximo, indice] = max(auxiliar); % => identifica qual dos 4 valores acima tem maior valor;
% isto � �til para computo dos quaternios, pois � desej�vel que o termo que
% vir� no denominador (que pode ser q4, q3, q2 ou q1) tenha o valor maior
% poss�vel (n�o pr�ximo de zero). (WERTZ, p. 415)


% ajeitado para q = [k1.sen(fi/2) k2.sen(fi/2) k3.sen(fi/2) cos(fi/2)]' =>
% parte real = q4.
% antes, estava com quaternio invertido, com parte real = q1, isto �,
% estava assim: q = [cos(fi/2) k1.sen(fi/2) k2.sen(fi/2) k3.sen(fi/2)]'
switch (indice)  % de acordo com SIDI, p. 325
    case 1
        quaternions(4) = maximo;
        quaternions(1) = (matrizRotacao(2,3) - matrizRotacao(3,2)) / (4 * quaternions(4));
        quaternions(2) = (matrizRotacao(3,1) - matrizRotacao(1,3)) / (4 * quaternions(4));
        quaternions(3) = (matrizRotacao(1,2) - matrizRotacao(2,1)) / (4 * quaternions(4));
    case 2
        quaternions(1) = maximo;
        quaternions(2) = (matrizRotacao(2,1) + matrizRotacao(1,2)) / (4 * quaternions(1));
        quaternions(3) = (matrizRotacao(1,3) + matrizRotacao(3,1)) / (4 * quaternions(1));
        quaternions(4) = (matrizRotacao(3,2) + matrizRotacao(2,3)) / (4 * quaternions(1));
    case 3
        quaternions(2) = maximo;
        quaternions(1) = (matrizRotacao(2,1) + matrizRotacao(1,2)) / (4 * quaternions(2));
        quaternions(3) = (matrizRotacao(3,2) + matrizRotacao(2,3)) / (4 * quaternions(2));
        quaternions(4) = (matrizRotacao(3,1) - matrizRotacao(1,3)) / (4 * quaternions(2));
    case 4
        quaternions(3) = maximo;
        quaternions(1) = (matrizRotacao(1,3) + matrizRotacao(3,1)) / (4 * quaternions(3));
        quaternions(2) = (matrizRotacao(3,2) + matrizRotacao(2,3)) / (4 * quaternions(3));
        quaternions(4) = (matrizRotacao(1,2) - matrizRotacao(2,1)) / (4 * quaternions(3));
        endswitch
endfunction
