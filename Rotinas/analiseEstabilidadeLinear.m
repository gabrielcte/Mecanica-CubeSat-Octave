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
## @deftypefn {} {@var{retval} =} linearStabilityAnalysis (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: Gabriel Alves Silva <gabsilvalves@gabsilvalves-300E5EV-300E4EV-270E5EV-270E4EV-2470EV-2470EE>
## Created: 2022-04-26

function analiseEstabilidadeLinear
global matrizInercia
ganhoX = (matrizInercia(2,2)-matrizInercia(3,3))/matrizInercia(1,1);
ganhoZ = (matrizInercia(2,2)-matrizInercia(1,1))/matrizInercia(3,3);
vetorAuxiliar1 = linspace(-1,1,100);
vetorAuxiliar2 = linspace(-1,1,100);
for contador = 1:1:length(vetorAuxiliar1)
    contadorLinhailiar(contador,1) =vetorAuxiliar1(contador);
    auxiliar1(contador,1)=vetorAuxiliar1(contador);
    auxiliar2(contador,1)=vetorAuxiliar1(contador);
    auxiliar3(contador,1)=vetorAuxiliar1(contador);
    for contadorColuna = 1:1:length(vetorAuxiliar2)
        if vetorAuxiliar1(contador) < vetorAuxiliar2(contadorColuna)
            auxiliar(contador,contadorColuna) = vetorAuxiliar2(contadorColuna);
        end
        if vetorAuxiliar1(contador)*vetorAuxiliar2(contadorColuna) < 0
            auxiliar1(contador,contadorColuna) = vetorAuxiliar2(contadorColuna);
        end
        if 1+3*vetorAuxiliar1(contador)+vetorAuxiliar1(contador)*vetorAuxiliar2(contadorColuna) < 0
            auxiliar2(contador,contadorColuna) = vetorAuxiliar2(contadorColuna);
        end
        if ((1+3*vetorAuxiliar1(contador)+vetorAuxiliar1(contador)*vetorAuxiliar2(contadorColuna))^2)-16*vetorAuxiliar1(contador)*vetorAuxiliar2(contadorColuna) < 0
            auxiliar3(contador,contadorColuna) = vetorAuxiliar2(contadorColuna);
        end
    end
end
figure
hold on
title('Analise da Estabilidade Linear')
plot(vetorAuxiliar1,auxiliar1(:,:),'k.','MarkerSize',1);
plot(vetorAuxiliar1,auxiliar2(:,:),'k.','MarkerSize',1);
plot(vetorAuxiliar1,auxiliar3(:,:),'k.','MarkerSize',1);
plot(vetorAuxiliar1,vetorAuxiliar2,'k')
plot(vetorAuxiliar1,auxiliar(:,:),'k+','MarkerSize',1);
text(ganhoX,ganhoZ,'\otimes','FontWeight','bold','HorizontalAlignment','center','FontSize',15)
grid on
axis equal
xlim ([-1 1]);
set(gca, 'xtick', [-1 -0.75 -0.5 -0.25 0 0.25 0.5 0.75 1])
ylim ([-1 1]);
set(gca, 'ytick', [-1 -0.75 -0.5 -0.25 0 0.25 0.5 0.75 1])
yl = ylim;
xl = xlim;
xlabel('K1');
ylabel('K3');
text(0.75,0.5,'Stable','FontSize',8,'Color','k','EdgeColor','k','BackgroundColor','white','HorizontalAlignment','center')
text(-0.5,0.5,'Unstable Pitch','FontSize',8,'Color','k','EdgeColor','k','BackgroundColor','white','HorizontalAlignment','center')
text(0.65,-0.5,'Unstable Roll-Yaw','FontSize',8,'Color','k','EdgeColor','k','BackgroundColor','white','HorizontalAlignment','center')
text(-0.5,-0.85,'Unstable Roll-Yaw','FontSize',8,'Color','k','EdgeColor','k','BackgroundColor','white','HorizontalAlignment','center')
hold off
endfunction

