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
## @deftypefn {} {@var{retval} =} integracaoDinamica (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: Ubuntu 20.04 LTS <ubuntu@ubuntu-300E5EV-300E4EV-270E5EV-270E4EV-2470EV-2470EE>
## Created: 2022-05-17

function [novaVelocidadeAngularSistemaCorpoRelacaoSistemaInercialEscritoSistemaCorpo] = integraDinamica(velocidadeAngularSistemaCorpoRelacaoSistemaInercialEscritoSistemaCorpoContador1, tempoContador1)
global incrementoTempo torqueCorpo
tempoContador2 = tempoContador1+incrementoTempo;
condicaoInicial = velocidadeAngularSistemaCorpoRelacaoSistemaInercialEscritoSistemaCorpoContador1';
configuracaoODE = odeset('RelTol', 1e-6, 'AbsTol', [1e-6 1e-6 1e-6]);
[Tempo, Saida] = ode23(@odeDinamica, [tempoContador1 tempoContador2], condicaoInicial, configuracaoODE);
auxiliar = size(Saida, 1);
novaVelocidadeAngularSistemaCorpoRelacaoSistemaInercialEscritoSistemaCorpo = [Saida(auxiliar,1) Saida(auxiliar,2) Saida(auxiliar,3)]';
endfunction
function taxaSaida =odeDinamica(Tempo, velocidadeAngular)
global matrizInercia torqueCorpo
taxaSaida = zeros(3,1);
taxaSaida(1)= (1/matrizInercia(1,1))*((matrizInercia(2,2)-matrizInercia(3,3))*velocidadeAngular(2)*velocidadeAngular(3)+torqueCorpo(1));
taxaSaida(2)= (1/matrizInercia(2,2))*((matrizInercia(3,3)-matrizInercia(1,1))*velocidadeAngular(1)*velocidadeAngular(3)+torqueCorpo(2));
taxaSaida(3)= (1/matrizInercia(3,3))*((matrizInercia(1,1)-matrizInercia(2,2))*velocidadeAngular(1)*velocidadeAngular(2)+torqueCorpo(3));
endfunction
