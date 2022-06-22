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
## @deftypefn {} {@var{retval} =} integraQuaternions (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: Ubuntu 20.04 LTS <ubuntu@ubuntu-300E5EV-300E4EV-270E5EV-270E4EV-2470EV-2470EE>
## Created: 2022-05-17

function quaternionsNovo = integraQuaternions(quaternionsContador1, velocidadeAngularSistemaCoordenadasFixoCorpoRelacaoSistemaOrbitalEscritoSistemaCoordenadasFixoCorpoContador1, tempoComeco)
  global incrementoTempo velocidadeAngularSistemaCoordenadasFixoCorpoRelacaoSistemaOrbitalEscritoSistemaCoordenadasFixoCorpo
  velocidadeAngularSistemaCoordenadasFixoCorpoRelacaoSistemaOrbitalEscritoSistemaCoordenadasFixoCorpo = velocidadeAngularSistemaCoordenadasFixoCorpoRelacaoSistemaOrbitalEscritoSistemaCoordenadasFixoCorpoContador1;
  tempoContador2 = tempoComeco+incrementoTempo;
  condicaoInicial = [quaternionsContador1'];
  configuracaoODE = odeset('RelTol',1e-6,'AbsTol',[1e-6 1e-6 1e-6 1e-6]);
  [tempo, saida] = ode23(@edoCinematica,[tempoComeco tempoContador2], condicaoInicial,configuracaoODE);
  auxiliar = size(saida,1);
  quaternionsNovo = [saida(auxiliar,1) saida(auxiliar,2) saida(auxiliar,3) saida(auxiliar,4)]';
endfunction
function taxaSaida = edoCinematica(tempo,saida)
  global velocidadeAngularSistemaCoordenadasFixoCorpoRelacaoSistemaOrbitalEscritoSistemaCoordenadasFixoCorpo
  taxaSaida = zeros(4,1);
  vetorSaida = [saida(1); saida(2); saida(3); saida(4)];
  matrizAntisimetricaVelocidadeAngular = [0, velocidadeAngularSistemaCoordenadasFixoCorpoRelacaoSistemaOrbitalEscritoSistemaCoordenadasFixoCorpo(3), -velocidadeAngularSistemaCoordenadasFixoCorpoRelacaoSistemaOrbitalEscritoSistemaCoordenadasFixoCorpo(2), velocidadeAngularSistemaCoordenadasFixoCorpoRelacaoSistemaOrbitalEscritoSistemaCoordenadasFixoCorpo(1); -velocidadeAngularSistemaCoordenadasFixoCorpoRelacaoSistemaOrbitalEscritoSistemaCoordenadasFixoCorpo(3), 0, velocidadeAngularSistemaCoordenadasFixoCorpoRelacaoSistemaOrbitalEscritoSistemaCoordenadasFixoCorpo(1), velocidadeAngularSistemaCoordenadasFixoCorpoRelacaoSistemaOrbitalEscritoSistemaCoordenadasFixoCorpo(2); velocidadeAngularSistemaCoordenadasFixoCorpoRelacaoSistemaOrbitalEscritoSistemaCoordenadasFixoCorpo(2), -velocidadeAngularSistemaCoordenadasFixoCorpoRelacaoSistemaOrbitalEscritoSistemaCoordenadasFixoCorpo(1), 0, velocidadeAngularSistemaCoordenadasFixoCorpoRelacaoSistemaOrbitalEscritoSistemaCoordenadasFixoCorpo(3); -velocidadeAngularSistemaCoordenadasFixoCorpoRelacaoSistemaOrbitalEscritoSistemaCoordenadasFixoCorpo(1), -velocidadeAngularSistemaCoordenadasFixoCorpoRelacaoSistemaOrbitalEscritoSistemaCoordenadasFixoCorpo(2), -velocidadeAngularSistemaCoordenadasFixoCorpoRelacaoSistemaOrbitalEscritoSistemaCoordenadasFixoCorpo(3),0];
  taxaSaida = 0.5*matrizAntisimetricaVelocidadeAngular*vetorSaida;
endfunction
