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
## @deftypefn {} {@var{retval} =} GRS80 (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn

## Author: Gabriel Alves Silva <gabsilvalves@gabsilvalves-300E5EV-300E4EV-270E5EV-270E4EV-2470EV-2470EE>
## Created: 2022-04-26

function GRS80
topomapa = imread('topomapa.jpg');
raioEquatorialTerra = 6.378136e+006;
raioPolarTerra = 6.356753e+006;
divisoes = 100;
[x,y,z] = ellipsoid(0,0,0,raioEquatorialTerra,raioEquatorialTerra,raioPolarTerra,divisoes);
superficie = surface(x,y,z);
colormap(gray)
set (superficie, 'facecolor', 'texturemap');
set (superficie, 'CData', flip(topomapa));
set (superficie,'EdgeColor','none');
set (superficie,'LineStyle',':');
set (superficie,'LineWidth',0.1);
axis equal
grid on
view([-30,30])
endfunction
