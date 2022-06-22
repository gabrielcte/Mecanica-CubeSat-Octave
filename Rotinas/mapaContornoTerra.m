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
## @deftypefn {} {@var{retval} =} EarthContourMap (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: Ubuntu 20.04 LTS <ubuntu@ubuntu-300E5EV-300E4EV-270E5EV-270E4EV-2470EV-2470EE>
## Created: 2022-05-16

function mapaContornoTerra
contour = imread('mapaContorno.jpg');
xlabel("Longitude")
ylabel("Latitude")
xlim([-180 180]);                        % set x limits
xticks([-180 -150 -120 -90 -60 -30 0 30 60 90 120 150 180]);    % define x ticks
xticklabels({'180W' '150W' '120W' '90W' '60W' '30W' '0' '30E' '60E' '90E' '120E' '150E' '180E'})
ylim([-90 90]);                        % set x limits
yticks([-90 -75 -60 -45 -30 -15 0 15 30 45 60 75 90]);    % define x ticks
yticklabels({'90N' '75N' '60N' '45N' '30N' '15N' '0' '15S' '30S' '45S' '60S' '75S' '90S'})
imshow(contour,"xdata",[-180 180],"ydata",[-90 90])
axis on
axis equal
grid on
endfunction
